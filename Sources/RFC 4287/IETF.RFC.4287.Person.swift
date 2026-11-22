public import RFC_2822
import RFC_3987
public import RFC_5646

extension IETF.RFC.`4287` {

    public struct Person: Hashable, Sendable {

        public let name: String

        public let uri: IETF.RFC.`3987`.IRI?

        public let email: IETF.RFC.`2822`.AddrSpec?

        public let base: IETF.RFC.`3987`.IRI?

        public let lang: IETF.RFC.`5646`.LanguageTag?

        public init(
            name: String,
            uri: IETF.RFC.`3987`.IRI? = nil,
            email: IETF.RFC.`2822`.AddrSpec? = nil,
            base: IETF.RFC.`3987`.IRI? = nil,
            lang: IETF.RFC.`5646`.LanguageTag? = nil
        ) {
            self.name = name
            self.uri = uri
            self.email = email
            self.base = base
            self.lang = lang
        }
    }
}

extension IETF.RFC.`4287`.Person {

    public init(
        name: String,

        uri: (any IETF.RFC.`3987`.IRI.Representable)?,
        email: IETF.RFC.`2822`.AddrSpec? = nil,

        base: (any IETF.RFC.`3987`.IRI.Representable)? = nil,
        lang: IETF.RFC.`5646`.LanguageTag? = nil
    ) {
        self.init(name: name, uri: uri?.iri, email: email, base: base?.iri, lang: lang)
    }

}

extension IETF.RFC.`4287`.Person: ExpressibleByStringLiteral {

    public init(stringLiteral value: String) {
        self.init(name: value, uri: nil, email: nil)
    }
}
