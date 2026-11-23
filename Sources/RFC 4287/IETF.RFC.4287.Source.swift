import RFC_3987
public import RFC_5646

extension IETF.RFC.`4287` {

    public struct Source: Hashable, Sendable, Codable {

        public let authors: [Author]

        public let categories: [Category]

        public let contributors: [Contributor]

        public let generator: Generator?

        public let icon: IETF.RFC.`3987`.IRI?

        public let id: IETF.RFC.`3987`.IRI?

        public let links: [Link]

        public let logo: IETF.RFC.`3987`.IRI?

        public let rights: Rights?

        public let subtitle: Subtitle?

        public let title: Title?

        public let updated: IETF.RFC.`3339`.DateTime?

        public let base: IETF.RFC.`3987`.IRI?

        public let lang: IETF.RFC.`5646`.Tag?

        public init(
            authors: [Author] = [],
            categories: [Category] = [],
            contributors: [Contributor] = [],
            generator: Generator? = nil,
            icon: IETF.RFC.`3987`.IRI? = nil,
            id: IETF.RFC.`3987`.IRI? = nil,
            links: [Link] = [],
            logo: IETF.RFC.`3987`.IRI? = nil,
            rights: Rights? = nil,
            subtitle: Subtitle? = nil,
            title: Title? = nil,
            updated: IETF.RFC.`3339`.DateTime? = nil,
            base: IETF.RFC.`3987`.IRI? = nil,
            lang: IETF.RFC.`5646`.Tag? = nil
        ) {
            self.authors = authors
            self.categories = categories
            self.contributors = contributors
            self.generator = generator
            self.icon = icon
            self.id = id
            self.links = links
            self.logo = logo
            self.rights = rights
            self.subtitle = subtitle
            self.title = title
            self.updated = updated
            self.base = base
            self.lang = lang
        }

        public init(
            authors: [Author] = [],
            categories: [Category] = [],
            contributors: [Contributor] = [],
            generator: Generator? = nil,

            icon: (any IETF.RFC.`3987`.IRI.Representable)? = nil,

            id: (any IETF.RFC.`3987`.IRI.Representable)? = nil,
            links: [Link] = [],

            logo: (any IETF.RFC.`3987`.IRI.Representable)? = nil,
            rights: Rights? = nil,
            subtitle: Subtitle? = nil,
            title: Title? = nil,
            updated: IETF.RFC.`3339`.DateTime? = nil,

            base: (any IETF.RFC.`3987`.IRI.Representable)? = nil,
            lang: IETF.RFC.`5646`.Tag? = nil
        ) {
            self.init(
                authors: authors,
                categories: categories,
                contributors: contributors,
                generator: generator,
                icon: icon?.iri,
                id: id?.iri,
                links: links,
                logo: logo?.iri,
                rights: rights,
                subtitle: subtitle,
                title: title,
                updated: updated,
                base: base?.iri,
                lang: lang
            )
        }
    }
}
