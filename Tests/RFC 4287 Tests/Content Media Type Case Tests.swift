import Testing

@testable import RFC_4287

@Suite
struct `Content media type case` {
    @Test(arguments: ["TEXT/plain", "Text/HTML", "Application/XML", "application/ATOM+XML", "text/plain", "application/xml"])
    func `text and XML media types are compared case-insensitively`(_ mediaType: String) {
        let content = RFC_4287.Content(value: "x", type: .media(mediaType))
        #expect(!content.requiresBase64Encoding)
    }

    @Test(arguments: ["image/png", "Application/Octet-Stream", "application/xmlish"])
    func `other media types require Base64`(_ mediaType: String) {
        let content = RFC_4287.Content(value: "x", type: .media(mediaType))
        #expect(content.requiresBase64Encoding)
    }
}
