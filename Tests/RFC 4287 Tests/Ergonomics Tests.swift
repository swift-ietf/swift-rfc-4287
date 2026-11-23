import Testing

@testable import RFC_4287

enum `Ergonomics Tests` {}

extension `Ergonomics Tests` {
    @Suite
    struct `Ergonomic Improvements Tests` {
        @Suite struct Unit {}
        @Suite struct `Edge Case` {}
        @Suite struct Integration {}
    }
}

extension `Ergonomics Tests`.`Ergonomic Improvements Tests`.Unit {
    @Test func `category expressible by string literal`() async throws {
        let category: IETF.RFC.`4287`.Category = "Technology"
        #expect(category.term == "Technology")
        #expect(category.scheme == nil)
        #expect(category.label == nil)

        let categories: [IETF.RFC.`4287`.Category] = ["News", "Sports", "Politics"]
        #expect(categories.count == 3)
        #expect(categories[0].term == "News")
        #expect(categories[1].term == "Sports")
        #expect(categories[2].term == "Politics")
    }

    @Test func `person expressible by string literal`() async throws {
        let person: IETF.RFC.`4287`.Person = "John Doe"
        #expect(person.name == "John Doe")
        #expect(person.uri == nil)
        #expect(person.email == nil)

        let authors: [IETF.RFC.`4287`.Person] = ["Alice", "Bob", "Carol"]
        #expect(authors.count == 3)
        #expect(authors[0].name == "Alice")
        #expect(authors[1].name == "Bob")
        #expect(authors[2].name == "Carol")
    }

    @Test func `link expressible by string literal`() async throws {
        let link: IETF.RFC.`4287`.Link = try .init(href: .init("https://example.com/post"))
        #expect(link.href == "https://example.com/post")
        #expect(link.rel == nil)
        #expect(link.type == nil)
        #expect(link.title == nil)
        #expect(link.length == nil)

        let links: [IETF.RFC.`4287`.Link] = [
            .init(href: "https://example.com/1"),
            .init(href: "https://example.com/2"),
        ]
        #expect(links.count == 2)
        #expect(links[0].href == "https://example.com/1")
        #expect(links[1].href == "https://example.com/2")
    }
}
