import RFC_3987
public import RFC_5646

extension IETF.RFC.`4287` {

    public struct Feed: Hashable, Sendable, Codable {

        public let authors: [Author]

        public let categories: [Category]

        public let contributors: [Contributor]

        public let generator: Generator?

        public let icon: IETF.RFC.`3987`.IRI?

        public let id: IETF.RFC.`3987`.IRI

        public let links: [Link]

        public let logo: IETF.RFC.`3987`.IRI?

        public let rights: Rights?

        public let subtitle: Subtitle?

        public let title: Title

        public let updated: IETF.RFC.`3339`.DateTime

        public let base: IETF.RFC.`3987`.IRI?

        public let lang: IETF.RFC.`5646`.LanguageTag?

        public let entries: [Entry]
    }
}

extension IETF.RFC.`4287`.Feed {

    public init(
        id: IETF.RFC.`3987`.IRI,
        title: IETF.RFC.`4287`.Title,
        updated: IETF.RFC.`3339`.DateTime,
        authors: [IETF.RFC.`4287`.Author] = [],
        entries: [IETF.RFC.`4287`.Entry] = [],
        links: [IETF.RFC.`4287`.Link] = [],
        categories: [IETF.RFC.`4287`.Category] = [],
        contributors: [IETF.RFC.`4287`.Contributor] = [],
        generator: IETF.RFC.`4287`.Generator? = nil,
        icon: IETF.RFC.`3987`.IRI? = nil,
        logo: IETF.RFC.`3987`.IRI? = nil,
        rights: IETF.RFC.`4287`.Rights? = nil,
        subtitle: IETF.RFC.`4287`.Subtitle? = nil,
        base: IETF.RFC.`3987`.IRI? = nil,
        lang: IETF.RFC.`5646`.LanguageTag? = nil
    ) throws(Error) {

        let feedHasAuthors = !authors.isEmpty
        let allEntriesHaveAuthors = entries.allSatisfy { !$0.authors.isEmpty }

        guard feedHasAuthors || entries.isEmpty || allEntriesHaveAuthors else {
            throw Error.blank
        }

        self.id = id
        self.title = title
        self.updated = updated
        self.authors = authors
        self.entries = entries
        self.links = links
        self.categories = categories
        self.contributors = contributors
        self.generator = generator
        self.icon = icon
        self.logo = logo
        self.rights = rights
        self.subtitle = subtitle
        self.base = base
        self.lang = lang
    }

    public init?(
        id: some IETF.RFC.`3987`.IRI.Representable,
        title: IETF.RFC.`4287`.Title,
        updated: IETF.RFC.`3339`.DateTime,
        authors: [IETF.RFC.`4287`.Author] = [],
        entries: [IETF.RFC.`4287`.Entry] = [],
        links: [IETF.RFC.`4287`.Link] = [],
        categories: [IETF.RFC.`4287`.Category] = [],
        contributors: [IETF.RFC.`4287`.Contributor] = [],
        generator: IETF.RFC.`4287`.Generator? = nil,

        icon: (any IETF.RFC.`3987`.IRI.Representable)? = nil,

        logo: (any IETF.RFC.`3987`.IRI.Representable)? = nil,
        rights: IETF.RFC.`4287`.Rights? = nil,
        subtitle: IETF.RFC.`4287`.Subtitle? = nil,

        base: (any IETF.RFC.`3987`.IRI.Representable)? = nil,
        lang: IETF.RFC.`5646`.LanguageTag? = nil
    ) throws(Error) {
        try self.init(
            id: id.iri,
            title: title,
            updated: updated,
            authors: authors,
            entries: entries,
            links: links,
            categories: categories,
            contributors: contributors,
            generator: generator,
            icon: icon?.iri,
            logo: logo?.iri,
            rights: rights,
            subtitle: subtitle,
            base: base?.iri,
            lang: lang
        )
    }

}
