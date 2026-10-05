import Foundation

/// Access to the bundled URL shortener domain list and the attribution its
/// license requires.
///
/// The list (`Resources/list.txt`) is the unmodified `list` file from
/// https://github.com/PeterDaveHello/url-shorteners, licensed under
/// Creative Commons Attribution-ShareAlike 4.0 International. Apps that
/// bundle it must show the attribution and license (see `notice`), which the
/// host app does on its Acknowledgements screen.
public nonisolated enum URLShortenerList {
    public static let name = "URL shortener domain list"
    public static let author = "Peter Dave Hello and contributors"
    public static let sourceURL = URL(string: "https://github.com/PeterDaveHello/url-shorteners")!
    public static let licenseName = "Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)"
    public static let licenseURL = URL(string: "https://creativecommons.org/licenses/by-sa/4.0/")!
    /// Attribution statement in the form the license asks for (creator, title,
    /// source, license, modifications).
    public static let attribution = "\"\(name)\" by \(author), from \(sourceURL.absoluteString), is licensed under \(licenseName). Included unmodified."

    /// Hosts in the list, lowercased, comments and blank lines removed.
    public static let hosts: [String] = {
        guard let url = Bundle.module.url(forResource: "list", withExtension: "txt"),
              let text = try? String(contentsOf: url, encoding: .utf8) else { return [] }
        return parseHostList(text)
    }()

    /// Full license text (the CC BY-SA 4.0 legal code shipped with the list).
    public static var licenseText: String {
        guard let url = Bundle.module.url(forResource: "LICENSE", withExtension: "txt"),
              let text = try? String(contentsOf: url, encoding: .utf8) else { return licenseName }
        return text
    }

    /// One host per line; `#` starts a comment; blank lines ignored.
    public static func parseHostList(_ text: String) -> [String] {
        text.split(whereSeparator: \.isNewline).compactMap { line in
            let content = line.split(separator: "#", maxSplits: 1, omittingEmptySubsequences: false).first.map(String.init) ?? ""
            let host = content.trimmingCharacters(in: .whitespaces).lowercased()
            return host.isEmpty ? nil : host
        }
    }
}
