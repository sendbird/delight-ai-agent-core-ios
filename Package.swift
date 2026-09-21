// swift-tools-version:5.10
import PackageDescription

// Splash 는 바이너리로 배포한다.
//
// Xcode 27 의 iOS SDK 는 최소 배포 타깃이 15.0 이라 소스 패키지를 iOS 14 로
// 빌드하지 못한다. SendbirdAIAgentCore 의 swiftinterface 는 ios14.0 이고 그 안에서
// Splash 타입(CodeBlockTheme)을 참조하므로, Splash 가 소스로 남아 있으면
// 재컴파일이 "module 'Splash' has a minimum deployment target of iOS 15.0" 으로 실패한다.
//
// 모듈 이름은 업스트림과 같은 `Splash` 를 유지한다. public API 가 바뀌지 않는다.
// 대신 고객이 JohnSundell/Splash 를 직접 의존하고 있으면 타깃 이름이 충돌하므로
// 그 의존을 빼야 한다. 코드 수정은 필요 없다.
//
// xcframework 는 sendbird-ios-distribution 의 scripts/build_xcframeworks.sh 가
// 업스트림 0.16.0 소스로 만들고, sendbird-ios-distribution 의 릴리즈 태그에 zip 으로 올린다.
//
// Splash 의 url 태그는 ai-agent-ios/Configurations/Base.xcconfig 의
// DISTRIBUTION_PACKAGE_VERSION 과 항상 같아야 한다. 아래 sendbird-ios-distribution
// 의존의 from: 도 같은 값이다. 릴리즈 CI 의
// ai-agent-ios/scripts/update_versions_public_repo.sh 가 이 변수 하나로
// 두 값을 함께 갱신하고 checksum 을 채운다.

let package = Package(
    name: "SendbirdAIAgentCore",
    platforms: [.iOS(.v14)],
    products: [
        .library(name: "SendbirdAIAgentCore", targets: ["SendbirdAIAgentCoreTarget"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/sendbird/sendbird-ios-distribution",
            branch: "test/aa-18079-spm-remote"
        ),
        .package(
            url: "https://github.com/sendbird/sendbird-uikit-ios-spm",
            from: "3.35.4"
        ),
        .package(
            url: "https://github.com/sendbird/sendbird-chat-sdk-ios",
            from: "4.39.11"
        )
    ],
    targets: [
        .binaryTarget(
            name: "SendbirdAIAgentCore",
            url: "https://github.com/sendbird/sendbird-ios-distribution/releases/download/spm-test-aa-18079-35554001178/SendbirdAIAgentCore.xcframework.zip",
            checksum: "52b3f7ab6b5c348a04b41e8e676a6cc5109b7bb996b91f29db760d8ed1b640b4"
        ),
        .binaryTarget(
            name: "Splash",
            url: "https://github.com/sendbird/sendbird-ios-distribution/releases/download/spm-test-aa-18079-35554001178/Splash.xcframework.zip",
            checksum: "a793d509bc194f77d1afa14a955d653d4be512aaef658fd2ad7dcfdc5de21bbf"
        ),
        // binaryTarget 은 의존을 선언할 수 없다. 이 빈 타깃이 대신 묶는다.
        .target(
            name: "SendbirdAIAgentCoreTarget",
            dependencies: [
                .target(name: "SendbirdAIAgentCore"),
                .target(name: "Splash"),
                .product(name: "SendbirdMarkdownUI", package: "sendbird-ios-distribution"),
                .product(name: "SendbirdNetworkImage", package: "sendbird-ios-distribution"),
                .product(name: "SendbirdUIMessageTemplate", package: "sendbird-uikit-ios-spm"),
                .product(name: "SendbirdChatSDK", package: "sendbird-chat-sdk-ios")
            ],
            path: "Framework/Dependency"
        )
    ]
)
