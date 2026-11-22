import RFC_3987
public import RFC_5646

extension IETF.RFC.`4287` {

    public struct Link: Hashable, Sendable, Codable {

        public let href: IETF.RFC.`3987`.IRI

        public let rel: Relation?

        public let type: String?

        public let hreflang: String?

        public let title: String?

        public let length: Int?

        public let base: IETF.RFC.`3987`.IRI?

        public let lang: IETF.RFC.`5646`.LanguageTag?

        public init(
            href: IETF.RFC.`3987`.IRI,
            rel: Relation? = nil,
            type: String? = nil,
            hreflang: String? = nil,
            title: String? = nil,
            length: Int? = nil,
            base: IETF.RFC.`3987`.IRI? = nil,
            lang: IETF.RFC.`5646`.LanguageTag? = nil
        ) {
            self.href = href
            self.rel = rel
            self.type = type
            self.hreflang = hreflang
            self.title = title
            self.length = length
            self.base = base
            self.lang = lang
        }

        public init(
            href: some IETF.RFC.`3987`.IRI.Representable,
            rel: Relation? = nil,
            type: String? = nil,
            hreflang: String? = nil,
            title: String? = nil,
            length: Int? = nil,

            base: (any IETF.RFC.`3987`.IRI.Representable)? = nil,
            lang: IETF.RFC.`5646`.LanguageTag? = nil
        ) {
            self.init(
                href: href.iri,
                rel: rel,
                type: type,
                hreflang: hreflang,
                title: title,
                length: length,
                base: base?.iri,
                lang: lang
            )
        }
    }
}

extension IETF.RFC.`4287`.Link {

    public var isAlternate: Bool {
        rel == .alternate || rel == nil
    }
}
