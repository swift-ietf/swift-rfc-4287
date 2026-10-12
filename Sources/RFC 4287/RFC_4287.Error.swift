extension RFC_4287 {

    public enum Error: Swift::Error, Hashable, Sendable {
        case feedRequiresAuthors
        case entryRequiresContentOrAlternateLink
        case invalidDateFormat(String)
        case invalidXML(String)
        case missingRequiredElement(String)
        case invalidElementValue(String, String)
    }
}
