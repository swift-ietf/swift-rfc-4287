import Foundation
import RFC_2822
import Testing

@testable import RFC_4287

@Suite
struct `Person Email Validation` {

    @Test
    func `Person with valid email succeeds`() throws {
        let email = try RFC_2822.AddrSpec(ascii: "john@example.com".utf8)
        let person = RFC_4287.Person(name: "John Doe", uri: nil, email: email)

        #expect(person.name == "John Doe")
        #expect(person.email?.description == "john@example.com")
    }

    @Test
    func `Person with nil email succeeds`() {
        let person = RFC_4287.Person(name: "Jane Doe", uri: nil, email: nil)

        #expect(person.name == "Jane Doe")
        #expect(person.email == nil)
    }

    @Test
    func `Person with URI and email`() throws {
        let email = try RFC_2822.AddrSpec(ascii: "contact@example.org".utf8)
        let person = RFC_4287.Person(
            name: "Contact Person",
            uri: "https://example.org",
            email: email
        )

        #expect(person.name == "Contact Person")
        #expect(person.uri == "https://example.org")
        #expect(person.email?.description == "contact@example.org")
    }

    @Test
    func `Person with convenience emailString initializer`() throws {
        let person = try RFC_4287.Person(
            name: "Test User",
            uri: nil,
            email: .init("test@example.com"),
            base: nil,
            lang: nil
        )

        #expect(person.name == "Test User")
        #expect(person.email?.description == "test@example.com")
    }

    @Test
    func `Invalid email string throws`() {
        #expect(throws: RFC_2822.AddrSpec.Error.self) {
            try RFC_4287.Person(
                name: "Invalid",
                uri: nil,
                email: .init("not-an-email")
            )
        }
    }

    @Test
    func `Email with special characters in local-part`() throws {
        let email = try RFC_2822.AddrSpec(ascii: "user+tag@example.com".utf8)
        let person = RFC_4287.Person(name: "Tagged User", uri: nil, email: email)

        #expect(person.email?.description == "user+tag@example.com")
    }

    @Test
    func `Email with subdomain`() throws {
        let email = try RFC_2822.AddrSpec(ascii: "admin@mail.example.com".utf8)
        let person = RFC_4287.Person(name: "Admin", uri: nil, email: email)

        #expect(person.email?.description == "admin@mail.example.com")
    }
}

@Suite
struct `Person Codable with Email` {

    @Test
    func `Encode Person with email`() throws {
        let email = try RFC_2822.AddrSpec(ascii: "test@example.com".utf8)
        let person = RFC_4287.Person(name: "Test", uri: nil, email: email)

        let encoder = JSONEncoder()
        let data = try encoder.encode(person)
        let json = String(data: data, encoding: .utf8)!

        #expect(json.contains("\"name\":\"Test\""))
        #expect(json.contains("\"email\":\"test@example.com\""))
    }

    @Test
    func `Decode Person with email`() throws {
        let json = """
            {"name":"Decoder","email":"decode@example.com"}
            """

        let decoder = JSONDecoder()
        let person = try decoder.decode(RFC_4287.Person.self, from: json.data(using: .utf8)!)

        #expect(person.name == "Decoder")
        #expect(person.email?.description == "decode@example.com")
    }

    @Test
    func `Decode Person without email`() throws {
        let json = """
            {"name":"No Email"}
            """

        let decoder = JSONDecoder()
        let person = try decoder.decode(RFC_4287.Person.self, from: json.data(using: .utf8)!)

        #expect(person.name == "No Email")
        #expect(person.email == nil)
    }

    @Test
    func `Decode Person with invalid email format throws`() {
        let json = """
            {"name":"Bad","email":"invalid"}
            """

        let decoder = JSONDecoder()
        #expect(throws: DecodingError.self) {
            _ = try decoder.decode(RFC_4287.Person.self, from: json.data(using: .utf8)!)
        }
    }

    @Test
    func `Round-trip encoding preserves email`() throws {
        let email = try RFC_2822.AddrSpec(ascii: "round@trip.com".utf8)
        let original = RFC_4287.Person(name: "Round Trip", uri: "https://trip.com", email: email)

        let encoder = JSONEncoder()
        let data = try encoder.encode(original)

        let decoder = JSONDecoder()
        let decoded = try decoder.decode(RFC_4287.Person.self, from: data)

        #expect(decoded.name == original.name)
        #expect(decoded.uri == original.uri)
        #expect(decoded.email?.description == original.email?.description)
    }
}

@Suite
struct `Person IRI.Representable Integration` {

    @Test
    func `Person with IRI from string literal`() throws {
        let iri: RFC_3987.IRI = "https://example.com/~user"
        let email = try RFC_2822.AddrSpec(ascii: "user@example.com".utf8)
        let person = RFC_4287.Person(name: "User", uri: iri, email: email)

        #expect(person.uri == "https://example.com/~user")
    }

    @Test
    func `Person with Foundation URL via IRI.Representable`() throws {
        let url = URL(string: "https://example.com/~user")!
        let iri: RFC_3987.IRI = try .init(url.absoluteString)
        let email = try RFC_2822.AddrSpec(ascii: "user@example.com".utf8)
        let person = RFC_4287.Person(name: "User", uri: iri, email: email)

        #expect(person.uri == "https://example.com/~user")
    }
}
