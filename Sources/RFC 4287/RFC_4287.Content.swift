import RFC_3987

extension RFC_4287 {

    public struct Content: Hashable, Sendable, Codable {

        public enum ContentType: Hashable, Sendable, Codable {
            case text
            case html
            case xhtml
            case media(String)
        }

        public let type: ContentType

        public let value: String?

        public let src: RFC_3987.IRI?

        public let base: RFC_3987.IRI?

        public let lang: String?

        public init(
            value: String,
            type: ContentType = .text,

            base: (any RFC_3987.IRI.Representable)? = nil,
            lang: String? = nil
        ) {
            self.value = value
            self.type = type
            self.src = nil
            self.base = base?.iri
            self.lang = lang
        }

        public init(
            rawBytes: [UInt8],
            mediaType: String,

            base: (any RFC_3987.IRI.Representable)? = nil,
            lang: String? = nil
        ) {
            self.value = rawBytes.map { Byte($0) }.base64()
            self.type = .media(mediaType)
            self.src = nil
            self.base = base?.iri
            self.lang = lang
        }

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

        public init(
            src: some RFC_3987.IRI.Representable,
            type: ContentType = .text,

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

    public init(from decoder: any Decoder) throws(DecodingError) {

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

    public func encode(to encoder: any Encoder) throws(EncodingError) {

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

    public var requiresBase64Encoding: Bool {
        guard case .media(let mediaType) = type else {
            return false
        }

        let lowercased = mediaType.lowercased()

        if lowercased.hasSuffix("/xml") || lowercased.hasSuffix("+xml") {
            return false
        }

        if lowercased.hasPrefix("text/") {
            return false
        }

        return true
    }
}
