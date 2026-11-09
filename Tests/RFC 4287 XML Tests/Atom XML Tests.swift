import RFC_4287
import RFC_4287_XML
import Testing
import W3C_XML

@testable import RFC_4287

@Suite struct `An Atom feed written as XML` {
    func updated() throws -> RFC_3339.DateTime {
        RFC_3339.DateTime(time: try Gregorian.DateTime(year: 2026, month: 11, day: 5, hour: 0, minute: 0, second: 0), offset: .utc)
    }

    func feed(summary: RFC_4287.Summary? = nil) throws -> RFC_4287.Feed {
        try RFC_4287.Feed(
            id: "https://feed.rule.law/nl",
            title: "Wetten & regels",
            updated: try updated(),
            authors: ["rule.law"],
            entries: [
                RFC_4287.Entry(
                    id: "https://feed.rule.law/nl/stb-2026-368",
                    title: "Staatsblad 2026, 368",
                    updated: try updated(),
                    content: RFC_4287.Content(value: "A < B", type: .text),
                    summary: summary
                ),
            ]
        )
    }

    func parsed(_ feed: RFC_4287.Feed) throws -> W3C_XML.Element {
        try W3C_XML.parse(W3C_XML.Document(feed).encode()).root
    }

    @Test func `the root is an Atom feed carrying its id, title and updated time`() throws {
        let root = try parsed(try feed())
        #expect(root.name.local == "feed")
        #expect(root.namespaces.map(\.uri).contains("http://www.w3.org/2005/Atom"))
        let children = Dictionary(root.children.map { ($0.name.local, $0.textContent) }, uniquingKeysWith: { first, _ in first })
        #expect(children["id"] == "https://feed.rule.law/nl")
        #expect(children["title"] == "Wetten & regels")
        #expect(children["updated"] == (try updated()).description)
        #expect(root.children.first { $0.name.local == "author" }?.children.first?.textContent == "rule.law")
    }

    @Test func `an entry carries its id and its text content, escaped and read back whole`() throws {
        let entry = try #require(try parsed(try feed()).children.first { $0.name.local == "entry" })
        #expect(entry.children.first { $0.name.local == "id" }?.textContent == "https://feed.rule.law/nl/stb-2026-368")
        let content = try #require(entry.children.first { $0.name.local == "content" })
        #expect(content.attributes.first { $0.name.local == "type" }?.value == "text")
        #expect(content.textContent == "A < B")
    }

    @Test func `xhtml text is written as an XHTML div, not as escaped markup`() throws {
        let summary = RFC_4287.Summary("<p>In werking <b>1 januari</b></p>", type: .xhtml)
        let entry = try #require(try parsed(try feed(summary: summary)).children.first { $0.name.local == "entry" })
        let written = try #require(entry.children.first { $0.name.local == "summary" })
        let division = try #require(written.children.first)
        #expect(division.name.local == "div")
        #expect(division.namespaces.map(\.uri) == ["http://www.w3.org/1999/xhtml"])
        #expect(division.children.map(\.name.local) == ["p"])
    }
}
