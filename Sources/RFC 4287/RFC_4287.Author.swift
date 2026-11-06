public import RFC_2822
import RFC_3987
public import RFC_5646

extension RFC_4287 {

    public struct Author: Hashable, Sendable, Codable {

        public let person: Person

        public init(_ person: Person) {
            self.person = person
        }
    }
}

extension RFC_4287.Author: ExpressibleByStringLiteral {

    public init(stringLiteral value: String) {
        self.init(name: value)
    }
}

extension RFC_4287.Author {

    public var name: String { person.name }

    public var uri: RFC_3987.IRI? { person.uri }

    public var email: RFC_2822.AddrSpec? { person.email }

    public var base: RFC_3987.IRI? { person.base }

    public var lang: RFC_5646.LanguageTag? { person.lang }
}

extension RFC_4287.Author {

    public init(
        name: String,

        uri: (any RFC_3987.IRI.Representable)? = nil,
        email: RFC_2822.AddrSpec? = nil,

        base: (any RFC_3987.IRI.Representable)? = nil,
        lang: RFC_5646.LanguageTag? = nil
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
