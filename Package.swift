// swift-tools-version:5.10
import PackageDescription

let package = Package(
    name: "SendbirdAIAgentCore",
    platforms: [.iOS(.v14)],
    products: [
        .library(name: "SendbirdAIAgentCore", targets: ["SendbirdAIAgentCoreTarget"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/sendbird/sendbird-ios-distribution",
            from: "0.10.8"
        ),
        .package(
            url: "https://github.com/JohnSundell/Splash",
            from: "0.16.0"
        ),
        .package(
            url: "https://github.com/sendbird/sendbird-uikit-ios-spm",
            from: "3.35.4"
        ),
        .package(
            url: "https://github.com/sendbird/sendbird-chat-sdk-ios",
            from: "4.39.10"
        )
    ],
    targets: [
        .binaryTarget(
            name: "SendbirdAIAgentCore",
            url: "https://github.com/sendbird/delight-ai-agent-core-ios/releases/download/1.20.0/SendbirdAIAgentCore.xcframework.zip",
            checksum: "d0096d2ee3bfed28f3a4de7ce7a7fe5bf78dfdf62dfe8c402bed55399b0c1663"
        ),
        .target(
            name: "SendbirdAIAgentCoreTarget",
            dependencies: [
                .target(name: "SendbirdAIAgentCore"),
                .product(name: "SendbirdUIMessageTemplate", package: "sendbird-uikit-ios-spm"),
                .product(name: "SendbirdMarkdownUI", package: "sendbird-ios-distribution"),
                .product(name: "Splash", package: "Splash"),
                .product(name: "SendbirdChatSDK", package: "sendbird-chat-sdk-ios")
            ],
            path: "Framework/Dependency"
        )
    ]
)
