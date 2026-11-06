import RFC_3987
public import RFC_5646

extension RFC_4287 {

    public struct Feed: Hashable, Sendable, Codable {

        public let authors: [Author]

        public let categories: [Category]

        public let contributors: [Contributor]

        public let generator: Generator?

        public let icon: RFC_3987.IRI?

        public let id: RFC_3987.IRI

        public let links: [Link]

        public let logo: RFC_3987.IRI?

        public let rights: Rights?

        public let subtitle: Subtitle?

        public let title: Title

        public let updated: RFC_3339.DateTime

        public let base: RFC_3987.IRI?

        public let lang: RFC_5646.LanguageTag?

        public let entries: [Entry]
    }
}

extension RFC_4287.Feed {

    public init(
        id: RFC_3987.IRI,
        title: RFC_4287.Title,
        updated: RFC_3339.DateTime,
        authors: [RFC_4287.Author] = [],
        entries: [RFC_4287.Entry] = [],
        links: [RFC_4287.Link] = [],
        categories: [RFC_4287.Category] = [],
        contributors: [RFC_4287.Contributor] = [],
        generator: RFC_4287.Generator? = nil,
        icon: RFC_3987.IRI? = nil,
        logo: RFC_3987.IRI? = nil,
        rights: RFC_4287.Rights? = nil,
        subtitle: RFC_4287.Subtitle? = nil,
        base: RFC_3987.IRI? = nil,
        lang: RFC_5646.LanguageTag? = nil
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
        id: some RFC_3987.IRI.Representable,
        title: RFC_4287.Title,
        updated: RFC_3339.DateTime,
        authors: [RFC_4287.Author] = [],
        entries: [RFC_4287.Entry] = [],
        links: [RFC_4287.Link] = [],
        categories: [RFC_4287.Category] = [],
        contributors: [RFC_4287.Contributor] = [],
        generator: RFC_4287.Generator? = nil,

        icon: (any RFC_3987.IRI.Representable)? = nil,

        logo: (any RFC_3987.IRI.Representable)? = nil,
        rights: RFC_4287.Rights? = nil,
        subtitle: RFC_4287.Subtitle? = nil,

        base: (any RFC_3987.IRI.Representable)? = nil,
        lang: RFC_5646.LanguageTag? = nil
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
