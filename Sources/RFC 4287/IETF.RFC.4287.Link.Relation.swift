import RFC_3987

extension IETF.RFC.`4287`.Link {

    public struct Relation: Hashable, Sendable, ExpressibleByStringLiteral {

        public let value: String

        public init(_ value: String) {
            self.value = value
        }
    }
}

extension IETF.RFC.`4287`.Link.Relation {

    public static let alternate = Self("alternate")

    public static let related = Self("related")

    public static let `self` = Self("self")

    public static let enclosure = Self("enclosure")

    public static let via = Self("via")

    public static let replies = Self("replies")
}

extension IETF.RFC.`4287`.Link.Relation {

    public init(stringLiteral value: String) {
        self.init(value)
    }
}

extension IETF.RFC.`4287`.Link.Relation: Codable {
    public init(from decoder: any Decoder) throws(DecodingError) {

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

    public func encode(to encoder: any Encoder) throws(EncodingError) {

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
