import RFC_3987

extension RFC_4287.Link {
    /// Link relation types as defined in RFC 4287 and extensions
    ///
    /// This struct allows for both standard relation types and custom values,
    /// avoiding the enum-with-custom-case code smell.
    public struct Relation: Hashable, Sendable, ExpressibleByStringLiteral {
        /// The string value of the relation
        public let value: String

        /// Creates a relation with a custom value
        ///
        /// - Parameter value: The relation type string
        public init(_ value: String) {
            self.value = value
        }
    }
}

extension RFC_4287.Link.Relation {

    // MARK: - Standard Relations (RFC 4287)

    /// Alternate representation
    public static let alternate = Self("alternate")

    /// Related resource
    public static let related = Self("related")

    /// Self-reference
    public static let `self` = Self("self")

    /// Enclosed resource (e.g., podcast episode)
    public static let enclosure = Self("enclosure")

    /// Source of information
    public static let via = Self("via")

    // MARK: - Extension Relations

    /// Comments/replies (RFC 4685 - Atom Threading Extensions)
    public static let replies = Self("replies")
}

extension RFC_4287.Link.Relation {
    // MARK: - ExpressibleByStringLiteral

    public init(stringLiteral value: String) {
        self.init(value)
    }
}

extension RFC_4287.Link.Relation: Codable {
    // reason: stdlib protocol witness — Decodable.init(from:) signature mandates the existential shape ([API-ERR-006] exception).
    // swiftlint:disable:next no_any_protocol_existential
    public init(from decoder: any Decoder) throws(DecodingError) {
        // swift-linter:disable:next do throws for typed catch
        // REASON: Decoder.singleValueContainer()/decode(_:) are untyped `throws` stdlib protocol requirements; no typed `E` exists to name.
        do {
            let container = try decoder.singleValueContainer()
            let string = try container.decode(String.self)
            self.init(string)
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

    // reason: stdlib protocol witness — Encodable.encode(to:) signature mandates the existential shape ([API-ERR-006] exception).
    // swiftlint:disable:next no_any_protocol_existential
    public func encode(to encoder: any Encoder) throws(EncodingError) {
        // swift-linter:disable:next do throws for typed catch
        // REASON: SingleValueEncodingContainer.encode(_:) is an untyped `throws` stdlib protocol requirement; no typed `E` exists to name.
        do {
            var container = encoder.singleValueContainer()
            try container.encode(value)
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
