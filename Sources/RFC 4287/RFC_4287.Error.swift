extension RFC_4287 {
    /// Errors that can occur when validating or parsing Atom documents
    public enum Error: Swift.Error, Hashable, Sendable {
        case feedRequiresAuthors
        case entryRequiresContentOrAlternateLink
        case invalidDateFormat(String)
        case invalidXML(String)
        case missingRequiredElement(String)
        case invalidElementValue(String, String)
    }
}
