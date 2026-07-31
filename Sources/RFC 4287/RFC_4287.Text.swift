import RFC_3987

extension RFC_4287 {
    /// A text construct as defined in RFC 4287 Section 3.1
    ///
    /// Text constructs are used for human-readable text in Atom documents.
    /// They can be plain text, HTML, or XHTML.
    public struct Text: Hashable, Sendable, Codable {

        /// The type of this text construct
        public let type: RFC_4287.Text.ContentType

        /// The content of this text construct
        public let value: String

        /// Base IRI for resolving relative references (xml:base)
        ///
        /// Per RFC 4287 Section 2, any element may have an xml:base attribute.
        public let base: RFC_3987.IRI?

        /// Language of the text content (xml:lang)
        ///
        /// Per RFC 4287 Section 2, any element may have an xml:lang attribute.
        public let lang: String?

        /// Creates a new text construct
        ///
        /// - Parameters:
        ///   - value: The text content
        ///   - type: The type of content (defaults to .text)
        ///   - base: Base IRI for resolving relative references
        ///   - lang: Language of the text content
        public init(
            _ value: String,
            type: RFC_4287.Text.ContentType = .text,
            // REASON: nil-defaulted optional existential parameter; no lawful generic spelling (T? = nil defeats inference); rule-scope refinement tracked at swift-foundations/swift-linter-rules#4
            // swiftlint:disable:next no_any_protocol_existential
            base: (any RFC_3987.IRI.Representable)? = nil,
            lang: String? = nil
        ) {
            self.value = value
            self.type = type
            self.base = base?.iri
            self.lang = lang
        }
    }
}

// MARK: - ExpressibleByStringLiteral
extension RFC_4287.Text: ExpressibleByStringLiteral {
    /// Creates a text construct from a string literal (defaults to .text type)
    ///
    /// Example:
    /// ```swift
    /// let title: RFC_4287.Text = "My Blog Post"
    /// // Equivalent to: RFC_4287.Text("My Blog Post", type: .text)
    /// ```
    public init(stringLiteral value: String) {
        self.init(value, type: .text)
    }
}
