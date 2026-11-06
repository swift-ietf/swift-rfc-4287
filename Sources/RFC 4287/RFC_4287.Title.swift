public import RFC_5646

extension RFC_4287 {

    public struct Title: Hashable, Sendable, Codable {

        public let text: Text

        public init(_ text: Text) {
            self.text = text
        }

        public init(
            _ value: String,
            type: Text.ContentType = .text,

            base: (any RFC_3987.IRI.Representable)? = nil,
            lang: RFC_5646.LanguageTag? = nil
        ) {
            self.text = Text(value, type: type, base: base, lang: lang)
        }
    }
}

extension RFC_4287.Title {

    public var value: String { text.value }

    public var type: RFC_4287.Text.ContentType { text.type }

    public var base: RFC_3987.IRI? { text.base }

    public var lang: RFC_5646.LanguageTag? { text.lang }
}

extension RFC_4287.Title: ExpressibleByStringLiteral {

    public init(stringLiteral value: String) {
        self.init(value, type: .text)
    }
}
