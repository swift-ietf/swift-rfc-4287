# swift-rfc-4287

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)
[![CI](https://github.com/swift-ietf/swift-rfc-4287/workflows/CI/badge.svg)](https://github.com/swift-ietf/swift-rfc-4287/actions/workflows/ci.yml)

Type-safe Atom feed generation and parsing for Swift (RFC 4287 implementation).

## Overview

swift-rfc-4287 provides complete Atom Syndication Format support as defined in RFC 4287 with type-safe Swift types for generating and parsing Atom feeds.

## Features

- **Complete RFC 4287 Support**: All required and optional feed and entry elements per RFC 4287 specification
- **Type Safety**: Compile-time validation with Hashable, Sendable, Codable conformance
- **Validation**: Failable initializers enforce Atom requirements (entries require content OR alternate link)
- **Codable Support**: JSON encoding/decoding support via Codable conformance
- **Swift 6.0 Concurrency**: Strict concurrency mode with complete Sendable conformance

## Installation

Add swift-rfc-4287 to your Package.swift dependencies:

```swift
dependencies: [
    .package(url: "https://github.com/swift-ietf/swift-rfc-4287", from: "0.1.4")
]
```

Then add the product to your target dependencies:

```swift
.target(
    name: "YourTarget",
    dependencies: [
        .product(name: "RFC 4287", package: "swift-rfc-4287")
    ]
)
```

## IRI Support (RFC 3987)

Per RFC 4287 requirements, all URI fields now use **`RFC_3987.IRI` types** for compile-time type safety and proper internationalization support.

This module automatically re-exports RFC 3987 (Internationalized Resource Identifiers), so you don't need to import it separately.

### IRI Fields

These fields are now typed as `RFC_3987.IRI` or `RFC_3987.IRI?`:
- `Feed.id`, `Entry.id` - Required IRI identifiers
- `Feed.icon`, `Feed.logo` - Feed imagery
- `Link.href` - Link destinations
- `Person.uri` - Person homepage
- `Content.src` - Out-of-line content source
- `Generator.uri`, `Category.scheme`, `Source` fields

### Using IRIs

You can create feeds using string literals (recommended), IRI types, or Foundation URLs:

```swift
// String literals (recommended - clean and simple)
let feed = RFC_4287.Feed(
    id: "https://example.com/feed",
    title: "My Feed",
    updated: Date()
)

// Explicit IRI type
let id = try RFC_3987.IRI("https://example.com/feed")
let feed = RFC_4287.Feed(id: id, title: "My Feed", updated: Date())

// Foundation URL (via IRI.Representable)
let url = URL(string: "https://example.com/feed")!
let feed = RFC_4287.Feed(id: url, title: "My Feed", updated: Date())
```

## Quick Start

```swift
import RFC_4287

// Create an Atom feed
let feed = RFC_4287.Feed(
    id: "urn:uuid:60a76c80-d399-11d9-b93C-0003939e0af6",
    title: "Example Feed",
    updated: Date(),
    authors: ["John Doe"],
    entries: [
        RFC_4287.Entry(
            id: "urn:uuid:1225c695-cfb8-4ebb-aaaa-80da344efa6a",
            title: "First Post",
            updated: Date(),
            content: RFC_4287.Content(value: "Hello, world!", type: .text)
        )!
    ]
)

print(feed?.title.value)  // "Example Feed"
print(feed?.entries.count)  // 1
```

## Usage Examples

### Creating Entries with Links

```swift
import RFC_4287

let entry = RFC_4287.Entry(
    id: "urn:uuid:entry-123",
    title: "Blog Post",
    updated: Date(),
    links: [
        RFC_4287.Link(
            href: "https://example.com/posts/123",
            rel: .alternate,
            type: "text/html"
        )
    ]
)

print(entry?.links.first?.href.value)  // "https://example.com/posts/123"
```

## Related Packages

- [swift-rss](https://github.com/swift-standards/swift-rss): Type-safe RSS 2.0 feed generation and parsing for Swift
- [swift-json-feed](https://github.com/swift-standards/swift-json-feed): Type-safe JSON Feed generation and parsing for Swift
- [swift-syndication](https://github.com/coenttb/swift-syndication): Unified syndication API supporting RSS, Atom, and JSON Feed with format conversion

## License

This project is licensed under the Apache License 2.0. See LICENSE for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
