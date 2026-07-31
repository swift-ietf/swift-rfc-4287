import RFC_3987

extension RFC_4287 {
    /// A category construct as defined in RFC 4287 Section 4.2.2
    ///
    /// Categories convey information about categories associated with an entry or feed.
    public struct Category: Hashable, Sendable, Codable {
        /// The category term (required)
        public let term: String

        /// The categorization scheme IRI (optional)
        public let scheme: RFC_3987.IRI?

        /// Human-readable label for the category (optional)
        public let label: String?

        /// Base IRI for resolving relative references (xml:base)
        ///
        /// Per RFC 4287 Section 2, any element may have an xml:base attribute.
        public let base: RFC_3987.IRI?

        /// Language of the category (xml:lang)
        ///
        /// Per RFC 4287 Section 2, any element may have an xml:lang attribute.
        public let lang: String?

        /// Creates a new category
        ///
        /// - Parameters:
        ///   - term: The category term
        ///   - scheme: The categorization scheme IRI
        ///   - label: A human-readable label
        ///   - base: Base IRI for resolving relative references
        ///   - lang: Language of the category
        public init(
            term: String,
            scheme: RFC_3987.IRI? = nil,
            label: String? = nil,
            base: RFC_3987.IRI? = nil,
            lang: String? = nil
        ) {
            self.term = term
            self.scheme = scheme
            self.label = label
            self.base = base
            self.lang = lang
        }

    }
}

extension RFC_4287.Category {

    /// Creates a new category with IRI.Representable scheme (convenience)
    ///
    /// Accepts any IRI.Representable type such as Foundation URL.
    ///
    /// - Parameters:
    ///   - term: The category term
    ///   - scheme: The categorization scheme IRI (e.g., URL)
    ///   - label: A human-readable label
    ///   - base: Base IRI for resolving relative references (e.g., URL)
    ///   - lang: Language of the category
    public init(
        term: String,
        // REASON: optional existential parameter; generic respelling compiler-refuted (nil-literal call sites / overload ambiguity); rule-scope refinement tracked at swift-foundations/swift-linter-rules#4
        // swiftlint:disable:next no_any_protocol_existential
        scheme: (any RFC_3987.IRI.Representable)?,
        label: String? = nil,
        // REASON: optional existential parameter; generic respelling compiler-refuted (nil-literal call sites / overload ambiguity); rule-scope refinement tracked at swift-foundations/swift-linter-rules#4
        // swiftlint:disable:next no_any_protocol_existential
        base: (any RFC_3987.IRI.Representable)? = nil,
        lang: String? = nil
    ) {
        self.init(term: term, scheme: scheme?.iri, label: label, base: base?.iri, lang: lang)
    }
}

// MARK: - ExpressibleByStringLiteral
extension RFC_4287.Category: ExpressibleByStringLiteral {
    /// Creates a category from a string literal (just term, no scheme or label)
    ///
    /// Example:
    /// ```swift
    /// let category: RFC_4287.Category = "Technology"
    /// // Equivalent to: RFC_4287.Category(term: "Technology")
    /// ```
    public init(stringLiteral value: String) {
        self.init(term: value, scheme: nil, label: nil)
    }
}
