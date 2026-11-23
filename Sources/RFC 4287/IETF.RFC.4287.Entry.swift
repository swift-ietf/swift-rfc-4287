import RFC_3987
public import RFC_5646

extension IETF.RFC.`4287` {

    public struct Entry: Hashable, Sendable, Codable {

        public let authors: [Author]

        public let categories: [Category]

        public let content: Content?

        public let contributors: [Contributor]

        public let id: IETF.RFC.`3987`.IRI

        public let links: [Link]

        public let updated: IETF.RFC.`3339`.DateTime

        public let published: IETF.RFC.`3339`.DateTime?

        public let rights: Rights?

        public let source: Source?

        public let summary: Summary?

        public let title: Title

        public let base: IETF.RFC.`3987`.IRI?

        public let lang: IETF.RFC.`5646`.Tag?
    }
}

extension IETF.RFC.`4287`.Entry {

    public init(
        id: IETF.RFC.`3987`.IRI,
        title: IETF.RFC.`4287`.Title,
        updated: IETF.RFC.`3339`.DateTime,
        authors: [IETF.RFC.`4287`.Author] = [],
        content: IETF.RFC.`4287`.Content? = nil,
        links: [IETF.RFC.`4287`.Link] = [],
        categories: [IETF.RFC.`4287`.Category] = [],
        contributors: [IETF.RFC.`4287`.Contributor] = [],
        published: IETF.RFC.`3339`.DateTime? = nil,
        rights: IETF.RFC.`4287`.Rights? = nil,
        source: IETF.RFC.`4287`.Source? = nil,
        summary: IETF.RFC.`4287`.Summary? = nil,
        base: IETF.RFC.`3987`.IRI? = nil,
        lang: IETF.RFC.`5646`.Tag? = nil
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
        id: some IETF.RFC.`3987`.IRI.Representable,
        title: IETF.RFC.`4287`.Title,
        updated: IETF.RFC.`3339`.DateTime,
        authors: [IETF.RFC.`4287`.Author] = [],
        content: IETF.RFC.`4287`.Content? = nil,
        links: [IETF.RFC.`4287`.Link] = [],
        categories: [IETF.RFC.`4287`.Category] = [],
        contributors: [IETF.RFC.`4287`.Contributor] = [],
        published: IETF.RFC.`3339`.DateTime? = nil,
        rights: IETF.RFC.`4287`.Rights? = nil,
        source: IETF.RFC.`4287`.Source? = nil,
        summary: IETF.RFC.`4287`.Summary? = nil,

        base: (any IETF.RFC.`3987`.IRI.Representable)? = nil,
        lang: IETF.RFC.`5646`.Tag? = nil
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
