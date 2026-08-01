import RFC_3987

extension RFC_4287 {
    /// A link construct as defined in RFC 4287 Section 4.2.7
    ///
    /// Links define references to Web resources.
    public struct Link: Hashable, Sendable, Codable {

        /// The IRI of the referenced resource (required)
        ///
        /// Per RFC 4287 Section 4.2.7, the href attribute contains an IRI reference.
        public let href: RFC_3987.IRI

        /// The link relation type (optional)
        ///
        /// Per RFC 4287 Section 4.2.7.2: If the rel attribute is not present,
        /// the link element MUST be interpreted as if the link relation type is "alternate".
        ///
        /// When `nil`, consumers should treat the link as having relation type "alternate".
        public let rel: Relation?

        /// The media type of the resource (optional)
        public let type: String?

        /// The language of the resource (optional)
        public let hreflang: String?

        /// Human-readable title for the link (optional)
        public let title: String?

        /// The length of the resource in bytes (optional)
        public let length: Int?

        /// Base IRI for resolving relative references (xml:base)
        ///
        /// Per RFC 4287 Section 2, any element may have an xml:base attribute.
        public let base: RFC_3987.IRI?

        /// Language of the link (xml:lang)
        ///
        /// Per RFC 4287 Section 2, any element may have an xml:lang attribute.
        public let lang: String?

        /// Creates a new link
        ///
        /// - Parameters:
        ///   - href: The IRI of the resource
        ///   - rel: The link relation type
        ///   - type: The media type
        ///   - hreflang: The language
        ///   - title: A title for the link
        ///   - length: The length in bytes
        ///   - base: Base IRI for resolving relative references
        ///   - lang: Language of the link
        public init(
            href: RFC_3987.IRI,
            rel: Relation? = nil,
            type: String? = nil,
            hreflang: String? = nil,
            title: String? = nil,
            length: Int? = nil,
            base: RFC_3987.IRI? = nil,
            lang: String? = nil
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

        /// Creates a new link with IRI.Representable href (convenience)
        ///
        /// Accepts any IRI.Representable type such as Foundation URL.
        ///
        /// - Parameters:
        ///   - href: The IRI of the resource (e.g., URL, RFC_3987.IRI)
        ///   - rel: The link relation type
        ///   - type: The media type
        ///   - hreflang: The language
        ///   - title: A title for the link
        ///   - length: The length in bytes
        ///   - base: Base IRI for resolving relative references (e.g., URL)
        ///   - lang: Language of the link
        public init(
            href: some RFC_3987.IRI.Representable,
            rel: Relation? = nil,
            type: String? = nil,
            hreflang: String? = nil,
            title: String? = nil,
            length: Int? = nil,
            // REASON: nil-defaulted optional existential parameter; no lawful generic spelling (T? = nil defeats inference); rule-scope refinement tracked at swift-foundations/swift-linter-rules#4
            // swiftlint:disable:next no_any_protocol_existential
            base: (any RFC_3987.IRI.Representable)? = nil,
            lang: String? = nil
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

extension RFC_4287.Link {
    /// Returns true if this link should be treated as an "alternate" relation
    ///
    /// Per RFC 4287 Section 4.2.7.2: If the rel attribute is not present,
    /// the link element MUST be interpreted as if the link relation type is "alternate".
    public var isAlternate: Bool {
        rel == .alternate || rel == nil
    }
}

//
// // MARK: - ExpressibleByStringLiteral
// extension RFC_4287.Link: ExpressibleByStringLiteral {
//    /// Creates a link from a string literal (just href, alternate relation)
//    ///
//    /// Example:
//    /// ```swift
//    /// let link: RFC_4287.Link = "https://example.com/post"
//    /// ```
//    ///
//    /// Note: This does not perform IRI validation at compile time.
//    /// For runtime validation, use `try RFC_3987.IRI("...")` and pass to `init(href:)`.
//    public init(stringLiteral value: String) {
//        self.init(
//            href: RFC_3987.IRI(value), rel: nil, type: nil, hreflang: nil, title: nil,
//            length: nil)
//    }
// }
