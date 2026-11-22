import RFC_3987
public import RFC_5646

extension IETF.RFC.`4287` {

    public struct Category: Hashable, Sendable, Codable {

        public let term: String

        public let scheme: IETF.RFC.`3987`.IRI?

        public let label: String?

        public let base: IETF.RFC.`3987`.IRI?

        public let lang: IETF.RFC.`5646`.LanguageTag?

        public init(
            term: String,
            scheme: IETF.RFC.`3987`.IRI? = nil,
            label: String? = nil,
            base: IETF.RFC.`3987`.IRI? = nil,
            lang: IETF.RFC.`5646`.LanguageTag? = nil
        ) {
            self.term = term
            self.scheme = scheme
            self.label = label
            self.base = base
            self.lang = lang
        }

    }
}

extension IETF.RFC.`4287`.Category {

    public init(
        term: String,

        scheme: (any IETF.RFC.`3987`.IRI.Representable)?,
        label: String? = nil,

        base: (any IETF.RFC.`3987`.IRI.Representable)? = nil,
        lang: IETF.RFC.`5646`.LanguageTag? = nil
    ) {
        self.init(term: term, scheme: scheme?.iri, label: label, base: base?.iri, lang: lang)
    }
}

extension IETF.RFC.`4287`.Category: ExpressibleByStringLiteral {

    public init(stringLiteral value: String) {
        self.init(term: value, scheme: nil, label: nil)
    }
}
