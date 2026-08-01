import RFC_3987

extension RFC_4287 {
    /// A content construct as defined in RFC 4287 Section 4.1.3
    ///
    /// Contains or links to the content of an entry.
    public struct Content: Hashable, Sendable, Codable {
        /// The type of content
        public enum ContentType: Hashable, Sendable, Codable {
            case text
            case html
            case xhtml
            case media(String)  // e.g., "image/png", "application/pdf"
        }

        /// The type of this content
        public let type: ContentType

        /// The content value or URI reference
        public let value: String?

        /// The source IRI (when content is out-of-line)
        public let src: RFC_3987.IRI?

        /// Base IRI for resolving relative references (xml:base)
        ///
        /// Per RFC 4287 Section 2, any element may have an xml:base attribute.
        public let base: RFC_3987.IRI?

        /// Language of the content (xml:lang)
        ///
        /// Per RFC 4287 Section 2, any element may have an xml:lang attribute.
        public let lang: String?

        /// Creates inline content
        ///
        /// - Parameters:
        ///   - value: The content
        ///   - type: The content type
        ///   - base: Base IRI for resolving relative references
        ///   - lang: Language of the content
        public init(
            value: String,
            type: ContentType = .text,
            // REASON: nil-defaulted optional existential parameter; no lawful generic spelling (T? = nil defeats inference); rule-scope refinement tracked at swift-foundations/swift-linter-rules#4
            // swiftlint:disable:next no_any_protocol_existential
            base: (any RFC_3987.IRI.Representable)? = nil,
            lang: String? = nil
        ) {
            self.value = value
            self.type = type
            self.src = nil
            self.base = base?.iri
            self.lang = lang
        }

        /// Creates inline binary content from raw bytes
        ///
        /// - Parameters:
        ///   - rawBytes: The raw binary content bytes (will be base64-encoded per RFC 4287)
        ///   - mediaType: The MIME type of the content
        ///   - base: Base IRI for resolving relative references
        ///   - lang: Language of the content
        ///
        /// This initializer automatically base64-encodes the bytes as required by RFC 4287
        /// for binary media types. If you already have a base64-encoded string, use
        /// `init(value:type:base:lang:)` instead with `type: .media(mediaType)`.
        public init(
            rawBytes: [UInt8],
            mediaType: String,
            // REASON: nil-defaulted optional existential parameter; no lawful generic spelling (T? = nil defeats inference); rule-scope refinement tracked at swift-foundations/swift-linter-rules#4
            // swiftlint:disable:next no_any_protocol_existential
            base: (any RFC_3987.IRI.Representable)? = nil,
            lang: String? = nil
        ) {
            self.value = rawBytes.map { Byte($0) }.base64()
            self.type = .media(mediaType)
            self.src = nil
            self.base = base?.iri
            self.lang = lang
        }

        /// Creates out-of-line content
        ///
        /// - Parameters:
        ///   - src: The IRI of the content
        ///   - type: The content type
        ///   - base: Base IRI for resolving relative references
        ///   - lang: Language of the content
        public init(
            src: RFC_3987.IRI,
            type: ContentType = .text,
            base: RFC_3987.IRI? = nil,
            lang: String? = nil
        ) {
            self.value = nil
            self.type = type
            self.src = src
            self.base = base
            self.lang = lang
        }

        /// Creates out-of-line content with IRI.Representable source (convenience)
        ///
        /// Accepts any IRI.Representable type such as Foundation URL.
        ///
        /// - Parameters:
        ///   - src: The IRI of the content (e.g., URL)
        ///   - type: The content type
        ///   - base: Base IRI for resolving relative references (e.g., URL)
        ///   - lang: Language of the content
        public init(
            src: some RFC_3987.IRI.Representable,
            type: ContentType = .text,
            // REASON: nil-defaulted optional existential parameter; no lawful generic spelling (T? = nil defeats inference); rule-scope refinement tracked at swift-foundations/swift-linter-rules#4
            // swiftlint:disable:next no_any_protocol_existential
            base: (any RFC_3987.IRI.Representable)? = nil,
            lang: String? = nil
        ) {
            self.init(src: src.iri, type: type, base: base?.iri, lang: lang)
        }
    }
}

extension RFC_4287.Content.ContentType {
    public init(stringValue: String) {
        switch stringValue {
        case "text": self = .text
        case "html": self = .html
        case "xhtml": self = .xhtml
        default: self = .media(stringValue)
        }
    }

    // MARK: - Codable

    // reason: stdlib protocol witness — Decodable.init(from:) signature mandates the existential shape ([API-ERR-006] exception).
    // swiftlint:disable:next no_any_protocol_existential
    public init(from decoder: any Decoder) throws(DecodingError) {
        // swift-linter:disable:next do throws for typed catch
        // REASON: Decoder.singleValueContainer()/decode(_:) are untyped `throws` stdlib protocol requirements; no typed `E` exists to name.
        do {
            let container = try decoder.singleValueContainer()
            let string = try container.decode(String.self)
            self.init(stringValue: string)
        } catch let error as DecodingError {
            throw error
        } catch {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "\(error)",
                    underlyingError: error
                )
            )
        }
    }
}

extension RFC_4287.Content.ContentType {
    public var stringValue: String {
        switch self {
        case .text: return "text"
        case .html: return "html"
        case .xhtml: return "xhtml"
        case .media(let type): return type
        }
    }

    // reason: stdlib protocol witness — Encodable.encode(to:) signature mandates the existential shape ([API-ERR-006] exception).
    // swiftlint:disable:next no_any_protocol_existential
    public func encode(to encoder: any Encoder) throws(EncodingError) {
        // swift-linter:disable:next do throws for typed catch
        // REASON: SingleValueEncodingContainer.encode(_:) is an untyped `throws` stdlib protocol requirement; no typed `E` exists to name.
        do {
            var container = encoder.singleValueContainer()
            try container.encode(stringValue)
        } catch let error as EncodingError {
            throw error
        } catch {
            throw EncodingError.invalidValue(
                self,
                EncodingError.Context(
                    codingPath: encoder.codingPath,
                    debugDescription: "\(error)",
                    underlyingError: error
                )
            )
        }
    }
}

extension RFC_4287.Content {
    /// Determines if this content type requires base64 encoding per RFC 4287 Section 4.1.3.3
    ///
    /// Returns true if the content is a binary media type that requires base64 encoding:
    /// - Not text, html, or xhtml
    /// - Not an XML media type (doesn't end with /xml or +xml)
    /// - Doesn't begin with "text/"
    public var requiresBase64Encoding: Bool {
        guard case .media(let mediaType) = type else {
            return false
        }

        // Check if it's an XML media type
        if mediaType.hasSuffix("/xml") || mediaType.hasSuffix("+xml") {
            return false
        }

        // Check if it begins with "text/"
        if mediaType.hasPrefix("text/") {
            return false
        }

        // All other media types require base64 encoding
        return true
    }
}
