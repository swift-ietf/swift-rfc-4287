//
//  File.swift
//  swift-rfc-4287
//
//  Created by Coen ten Thije Boonkkamp on 01/12/2025.
//

extension RFC_4287 {
    /// A subtitle text construct as defined in RFC 4287
    ///
    /// Represents the subtitle element used in feeds.
    public struct Subtitle: Hashable, Sendable, Codable {
        /// The underlying text construct
        public let text: Text

        /// Creates a new subtitle
        ///
        /// - Parameter text: The text construct
        public init(_ text: Text) {
            self.text = text
        }

        /// Creates a new subtitle with a string value
        ///
        /// - Parameters:
        ///   - value: The subtitle text
        ///   - type: The content type (defaults to .text)
        ///   - base: Base IRI for resolving relative references
        ///   - lang: Language of the content
        public init(
            _ value: String,
            type: Text.ContentType = .text,
            // REASON: nil-defaulted optional existential parameter; no lawful generic spelling (T? = nil defeats inference); rule-scope refinement tracked at swift-foundations/swift-linter-rules#4
            // swiftlint:disable:next no_any_protocol_existential
            base: (any RFC_3987.IRI.Representable)? = nil,
            lang: String? = nil
        ) {
            self.text = Text(value, type: type, base: base, lang: lang)
        }
    }
}

extension RFC_4287.Subtitle {

    /// The subtitle value
    public var value: String { text.value }

    /// The content type
    public var type: RFC_4287.Text.ContentType { text.type }

    /// Base IRI for resolving relative references
    public var base: RFC_3987.IRI? { text.base }

    /// Language of the content
    public var lang: String? { text.lang }
}

extension RFC_4287.Subtitle: ExpressibleByStringLiteral {
    /// Creates a subtitle from a string literal (defaults to .text type)
    public init(stringLiteral value: String) {
        self.init(value, type: .text)
    }
}
