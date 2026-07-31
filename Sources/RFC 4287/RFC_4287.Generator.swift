import RFC_3987

extension RFC_4287 {
    /// A generator construct as defined in RFC 4287 Section 4.2.4
    ///
    /// Identifies the agent used to generate a feed.
    public struct Generator: Hashable, Sendable, Codable {
        /// The generator name (required)
        public let value: String

        /// IRI for the generator (optional)
        public let uri: RFC_3987.IRI?

        /// Version of the generator (optional)
        public let version: String?

        /// Base IRI for resolving relative references (xml:base)
        ///
        /// Per RFC 4287 Section 2, any element may have an xml:base attribute.
        public let base: RFC_3987.IRI?

        /// Language of the generator (xml:lang)
        ///
        /// Per RFC 4287 Section 2, any element may have an xml:lang attribute.
        public let lang: String?

        /// Creates a new generator
        ///
        /// - Parameters:
        ///   - value: The generator name
        ///   - uri: IRI for the generator
        ///   - version: Version of the generator
        ///   - base: Base IRI for resolving relative references
        ///   - lang: Language of the generator
        public init(
            value: String,
            uri: RFC_3987.IRI? = nil,
            version: String? = nil,
            base: RFC_3987.IRI? = nil,
            lang: String? = nil
        ) {
            self.value = value
            self.uri = uri
            self.version = version
            self.base = base
            self.lang = lang
        }

        /// Creates a new generator with IRI.Representable URI (convenience)
        ///
        /// Accepts any IRI.Representable type such as Foundation URL.
        ///
        /// - Parameters:
        ///   - value: The generator name
        ///   - uri: IRI for the generator (e.g., URL)
        ///   - version: Version of the generator
        ///   - base: Base IRI for resolving relative references (e.g., URL)
        ///   - lang: Language of the generator
        public init(
            value: String,
            uri: (any RFC_3987.IRI.Representable)?,
            version: String? = nil,
            // REASON: nil-defaulted optional existential parameter; no lawful generic spelling (T? = nil defeats inference); rule-scope refinement tracked at swift-foundations/swift-linter-rules#4
            // swiftlint:disable:next no_any_protocol_existential
            base: (any RFC_3987.IRI.Representable)? = nil,
            lang: String? = nil
        ) {
            self.init(value: value, uri: uri?.iri, version: version, base: base?.iri, lang: lang)
        }
    }
}
