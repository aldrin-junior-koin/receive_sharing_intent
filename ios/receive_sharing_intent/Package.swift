// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "receive_sharing_intent",
    platforms: [
        .iOS("12.0"),
    ],
    products: [
        .library(name: "receive-sharing-intent", targets: ["receive_sharing_intent"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "receive_sharing_intent",
            dependencies: [],
            resources: [
                .process("PrivacyInfo.xcprivacy"),
            ]
        )
    ]
)
