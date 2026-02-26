import Foundation
import Testing

@testable import RFC_4287

// Helper to create current date-time
private func currentDateTime() throws -> RFC_3339.DateTime {
    let time = try Time(year: 2024, month: 11, day: 27, hour: 12, minute: 0, second: 0)
    return RFC_3339.DateTime(time: time, offset: .utc)
}

@Suite
struct `README Verification` {

    @Test
    func `String literal feed creation (README line 64-68)`() throws {
        // String literals (recommended - clean and simple)
        let feed = try RFC_4287.Feed(
            id: "https://example.com/feed",
            title: "My Feed",
            updated: try currentDateTime()
        )

        #expect(feed.id.value == "https://example.com/feed")
        #expect(feed.title.value == "My Feed")
    }

    @Test
    func `Explicit IRI feed creation (README line 70-72)`() throws {
        // Explicit IRI type
        let id: RFC_3987.IRI = try .init("https://example.com/feed")
        let feed = try RFC_4287.Feed(id: id, title: "My Feed", updated: try currentDateTime())

        #expect(feed.id == id)
    }

    @Test
    func `Foundation URL feed creation (README line 74-76)`() throws {
        // Foundation URL converted to IRI
        let url = URL(string: "https://example.com/feed")!
        let iri = try RFC_3987.IRI(url.absoluteString)
        let feed = try RFC_4287.Feed(id: iri, title: "My Feed", updated: try currentDateTime())

        #expect(feed.id.value == "https://example.com/feed")
    }

    @Test
    func `Quick Start example (README line 85-101)`() throws {
        // Create an Atom feed
        let feed = try RFC_4287.Feed(
            id: "urn:uuid:60a76c80-d399-11d9-b93C-0003939e0af6",
            title: "Example Feed",
            updated: try currentDateTime(),
            authors: ["John Doe"],
            entries: [
                RFC_4287.Entry(
                    id: "urn:uuid:1225c695-cfb8-4ebb-aaaa-80da344efa6a",
                    title: "First Post",
                    updated: try currentDateTime(),
                    content: RFC_4287.Content(value: "Hello, world!", type: .text)
                )
            ]
        )

        #expect(feed.authors.count == 1)
        #expect(feed.entries.count == 1)
        #expect(feed.entries.first?.title.value == "First Post")
    }

    @Test
    func `Creating entries with links (README line 111-124)`() throws {
        let entry: RFC_4287.Entry = try .init(
            id: "urn:uuid:entry-123",
            title: "Blog Post",
            updated: try currentDateTime(),
            links: [
                RFC_4287.Link(
                    href: "https://example.com/posts/123",
                    rel: .alternate,
                    type: "text/html"
                )
            ]
        )

        #expect(entry.links.first?.href.value == "https://example.com/posts/123")
    }
}
