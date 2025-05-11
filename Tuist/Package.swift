// swift-tools-version: 6.0
@preconcurrency import PackageDescription

#if TUIST
import ProjectDescription

let packageSettings = PackageSettings(
    productTypes: [
        "SnapKit": .framework,
        "Lottie": .framework,
        "Kingfisher": .framework,
        "Then": .framework,
        "FSCalendar": .framework,
        "FittedSheets": .framework,
        "Swinject": .framework,
        "KeyChainManager": .framework,
        "FirebaseAnalytics": .framework,
    ]
)
#endif

let package = Package(
    name: "toduck",
    dependencies: [
        .package(url: "https://github.com/SnapKit/SnapKit", from: "5.7.1"),
        .package(url: "https://github.com/airbnb/lottie-ios", from: "4.5.1"),
        .package(url: "https://github.com/onevcat/Kingfisher", from: "7.11.0"),
        .package(url: "https://github.com/devxoul/Then", from: "3.0.0"),
        .package(url: "https://github.com/WenchaoD/FSCalendar", from: "2.8.4"),
        .package(url: "https://github.com/gordontucker/FittedSheets.git", from: "2.6.1"),
        .package(url: "https://github.com/Swinject/Swinject.git", from: "2.9.1"),
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.10.2"),
        .package(url: "https://github.com/kakao/kakao-ios-sdk.git", from: "2.23.0"),
        .package(url: "https://github.com/Kyxxn/SPM-KeyChainManager-KJ.git", from: "1.0.1"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "11.12.0"),
    ]
)
