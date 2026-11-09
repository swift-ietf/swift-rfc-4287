# swift-rfc-4287

Use this package when you need to model an Atom feed (RFC 4287) as values and have its structural rules checked when you build it. Start from `RFC_4287.Feed` and `RFC_4287.Entry`. To write a feed as Atom XML, add `RFC 4287 XML` and encode `W3C_XML.Document(feed)`. The package does not read Atom XML, and its `Codable` conformances give a keyed form of the same fields. For RSS, use swift-rss-standard. For JSON Feed, use swift-json-feed-standard.

## Laws

- `RFC 4287 XML` writes a feed in the Atom namespace with every element the model holds, `xml:base` and `xml:lang` as attributes, and xhtml text or content as an XHTML `div`; markup that is not well-formed XML throws instead of being written as text.
- An entry needs content or an alternate link. A link with no `rel` counts as alternate.
- An entry whose content points elsewhere through `src`, or whose content needs Base64, must also have a summary.
- Content needs Base64 when its type is a media type that is not `text/*` and does not end in `/xml` or `+xml`. The comparison ignores case, so `Application/XML` is not Base64 and `application/xmlish` is.
- `RFC_4287.Content.init(rawBytes:mediaType:base:lang:)` stores the bytes Base64-encoded in `value`.
- A feed with entries needs authors: either the feed has at least one, or every entry has its own. A feed with no entries may have no authors.
- The content types `text`, `html` and `xhtml` encode as those words. Any other content type encodes as its media type string, and decoding maps the three words back to the named cases.
- A person encodes its `uri`, `email` and `base` as plain strings. Decoding an `email` that is not a valid address fails with a data-corrupted `DecodingError`.
