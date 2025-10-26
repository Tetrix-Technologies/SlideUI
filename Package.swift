// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SlideUI",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "SlideUI",
            targets: ["SlideUI"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SlideUI",
            dependencies: [],
            path: "Sources/SlideUI"
        ),
        .testTarget(
            name: "SlideUITests",
            dependencies: ["SlideUI"],
            path: "Tests/SlideUITests"
        ),
    ]
)
