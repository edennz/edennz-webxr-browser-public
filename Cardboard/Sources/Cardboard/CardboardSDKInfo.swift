import Foundation

/// Facts about the vendored binary for the Acknowledgements screen and diagnostics.
/// Keep `version` and `Protobuf.version` in step with `BUILD-INFO.txt`.
public nonisolated enum CardboardSDKInfo {
    public static let name = "Google Cardboard SDK"
    public static let version = "1.35.0"
    public static let author = "Google LLC"
    public static let sourceURL = URL(string: "https://github.com/googlevr/cardboard")!
    public static let licenseName = "Apache License 2.0"
    public static let licenseURL = URL(string: "https://www.apache.org/licenses/LICENSE-2.0")!
    public static var licenseText: String { text("LICENSE-cardboard-sdk") }

    /// The protobuf C++ runtime statically linked into the SDK archive.
    public enum Protobuf {
        public static let name = "Protocol Buffers (C++ runtime)"
        public static let version = "3.18.0"
        public static let author = "Google Inc."
        public static let sourceURL = URL(string: "https://github.com/protocolbuffers/protobuf")!
        public static let licenseName = "BSD 3-Clause License"
        public static let licenseURL = URL(string: "https://opensource.org/license/bsd-3-clause")!
        public static var licenseText: String { text("LICENSE-protobuf") }
    }

    private static func text(_ resource: String) -> String {
        guard let url = Bundle.module.url(forResource: resource, withExtension: "txt"),
              let text = try? String(contentsOf: url, encoding: .utf8) else { return "" }
        return text
    }
}
