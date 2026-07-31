public import RFC_2822
import RFC_3987

extension RFC_4287 {
    /// An author person construct as defined in RFC 4287
    ///
    /// Represents the author element used in feeds and entries.
    public struct Author: Hashable, Sendable, Codable {
        /// The underlying person construct
        public let person: Person

        /// Creates a new author
        ///
        /// - Parameter person: The person construct
        public init(_ person: Person) {
            self.person = person
        }
    }
}

// MARK: - ExpressibleByStringLiteral

extension RFC_4287.Author: ExpressibleByStringLiteral {
    /// Creates an author from a string literal (name only)
    public init(stringLiteral value: String) {
        self.init(name: value)
    }
}

extension RFC_4287.Author {

    /// The person's name
    public var name: String { person.name }

    /// URI associated with the person
    public var uri: RFC_3987.IRI? { person.uri }

    /// Email address
    public var email: RFC_2822.AddrSpec? { person.email }

    /// Base IRI for resolving relative references
    public var base: RFC_3987.IRI? { person.base }

    /// Language of the content
    public var lang: String? { person.lang }
}

extension RFC_4287.Author {

    /// Creates a new author with the given details
    ///
    /// - Parameters:
    ///   - name: The person's name (required)
    ///   - uri: URI associated with the person
    ///   - email: Email address
    ///   - base: Base IRI for resolving relative references
    ///   - lang: Language of the content
    public init(
        name: String,
        // REASON: nil-defaulted optional existential parameter; no lawful generic spelling (T? = nil defeats inference); rule-scope refinement tracked at swift-foundations/swift-linter-rules#4
        // swiftlint:disable:next no_any_protocol_existential
        uri: (any RFC_3987.IRI.Representable)? = nil,
        email: RFC_2822.AddrSpec? = nil,
        // REASON: nil-defaulted optional existential parameter; no lawful generic spelling (T? = nil defeats inference); rule-scope refinement tracked at swift-foundations/swift-linter-rules#4
        // swiftlint:disable:next no_any_protocol_existential
        base: (any RFC_3987.IRI.Representable)? = nil,
        lang: String? = nil
    ) {
        self.person = .init(
            name: name,
            uri: uri?.iri,
            email: email,
            base: base?.iri,
            lang: lang
        )
    }
}
