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
        // REASON: optional existential parameter; generic respelling compiler-refuted (nil-literal call sites / overload ambiguity); rule-scope refinement tracked at swift-foundations/swift-linter-rules#4
        // swiftlint:disable:next no_any_protocol_existential
        uri: (any RFC_3987.IRI.Representable)?,
        email: RFC_2822.AddrSpec? = nil,
        // REASON: optional existential parameter; generic respelling compiler-refuted (nil-literal call sites / overload ambiguity); rule-scope refinement tracked at swift-foundations/swift-linter-rules#4
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
