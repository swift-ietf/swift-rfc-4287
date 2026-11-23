import RFC_3987
public import RFC_5646

extension IETF.RFC.`4287` {

    public struct Generator: Hashable, Sendable, Codable {

        public let value: String

        public let uri: IETF.RFC.`3987`.IRI?

        // swift-linter:disable:next raw concept
        // REASON: RFC 4287 leaves the generator's version attribute as free text about the generating agent, so Version.Semantic and Version.Tools would refuse valid feeds
        public let version: String?

        public let base: IETF.RFC.`3987`.IRI?

        public let lang: IETF.RFC.`5646`.Tag?

        public init(
            value: String,
            uri: IETF.RFC.`3987`.IRI? = nil,
            // swift-linter:disable:next raw concept
            // REASON: RFC 4287 leaves the generator's version attribute as free text about the generating agent, so Version.Semantic and Version.Tools would refuse valid feeds
            version: String? = nil,
            base: IETF.RFC.`3987`.IRI? = nil,
            lang: IETF.RFC.`5646`.Tag? = nil
        ) {
            self.value = value
            self.uri = uri
            self.version = version
            self.base = base
            self.lang = lang
        }

        public init(
            value: String,

            uri: (any IETF.RFC.`3987`.IRI.Representable)?,
            // swift-linter:disable:next raw concept
            // REASON: RFC 4287 leaves the generator's version attribute as free text about the generating agent, so Version.Semantic and Version.Tools would refuse valid feeds
            version: String? = nil,

            base: (any IETF.RFC.`3987`.IRI.Representable)? = nil,
            lang: IETF.RFC.`5646`.Tag? = nil
        ) {
            self.init(value: value, uri: uri?.iri, version: version, base: base?.iri, lang: lang)
        }
    }
}
