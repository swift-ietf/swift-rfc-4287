import RFC_9110
import Testing

@testable import RFC_4287

enum `Content Media Type Case Tests` {}

extension `Content Media Type Case Tests` {
    @Suite
    struct `Content media type case` {
        @Test(arguments: ["TEXT/plain", "Text/HTML", "Application/XML", "application/ATOM+XML", "text/plain", "application/xml"])
        func `text and XML media types are compared case-insensitively`(_ mediaType: String) throws {
            let content = RFC_4287.Content(value: "x", type: .media(try #require(RFC_9110.MediaType(parsing: mediaType))))
            #expect(!content.requiresBase64Encoding)
        }

        @Test(arguments: ["image/png", "Application/Octet-Stream", "application/xmlish"])
        func `other media types require Base64`(_ mediaType: String) throws {
            let content = RFC_4287.Content(value: "x", type: .media(try #require(RFC_9110.MediaType(parsing: mediaType))))
            #expect(content.requiresBase64Encoding)
        }
    }
}
