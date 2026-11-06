import Foundation
import RFC_5646
import Testing

@testable import RFC_4287

@Suite
struct `Language decoding` {
    @Test
    func `a well-formed lang decodes in canonical form`() throws {
        let json = Data(#"{"type":"text","value":"x","lang":"en-us"}"#.utf8)
        #expect(try JSONDecoder().decode(RFC_4287.Text.self, from: json).lang?.value == "en-US")
    }

    @Test
    func `a malformed lang reads as absent in a synthesized Decodable`() throws {
        let json = Data(#"{"type":"text","value":"x","lang":"not a tag!"}"#.utf8)
        #expect(try JSONDecoder().decode(RFC_4287.Text.self, from: json).lang == nil)
    }

    @Test
    func `a malformed lang reads as absent in a hand-written Decodable`() throws {
        let json = Data(#"{"name":"x","lang":"not a tag!"}"#.utf8)
        #expect(try JSONDecoder().decode(RFC_4287.Person.self, from: json).lang == nil)
    }
}
