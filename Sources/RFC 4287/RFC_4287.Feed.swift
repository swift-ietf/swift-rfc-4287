import RFC_3987

extension RFC_4287 {
    /// An Atom feed document as defined in RFC 4287 Section 4.1.1
    ///
    /// The top-level element of an Atom feed document.
    public struct Feed: Hashable, Sendable, Codable {
        /// Feed authors (at least one required if entries don't have authors)
        public let authors: [Author]

        /// Feed categories
        public let categories: [Category]

        /// Feed contributors
        public let contributors: [Contributor]

        /// Generator information
        public let generator: Generator?

        /// Icon IRI (should be small and square)
        ///
        /// Per RFC 4287 Section 4.2.5, this should be an IRI reference.
        public let icon: RFC_3987.IRI?

        /// Permanent, universally unique identifier (required)
        ///
        /// Per RFC 4287 Section 4.2.6, this MUST be an IRI reference.
        /// It MUST be permanent and universally unique, and MUST NOT change.
        public let id: RFC_3987.IRI

        /// Links associated with the feed
        public let links: [Link]

        /// Logo IRI (should be rectangular)
        ///
        /// Per RFC 4287 Section 4.2.8, this should be an IRI reference.
        public let logo: RFC_3987.IRI?

        /// Copyright and licensing information
        public let rights: Rights?

        /// Subtitle or tagline
        public let subtitle: Subtitle?

        /// Human-readable title (required)
        public let title: Title

        /// Timestamp of last significant modification (required)
        public let updated: RFC_3339.DateTime

        /// Base IRI for resolving relative references (xml:base)
        ///
        /// Per RFC 4287 Section 2, any element may have an xml:base attribute.
        public let base: RFC_3987.IRI?

        /// Language of the feed content (xml:lang)
        ///
        /// Per RFC 4287 Section 2, any element may have an xml:lang attribute.
        public let lang: String?

        /// Feed entries
        public let entries: [Entry]
    }
}

extension RFC_4287.Feed {
    public enum Error: Swift.Error {
        case blank
    }
}
extension RFC_4287.Feed {

    /// Creates a new feed with validation
    ///
    /// - Parameters:
    ///   - id: Permanent, universally unique identifier
    ///   - title: Human-readable title
    ///   - updated: Timestamp of last modification
    ///   - authors: Feed authors
    ///   - entries: Feed entries
    ///   - links: Associated links
    ///   - categories: Feed categories
    ///   - contributors: Feed contributors
    ///   - generator: Generator information
    ///   - icon: Icon IRI
    ///   - logo: Logo IRI
    ///   - rights: Rights information
    ///   - subtitle: Feed subtitle
    ///   - base: Base IRI for resolving relative references
    ///   - lang: Language of the feed content
    ///
    /// - Returns: A validated feed, or nil if validation fails
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
        lang: String? = nil
    ) throws(Error) {
        // Validation: feed must have authors OR all entries must have authors
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

    /// Creates a new feed with validation using IRI.Representable types (convenience)
    ///
    /// Accepts any IRI.Representable types such as Foundation URL.
    ///
    /// - Parameters:
    ///   - id: Permanent, universally unique identifier (e.g., URL)
    ///   - title: Human-readable title
    ///   - updated: Timestamp of last modification
    ///   - authors: Feed authors
    ///   - entries: Feed entries
    ///   - links: Associated links
    ///   - categories: Feed categories
    ///   - contributors: Feed contributors
    ///   - generator: Generator information
    ///   - icon: Icon IRI (e.g., URL)
    ///   - logo: Logo IRI (e.g., URL)
    ///   - rights: Rights information
    ///   - subtitle: Feed subtitle
    ///   - base: Base IRI for resolving relative references (e.g., URL)
    ///   - lang: Language of the feed content
    ///
    /// - Returns: A validated feed, or nil if validation fails
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
        lang: String? = nil
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
    //
    //    /// Creates a new feed without validation (for internal use, e.g. decoding)
    //    @_spi(Internal)
    //    public init (
    //        unchecked: Void,
    //        id: String,
    //        title: Title,
    //        updated: RFC_3339.DateTime,
    //        authors: [Author],
    //        entries: [Entry],
    //        links: [Link],
    //        categories: [Category],
    //        contributors: [Contributor],
    //        generator: Generator?,
    //        icon: String?,
    //        logo: String?,
    //        rights: Rights?,
    //        subtitle: Subtitle?,
    //        base: String?,
    //        lang: String?
    //    ) {
    //        Feed(
    //            uncheckedId: RFC_3987.IRI(__unchecked: (), value: id),
    //            uncheckedTitle: title,
    //            uncheckedUpdated: updated,
    //            uncheckedAuthors: authors,
    //            uncheckedEntries: entries,
    //            uncheckedLinks: links,
    //            uncheckedCategories: categories,
    //            uncheckedContributors: contributors,
    //            uncheckedGenerator: generator,
    //            uncheckedIcon: icon.map { RFC_3987.IRI(__unchecked: (), value: $0) },
    //            uncheckedLogo: logo.map { RFC_3987.IRI(__unchecked: (), value: $0) },
    //            uncheckedRights: rights,
    //            uncheckedSubtitle: subtitle,
    //            uncheckedBase: base.map { RFC_3987.IRI(__unchecked: (), value: $0) },
    //            uncheckedLang: lang
    //        )
    //    }
    //
    //        private init(
    //            uncheckedId id: RFC_3987.IRI,
    //            uncheckedTitle title: Title,
    //            uncheckedUpdated updated: RFC_3339.DateTime,
    //            uncheckedAuthors authors: [Author],
    //            uncheckedEntries entries: [Entry],
    //            uncheckedLinks links: [Link],
    //            uncheckedCategories categories: [Category],
    //            uncheckedContributors contributors: [Contributor],
    //            uncheckedGenerator generator: Generator?,
    //            uncheckedIcon icon: RFC_3987.IRI?,
    //            uncheckedLogo logo: RFC_3987.IRI?,
    //            uncheckedRights rights: Rights?,
    //            uncheckedSubtitle subtitle: Subtitle?,
    //            uncheckedBase base: RFC_3987.IRI?,
    //            uncheckedLang lang: String?
    //        ) {
    //            self.id = id
    //            self.title = title
    //            self.updated = updated
    //            self.authors = authors
    //            self.entries = entries
    //            self.links = links
    //            self.categories = categories
    //            self.contributors = contributors
    //            self.generator = generator
    //            self.icon = icon
    //            self.logo = logo
    //            self.rights = rights
    //            self.subtitle = subtitle
    //            self.base = base
    //            self.lang = lang
    //        }
}
