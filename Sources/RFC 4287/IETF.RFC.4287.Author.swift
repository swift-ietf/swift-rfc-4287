public import RFC_2822
import RFC_3987
public import RFC_5646

extension IETF.RFC.`4287` {

    public struct Author: Hashable, Sendable, Codable {

        public let person: Person

        public init(_ person: Person) {
            self.person = person
        }
    }
}

extension IETF.RFC.`4287`.Author: ExpressibleByStringLiteral {

    public init(stringLiteral value: String) {
        self.init(name: value)
    }
}

extension IETF.RFC.`4287`.Author {

    public var name: String { person.name }

    public var uri: IETF.RFC.`3987`.IRI? { person.uri }

    public var email: IETF.RFC.`2822`.AddrSpec? { person.email }

    public var base: IETF.RFC.`3987`.IRI? { person.base }

    public var lang: IETF.RFC.`5646`.LanguageTag? { person.lang }
}

extension IETF.RFC.`4287`.Author {

    public init(
        name: String,

        uri: (any IETF.RFC.`3987`.IRI.Representable)? = nil,
        email: IETF.RFC.`2822`.AddrSpec? = nil,

        base: (any IETF.RFC.`3987`.IRI.Representable)? = nil,
        lang: IETF.RFC.`5646`.LanguageTag? = nil
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
