import RFC_3987
public import RFC_5646

extension RFC_4287 {

    public struct Generator: Hashable, Sendable, Codable {

        public let value: String

        public let uri: RFC_3987.IRI?

        // swift-linter:disable:next raw concept
        // REASON: RFC 4287 leaves the generator's version attribute as free text about the generating agent, so Version.Semantic and Version.Tools would refuse valid feeds
        public let version: String?

        public let base: RFC_3987.IRI?

        public let lang: RFC_5646.LanguageTag?

        public init(
            value: String,
            uri: RFC_3987.IRI? = nil,
            // swift-linter:disable:next raw concept
            // REASON: RFC 4287 leaves the generator's version attribute as free text about the generating agent, so Version.Semantic and Version.Tools would refuse valid feeds
            version: String? = nil,
            base: RFC_3987.IRI? = nil,
            lang: RFC_5646.LanguageTag? = nil
        ) {
            self.value = value
            self.uri = uri
            self.version = version
            self.base = base
            self.lang = lang
        }

        public init(
            value: String,

            uri: (any RFC_3987.IRI.Representable)?,
            // swift-linter:disable:next raw concept
            // REASON: RFC 4287 leaves the generator's version attribute as free text about the generating agent, so Version.Semantic and Version.Tools would refuse valid feeds
            version: String? = nil,

            base: (any RFC_3987.IRI.Representable)? = nil,
            lang: RFC_5646.LanguageTag? = nil
        ) {
            self.init(value: value, uri: uri?.iri, version: version, base: base?.iri, lang: lang)
        }
    }
}
