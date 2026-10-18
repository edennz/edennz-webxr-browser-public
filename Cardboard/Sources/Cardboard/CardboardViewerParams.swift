import CardboardSDK
import Foundation

/// A serialized `cardboard.DeviceParams` message: the viewer profile that Cardboard viewer QR
/// codes carry and that the SDK's lens model consumes verbatim. Only the fields needed for
/// display and validation are decoded here, with a minimal protobuf wire-format reader; the
/// SDK parses the full message itself.
public nonisolated struct CardboardViewerParams: Sendable, Hashable, Codable {
    /// The encoded protobuf bytes, handed to `CardboardLensDistortion_create` unchanged.
    public let encoded: Data
    public let vendor: String
    public let model: String
    /// Distance between the lens centers, in meters.
    public let interLensDistance: Float
    /// Distance from the screen to the lenses, in meters.
    public let screenToLensDistance: Float

    /// Fails unless the bytes decode as a message with the lens fields the SDK needs
    /// (screen-to-lens distance, inter-lens distance, four field-of-view angles and at
    /// least one distortion coefficient).
    public init?(encoded: Data) {
        guard !encoded.isEmpty, let fields = DeviceParamsReader.read(encoded),
              let screenToLens = fields.floats[3]?.first, screenToLens > 0,
              let interLens = fields.floats[4]?.first, interLens > 0,
              let fieldOfView = fields.floats[5], fieldOfView.count == 4,
              let coefficients = fields.floats[7], !coefficients.isEmpty else { return nil }
        self.encoded = encoded
        vendor = fields.strings[1] ?? ""
        model = fields.strings[2] ?? ""
        interLensDistance = interLens
        screenToLensDistance = screenToLens
    }

    public var displayName: String {
        switch (vendor.isEmpty, model.isEmpty) {
        case (true, true): "Unknown viewer"
        case (true, false): model
        case (false, true): vendor
        case (false, false): model.localizedCaseInsensitiveContains(vendor) ? model : "\(vendor) \(model)"
        }
    }

    // MARK: Built-in viewers

    /// The original Google Cardboard (2014), as embedded in the SDK.
    public static let cardboardV1: CardboardViewerParams = {
        var bytes: UnsafeMutablePointer<UInt8>? = nil
        var size: Int32 = 0
        CardboardQrCode_getCardboardV1DeviceParams(&bytes, &size)
        defer { if let bytes { CardboardQrCode_destroy(bytes) } }
        guard let bytes, size > 0, let params = CardboardViewerParams(encoded: Data(bytes: bytes, count: Int(size))) else {
            preconditionFailure("Cardboard SDK returned invalid Cardboard v1 device params")
        }
        return params
    }()

    /// Google Cardboard I/O 2015 ("Cardboard v2"), the viewer most third-party viewers are
    /// modeled on. This is the URL printed as the QR code on the viewer itself.
    public static let cardboardV2ProfileURL = URL(string: "https://google.com/cardboard/cfg?p=CgZHb29nbGUSEkNhcmRib2FyZCBJL08gMjAxNR0rGBU9JQHegj0qEAAASEIAAEhCAABIQgAASEJYADUpXA89OggeZnc-Ehl6PlAAYAM")!

    public static let cardboardV2: CardboardViewerParams = {
        guard let params = parse(profileURL: cardboardV2ProfileURL) else { preconditionFailure("embedded Cardboard v2 profile is invalid") }
        return params
    }()

    // MARK: Viewer QR payloads

    static let profileURLPrefix = "https://google.com/cardboard/cfg"
    static let originalViewerURL = "https://g.co/cardboard"

    /// The two URL shapes the SDK recognizes: `https://google.com/cardboard/cfg?p=<base64url>`
    /// carries the parameters itself and `https://g.co/cardboard` is the 2014 viewer. Any other
    /// URL on a viewer (a short link) has to be resolved by following redirects until one of
    /// these appears.
    public static func isProfileURL(_ url: URL) -> Bool {
        let text = upgradedToHTTPS(url).absoluteString
        return text.hasPrefix(profileURLPrefix) || text == originalViewerURL
    }

    /// Decodes a profile URL without network access. Nil if `url` is not a profile URL or its
    /// payload is not a valid viewer.
    public static func parse(profileURL url: URL) -> CardboardViewerParams? {
        let url = upgradedToHTTPS(url)
        if url.absoluteString == originalViewerURL { return cardboardV1 }
        guard url.absoluteString.hasPrefix(profileURLPrefix),
              let items = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems,
              let payload = items.first(where: { $0.name == "p" })?.value,
              let data = base64URLDecode(payload) else { return nil }
        return CardboardViewerParams(encoded: data)
    }

    /// Normalizes a scanned QR payload into an https URL the way the SDK does (bare hosts get a
    /// scheme, http becomes https). Nil for payloads that are not URLs.
    public static func url(fromQRPayload payload: String) -> URL? {
        var text = payload.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return nil }
        let lower = text.lowercased()
        if !lower.hasPrefix("http://") && !lower.hasPrefix("https://") { text = "https://" + text }
        guard let url = URL(string: text), let host = url.host, !host.isEmpty, host.contains(".") else { return nil }
        return upgradedToHTTPS(url)
    }

    static func upgradedToHTTPS(_ url: URL) -> URL {
        guard url.scheme?.lowercased() == "http", var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return url }
        components.scheme = "https"
        return components.url ?? url
    }

    private static func base64URLDecode(_ text: String) -> Data? {
        var standard = text.replacingOccurrences(of: "-", with: "+").replacingOccurrences(of: "_", with: "/")
        standard += String(repeating: "=", count: (4 - standard.count % 4) % 4)
        return Data(base64Encoded: standard)
    }
}

/// Minimal protobuf wire-format reader for the `cardboard.DeviceParams` fields that are
/// displayed or validated: `vendor` (1), `model` (2), `screen_to_lens_distance` (3),
/// `inter_lens_distance` (4), `left_eye_field_of_view_angles` (5, packed) and
/// `distortion_coefficients` (7, packed). Everything else is skipped.
nonisolated enum DeviceParamsReader {
    struct Fields {
        var strings: [Int: String] = [:]
        var floats: [Int: [Float]] = [:]
        var varints: [Int: UInt64] = [:]
    }

    static func read(_ data: Data) -> Fields? {
        let bytes = [UInt8](data)
        var fields = Fields()
        var index = 0

        func readVarint() -> UInt64? {
            var value: UInt64 = 0
            var shift: UInt64 = 0
            while index < bytes.count {
                let byte = bytes[index]
                index += 1
                value |= UInt64(byte & 0x7f) << shift
                if byte & 0x80 == 0 { return value }
                shift += 7
                if shift > 63 { return nil }
            }
            return nil
        }

        func float(at offset: Int) -> Float {
            let bits = UInt32(bytes[offset]) | UInt32(bytes[offset + 1]) << 8 | UInt32(bytes[offset + 2]) << 16 | UInt32(bytes[offset + 3]) << 24
            return Float(bitPattern: bits)
        }

        while index < bytes.count {
            guard let key = readVarint() else { return nil }
            let field = Int(key >> 3)
            switch key & 7 {
            case 0:
                guard let value = readVarint() else { return nil }
                fields.varints[field] = value
            case 1:
                guard index + 8 <= bytes.count else { return nil }
                index += 8
            case 2:
                guard let length = readVarint(), length <= UInt64(bytes.count - index) else { return nil }
                let start = index
                index += Int(length)
                switch field {
                case 1, 2:
                    fields.strings[field] = String(decoding: bytes[start..<index], as: UTF8.self)
                case 5, 7:
                    guard length % 4 == 0 else { return nil }
                    fields.floats[field, default: []] += stride(from: start, to: index, by: 4).map { float(at: $0) }
                default:
                    break
                }
            case 5:
                guard index + 4 <= bytes.count else { return nil }
                fields.floats[field, default: []].append(float(at: index))
                index += 4
            default:
                return nil   // groups (3, 4) and reserved wire types
            }
        }
        return fields
    }
}
