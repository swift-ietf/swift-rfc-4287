import Testing

@testable import RFC_4287

@Suite
struct `Ergonomic Improvements Tests` {
    @Test func categoryExpressibleByStringLiteral() async throws {
        let category: RFC_4287.Category = "Technology"
        #expect(category.term == "Technology")
        #expect(category.scheme == nil)
        #expect(category.label == nil)

        // Test in array context
        let categories: [RFC_4287.Category] = ["News", "Sports", "Politics"]
        #expect(categories.count == 3)
        #expect(categories[0].term == "News")
        #expect(categories[1].term == "Sports")
        #expect(categories[2].term == "Politics")
    }

    @Test func personExpressibleByStringLiteral() async throws {
        let person: RFC_4287.Person = "John Doe"
        #expect(person.name == "John Doe")
        #expect(person.uri == nil)
        #expect(person.email == nil)

        // Test in array context (authors)
        let authors: [RFC_4287.Person] = ["Alice", "Bob", "Carol"]
        #expect(authors.count == 3)
        #expect(authors[0].name == "Alice")
        #expect(authors[1].name == "Bob")
        #expect(authors[2].name == "Carol")
    }

    @Test func linkExpressibleByStringLiteral() async throws {
        let link: RFC_4287.Link = try .init(href: .init("https://example.com/post"))
        #expect(link.href == "https://example.com/post")
        #expect(link.rel == nil)
        #expect(link.type == nil)
        #expect(link.title == nil)
        #expect(link.length == nil)

        // Test in array context
        let links: [RFC_4287.Link] = [
            .init(href: "https://example.com/1"),
            .init(href: "https://example.com/2"),
        ]
        #expect(links.count == 2)
        #expect(links[0].href == "https://example.com/1")
        #expect(links[1].href == "https://example.com/2")
    }
}
