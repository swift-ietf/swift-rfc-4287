import RFC_3987
import RFC_5646
public import RFC_9110

extension RFC_4287.Content {
    public enum ContentType: Hashable, Sendable, Codable {
        case text
        case html
        case xhtml
        case media(RFC_9110.MediaType)
    }
}
