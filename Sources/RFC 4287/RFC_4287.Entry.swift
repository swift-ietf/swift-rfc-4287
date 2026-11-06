import RFC_3987
public import RFC_5646

extension RFC_4287 {

    public struct Entry: Hashable, Sendable, Codable {

        public let authors: [Author]

        public let categories: [Category]

        public let content: Content?

        public let contributors: [Contributor]

        public let id: RFC_3987.IRI

        public let links: [Link]

        public let updated: RFC_3339.DateTime

        public let published: RFC_3339.DateTime?

        public let rights: Rights?

        public let source: Source?

        public let summary: Summary?

        public let title: Title

        public let base: RFC_3987.IRI?

        public let lang: RFC_5646.LanguageTag?
    }
}

extension RFC_4287.Entry {

    public init(
        id: RFC_3987.IRI,
        title: RFC_4287.Title,
        updated: RFC_3339.DateTime,
        authors: [RFC_4287.Author] = [],
        content: RFC_4287.Content? = nil,
        links: [RFC_4287.Link] = [],
        categories: [RFC_4287.Category] = [],
        contributors: [RFC_4287.Contributor] = [],
        published: RFC_3339.DateTime? = nil,
        rights: RFC_4287.Rights? = nil,
        source: RFC_4287.Source? = nil,
        summary: RFC_4287.Summary? = nil,
        base: RFC_3987.IRI? = nil,
        lang: RFC_5646.LanguageTag? = nil
    ) throws(Error) {

        let hasContent = content != nil
        let hasAlternateLink = links.contains { $0.isAlternate }

        guard hasContent || hasAlternateLink else {
            throw Error.blank
        }

        if let content {
            let summaryRequired = content.src != nil || content.requiresBase64Encoding
            if summaryRequired && summary == nil {
                throw Error.blank
            }
        }

        self.id = id
        self.title = title
        self.updated = updated
        self.authors = authors
        self.content = content
        self.links = links
        self.categories = categories
        self.contributors = contributors
        self.published = published
        self.rights = rights
        self.source = source
        self.summary = summary
        self.base = base
        self.lang = lang
    }

    public init?(
        id: some RFC_3987.IRI.Representable,
        title: RFC_4287.Title,
        updated: RFC_3339.DateTime,
        authors: [RFC_4287.Author] = [],
        content: RFC_4287.Content? = nil,
        links: [RFC_4287.Link] = [],
        categories: [RFC_4287.Category] = [],
        contributors: [RFC_4287.Contributor] = [],
        published: RFC_3339.DateTime? = nil,
        rights: RFC_4287.Rights? = nil,
        source: RFC_4287.Source? = nil,
        summary: RFC_4287.Summary? = nil,

        base: (any RFC_3987.IRI.Representable)? = nil,
        lang: RFC_5646.LanguageTag? = nil
    ) throws(Error) {
        try self.init(
            id: id.iri,
            title: title,
            updated: updated,
            authors: authors,
            content: content,
            links: links,
            categories: categories,
            contributors: contributors,
            published: published,
            rights: rights,
            source: source,
            summary: summary,
            base: base?.iri,
            lang: lang
        )
    }

}
