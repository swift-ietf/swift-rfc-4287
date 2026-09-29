// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-rfc-4287",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(
            name: "RFC 4287",
            targets: ["RFC 4287"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/swift-ietf/swift-rfc-2822.git", branch: "main"),
        .package(url: "https://github.com/swift-ietf/swift-rfc-3339.git", branch: "main"),
        .package(url: "https://github.com/swift-ietf/swift-rfc-3987.git", branch: "main"),
        .package(url: "https://github.com/swift-ietf/swift-rfc-4648.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-binary.git", branch: "main", traits: ["Serializer"]),
    ],
    targets: [
        .target(
            name: "RFC 4287",
            dependencies: [.product(name: "RFC 2822", package: "swift-rfc-2822"), .product(name: "RFC 3339", package: "swift-rfc-3339"), .product(name: "RFC 3987", package: "swift-rfc-3987"), .product(name: "RFC 4648", package: "swift-rfc-4648")]
        ),
        .testTarget(
            name: "RFC 4287 Tests",
            dependencies: [
                .target(name: "RFC 4287"),
                .product(name: "Binary", package: "swift-binary"),
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
