import Testing
@testable import URLShortenerList

struct URLShortenerListTests {
    @Test func listLoads() {
        #expect(URLShortenerList.hosts.count > 500)
        #expect(URLShortenerList.hosts.contains("bit.ly"))
        #expect(URLShortenerList.hosts.allSatisfy { !$0.contains(" ") && $0 == $0.lowercased() })
    }

    @Test func parserSkipsComments() {
        #expect(URLShortenerList.parseHostList("# c\n a.com \nb.io # trailing\n\n") == ["a.com", "b.io"])
    }

    @Test func licenseTextIsBundled() {
        #expect(URLShortenerList.licenseText.contains("Attribution-ShareAlike 4.0 International"))
    }
}
