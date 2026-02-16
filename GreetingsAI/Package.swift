// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "GreetingsAI",
    platforms: [
        .macOS(.v12),
        .iOS(.v15)
    ],
    products: [
        .library(name: "Models", targets: ["Models"]),
        .library(name: "Services", targets: ["Services"]),
        .library(name: "ViewModels", targets: ["ViewModels"]),
    ],
    targets: [
        .target(name: "Models", path: "Models"),
        .target(name: "Services", path: "Services", dependencies: []),
        .target(name: "ViewModels", path: "ViewModels", dependencies: ["Models", "Services"]),
        .testTarget(name: "GreetingsAITests", path: "Tests"),
    ]
)
