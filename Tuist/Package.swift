// swift-tools-version: 5.9
import PackageDescription

#if TUIST
import ProjectDescription

let packageSettings = PackageSettings(
    
    productTypes: [
        "Alamofire": .framework,
        "SnapKit": .framework,
        "Kingfisher": .framework,
        "Moya": .framework,
        "Then": .framework
    ]
)
#endif

let package = Package(
    name: "toduck",
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire", from: "5.0.0"),
        .package(url: "https://github.com/SnapKit/SnapKit", from: "5.7.1"),
        .package(url: "https://github.com/onevcat/Kingfisher", from: "7.11.0"),
        .package(url: "https://github.com/Moya/Moya", from: "15.0.3"),
        .package(url: "https://github.com/devxoul/Then", from: "3.0.0")
    ]
)
