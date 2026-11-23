import RFC_3987
public import RFC_5646

extension IETF.RFC.`4287` {

    public struct Text: Hashable, Sendable, Codable {

        public let type: IETF.RFC.`4287`.Text.ContentType

        public let value: String

        public let base: IETF.RFC.`3987`.IRI?

        public let lang: IETF.RFC.`5646`.Tag?

        public init(
            _ value: String,
            type: IETF.RFC.`4287`.Text.ContentType = .text,

            base: (any IETF.RFC.`3987`.IRI.Representable)? = nil,
            lang: IETF.RFC.`5646`.Tag? = nil
        ) {
            self.value = value
            self.type = type
            self.base = base?.iri
            self.lang = lang
        }
    }
}

extension IETF.RFC.`4287`.Text: ExpressibleByStringLiteral {

    public init(stringLiteral value: String) {
        self.init(value, type: .text)
    }
}
