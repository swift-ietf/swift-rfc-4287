public import RFC_2822
import RFC_3987

extension RFC_4287 {
    /// A person construct as defined in RFC 4287 Section 3.2
    ///
    /// Person constructs describe authors and contributors.
    public struct Person: Hashable, Sendable {
        /// The human-readable name of the person (required)
        public let name: String

        /// The IRI associated with the person (optional)
        ///
        /// Per RFC 4287 Section 3.2.2, this should be an IRI reference.
        public let uri: RFC_3987.IRI?

        /// The email address of the person (optional)
        ///
        /// Per RFC 4287 Section 3.2.3, this must be an email address
        /// conforming to the "addr-spec" production in RFC 2822.
        public let email: RFC_2822.AddrSpec?

        /// Base IRI for resolving relative references (xml:base)
        ///
        /// Per RFC 4287 Section 2, any element may have an xml:base attribute.
        public let base: RFC_3987.IRI?

        /// Language of the person construct (xml:lang)
        ///
        /// Per RFC 4287 Section 2, any element may have an xml:lang attribute.
        public let lang: String?

        /// Creates a new person construct
        ///
        /// - Parameters:
        ///   - name: The person's name
        ///   - uri: An optional IRI for the person
        ///   - email: An optional email address (RFC 2822 AddrSpec)
        ///   - base: Base IRI for resolving relative references
        ///   - lang: Language of the person construct
        public init(
            name: String,
            uri: RFC_3987.IRI? = nil,
            email: RFC_2822.AddrSpec? = nil,
            base: RFC_3987.IRI? = nil,
            lang: String? = nil
        ) {
            self.name = name
            self.uri = uri
            self.email = email
            self.base = base
            self.lang = lang
        }
    }
}

extension RFC_4287.Person {
    public enum Error: Swift.Error {
        case blank
    }
}

extension RFC_4287.Person {

    /// Creates a new person construct with IRI.Representable URI (convenience)
    ///
    /// Accepts any IRI.Representable type such as Foundation URL.
    ///
    /// - Parameters:
    ///   - name: The person's name
    ///   - uri: An optional IRI-representable value (e.g., URL)
    ///   - email: An optional email address (RFC 2822 AddrSpec)
    ///   - base: Base IRI for resolving relative references (e.g., URL)
    ///   - lang: Language of the person construct
    public init(
        name: String,
        uri: (any RFC_3987.IRI.Representable)?,
        email: RFC_2822.AddrSpec? = nil,
        // REASON: nil-defaulted optional existential parameter; no lawful generic spelling (T? = nil defeats inference); rule-scope refinement tracked at swift-foundations/swift-linter-rules#4
        // swiftlint:disable:next no_any_protocol_existential
        base: (any RFC_3987.IRI.Representable)? = nil,
        lang: String? = nil
    ) {
        self.init(name: name, uri: uri?.iri, email: email, base: base?.iri, lang: lang)
    }
    //
    //        /// Creates a new person construct with string email (convenience)
    //        ///
    //        /// - Parameters:
    //        ///   - name: The person's name
    //        ///   - uri: An optional IRI string for the person
    //        ///   - emailString: Email address as string (will be parsed as local@domain)
    //        ///   - base: Base IRI string for resolving relative references
    //        ///   - lang: Language of the person construct
    //        /// - Throws: RFC_2822.AddrSpec.Error if email is invalid
    //        public init(
    //            name: String,
    //            uri: String? = nil,
    //            emailString: String,
    //            base: String? = nil,
    //            lang: String? = nil
    //        ) throws {
    //            // Parse email using RFC 2822 canonical byte parsing
    //            let addrSpec = try RFC_2822.AddrSpec(ascii: emailString.utf8)
    //            let iri: RFC_3987.IRI? = uri.map { RFC_3987.IRI(__unchecked: (), value: $0) }
    //            let baseIRI: RFC_3987.IRI? = base.map { RFC_3987.IRI(__unchecked: (), value: $0) }
    //            self.init(name: name, uri: iri, email: addrSpec, base: baseIRI, lang: lang)
    //        }
    //    }
}

// MARK: - Codable
extension RFC_4287.Person: Codable {
    enum CodingKeys: String, CodingKey {
        case name
        case uri
        case email
        case base
        case lang
    }

    // reason: stdlib protocol witness — Decodable.init(from:) signature mandates the existential shape ([API-ERR-006] exception).
    // swiftlint:disable:next no_any_protocol_existential
    public init(from decoder: any Decoder) throws(DecodingError) {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            name = try container.decode(String.self, forKey: .name)
            uri = try container.decodeIfPresent(String.self, forKey: .uri).map {
                try RFC_3987.IRI($0)
            }

            // Decode email as string and convert to AddrSpec
            if let emailString = try container.decodeIfPresent(String.self, forKey: .email) {
                do throws(RFC_2822.AddrSpec.Error) {
                    email = try RFC_2822.AddrSpec(ascii: emailString.utf8.map { Byte($0) })
                } catch {
                    throw DecodingError.dataCorruptedError(
                        forKey: .email,
                        in: container,
                        debugDescription: "Invalid email format: \(emailString)"
                    )
                }
            } else {
                email = nil
            }

            base = try container.decodeIfPresent(String.self, forKey: .base).map {
                try RFC_3987.IRI($0)
            }
            lang = try container.decodeIfPresent(String.self, forKey: .lang)
        } catch let error as DecodingError {
            throw error
        } catch {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "\(error)", underlyingError: error)
            )
        }
    }

    // reason: stdlib protocol witness — Encodable.encode(to:) signature mandates the existential shape ([API-ERR-006] exception).
    // swiftlint:disable:next no_any_protocol_existential
    public func encode(to encoder: any Encoder) throws(EncodingError) {
        do {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(name, forKey: .name)
            try container.encodeIfPresent(uri?.value, forKey: .uri)
            // Encode email as string
            if let email {
                try container.encode(email.description, forKey: .email)
            }
            try container.encodeIfPresent(base?.value, forKey: .base)
            try container.encodeIfPresent(lang, forKey: .lang)
        } catch let error as EncodingError {
            throw error
        } catch {
            throw EncodingError.invalidValue(
                self, EncodingError.Context(codingPath: encoder.codingPath, debugDescription: "\(error)", underlyingError: error)
            )
        }
    }
}

// MARK: - ExpressibleByStringLiteral
extension RFC_4287.Person: ExpressibleByStringLiteral {
    /// Creates a person from a string literal (just name, no URI or email)
    ///
    /// Example:
    /// ```swift
    /// let author: RFC_4287.Person = "John Doe"
    /// // Equivalent to: RFC_4287.Person(name: "John Doe")
    /// ```
    public init(stringLiteral value: String) {
        self.init(name: value, uri: nil, email: nil)
    }
}
