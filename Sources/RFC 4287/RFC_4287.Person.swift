public import RFC_2822
import RFC_3987
public import RFC_5646

extension RFC_4287 {

    public struct Person: Hashable, Sendable {

        public let name: String

        public let uri: RFC_3987.IRI?

        public let email: RFC_2822.AddrSpec?

        public let base: RFC_3987.IRI?

        public let lang: RFC_5646.LanguageTag?

        public init(
            name: String,
            uri: RFC_3987.IRI? = nil,
            email: RFC_2822.AddrSpec? = nil,
            base: RFC_3987.IRI? = nil,
            lang: RFC_5646.LanguageTag? = nil
        ) {
            self.name = name
            self.uri = uri
            self.email = email
            self.base = base
            self.lang = lang
        }
    }
}

extension RFC_4287.Person {

    public init(
        name: String,

        uri: (any RFC_3987.IRI.Representable)?,
        email: RFC_2822.AddrSpec? = nil,

        base: (any RFC_3987.IRI.Representable)? = nil,
        lang: RFC_5646.LanguageTag? = nil
    ) {
        self.init(name: name, uri: uri?.iri, email: email, base: base?.iri, lang: lang)
    }

}

extension RFC_4287.Person: ExpressibleByStringLiteral {

    public init(stringLiteral value: String) {
        self.init(name: value, uri: nil, email: nil)
    }
}
