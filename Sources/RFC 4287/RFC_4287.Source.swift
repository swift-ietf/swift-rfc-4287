import RFC_3987
public import RFC_5646

extension RFC_4287 {

    public struct Source: Hashable, Sendable, Codable {

        public let authors: [Author]

        public let categories: [Category]

        public let contributors: [Contributor]

        public let generator: Generator?

        public let icon: RFC_3987.IRI?

        public let id: RFC_3987.IRI?

        public let links: [Link]

        public let logo: RFC_3987.IRI?

        public let rights: Rights?

        public let subtitle: Subtitle?

        public let title: Title?

        public let updated: RFC_3339.DateTime?

        public let base: RFC_3987.IRI?

        public let lang: RFC_5646.LanguageTag?

        public init(
            authors: [Author] = [],
            categories: [Category] = [],
            contributors: [Contributor] = [],
            generator: Generator? = nil,
            icon: RFC_3987.IRI? = nil,
            id: RFC_3987.IRI? = nil,
            links: [Link] = [],
            logo: RFC_3987.IRI? = nil,
            rights: Rights? = nil,
            subtitle: Subtitle? = nil,
            title: Title? = nil,
            updated: RFC_3339.DateTime? = nil,
            base: RFC_3987.IRI? = nil,
            lang: RFC_5646.LanguageTag? = nil
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

            icon: (any RFC_3987.IRI.Representable)? = nil,

            id: (any RFC_3987.IRI.Representable)? = nil,
            links: [Link] = [],

            logo: (any RFC_3987.IRI.Representable)? = nil,
            rights: Rights? = nil,
            subtitle: Subtitle? = nil,
            title: Title? = nil,
            updated: RFC_3339.DateTime? = nil,

            base: (any RFC_3987.IRI.Representable)? = nil,
            lang: RFC_5646.LanguageTag? = nil
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
