import RFC_5646

extension KeyedDecodingContainer {

    /// Atom documents are third-party data, so a malformed optional `xml:lang` reads as absent rather than rejecting the document.
    ///
    /// Overload resolution sends every `lang` in this module here, the synthesized `Decodable`s included.
    func decodeIfPresent(_ type: RFC_5646.LanguageTag.Type, forKey key: Key) throws -> RFC_5646.LanguageTag? {
        try decodeIfPresent(String.self, forKey: key).flatMap { try? RFC_5646.LanguageTag($0) }
    }
}
