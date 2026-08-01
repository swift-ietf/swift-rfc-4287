import RFC_3987
import RFC_2822

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
        // swift-linter:disable:next do throws for typed catch
        // REASON: KeyedDecodingContainer.decode(_:forKey:)/decodeIfPresent(_:forKey:) are untyped `throws` stdlib protocol requirements; no typed `E` exists to name.
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            name = try container.decode(String.self, forKey: .name)
            if let uriString = try container.decodeIfPresent(String.self, forKey: .uri) {
                uri = try RFC_3987.IRI(uriString)
            } else {
                uri = nil
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

            if let baseString = try container.decodeIfPresent(String.self, forKey: .base) {
                base = try RFC_3987.IRI(baseString)
            } else {
                base = nil
            }
            lang = try container.decodeIfPresent(String.self, forKey: .lang)
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
        // REASON: KeyedEncodingContainer.encode(_:forKey:)/encodeIfPresent(_:forKey:) are untyped `throws` stdlib protocol requirements; no typed `E` exists to name.
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
