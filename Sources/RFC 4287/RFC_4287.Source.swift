import RFC_3987

extension RFC_4287 {
    /// A source construct as defined in RFC 4287 Section 4.2.11
    ///
    /// Contains metadata from the source feed when an entry is copied from one feed into another.
    public struct Source: Hashable, Sendable, Codable {
        /// Feed authors
        public let authors: [Author]

        /// Feed categories
        public let categories: [Category]

        /// Feed contributors
        public let contributors: [Contributor]

        /// Generator information
        public let generator: Generator?

        /// Icon IRI
        public let icon: RFC_3987.IRI?

        /// Feed ID
        public let id: RFC_3987.IRI?

        /// Links
        public let links: [Link]

        /// Logo IRI
        public let logo: RFC_3987.IRI?

        /// Feed rights
        public let rights: Rights?

        /// Feed subtitle
        public let subtitle: Subtitle?

        /// Feed title
        public let title: Title?

        /// Last updated timestamp
        public let updated: RFC_3339.DateTime?

        /// Base IRI for resolving relative references (xml:base)
        ///
        /// Per RFC 4287 Section 2, any element may have an xml:base attribute.
        public let base: RFC_3987.IRI?

        /// Language of the source (xml:lang)
        ///
        /// Per RFC 4287 Section 2, any element may have an xml:lang attribute.
        public let lang: String?

        /// Creates a new source construct
        ///
        /// - Parameters:
        ///   - authors: Feed authors
        ///   - categories: Feed categories
        ///   - contributors: Feed contributors
        ///   - generator: Generator information
        ///   - icon: Icon IRI
        ///   - id: Feed ID
        ///   - links: Links
        ///   - logo: Logo IRI
        ///   - rights: Feed rights
        ///   - subtitle: Feed subtitle
        ///   - title: Feed title
        ///   - updated: Last updated timestamp
        ///   - base: Base IRI for resolving relative references
        ///   - lang: Language of the source
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
            lang: String? = nil
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

        /// Creates a new source construct with IRI.Representable types (convenience)
        ///
        /// Accepts any IRI.Representable types such as Foundation URL.
        ///
        /// - Parameters:
        ///   - authors: Feed authors
        ///   - categories: Feed categories
        ///   - contributors: Feed contributors
        ///   - generator: Generator information
        ///   - icon: Icon IRI (e.g., URL)
        ///   - id: Feed ID (e.g., URL)
        ///   - links: Links
        ///   - logo: Logo IRI (e.g., URL)
        ///   - rights: Feed rights
        ///   - subtitle: Feed subtitle
        ///   - title: Feed title
        ///   - updated: Last updated timestamp
        ///   - base: Base IRI for resolving relative references (e.g., URL)
        ///   - lang: Language of the source
        public init(
            authors: [Author] = [],
            categories: [Category] = [],
            contributors: [Contributor] = [],
            generator: Generator? = nil,
            // REASON: nil-defaulted optional existential parameter; no lawful generic spelling (T? = nil defeats inference); rule-scope refinement tracked at swift-foundations/swift-linter-rules#4
            // swiftlint:disable:next no_any_protocol_existential
            icon: (any RFC_3987.IRI.Representable)? = nil,
            // REASON: nil-defaulted optional existential parameter; no lawful generic spelling (T? = nil defeats inference); rule-scope refinement tracked at swift-foundations/swift-linter-rules#4
            // swiftlint:disable:next no_any_protocol_existential
            id: (any RFC_3987.IRI.Representable)? = nil,
            links: [Link] = [],
            // REASON: nil-defaulted optional existential parameter; no lawful generic spelling (T? = nil defeats inference); rule-scope refinement tracked at swift-foundations/swift-linter-rules#4
            // swiftlint:disable:next no_any_protocol_existential
            logo: (any RFC_3987.IRI.Representable)? = nil,
            rights: Rights? = nil,
            subtitle: Subtitle? = nil,
            title: Title? = nil,
            updated: RFC_3339.DateTime? = nil,
            // REASON: nil-defaulted optional existential parameter; no lawful generic spelling (T? = nil defeats inference); rule-scope refinement tracked at swift-foundations/swift-linter-rules#4
            // swiftlint:disable:next no_any_protocol_existential
            base: (any RFC_3987.IRI.Representable)? = nil,
            lang: String? = nil
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
