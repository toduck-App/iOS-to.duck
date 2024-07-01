// swift-tools-version: 5.9
import PackageDescription

#if TUIST
    import ProjectDescription

    let packageSettings = PackageSettings(
        // Customize the product types for specific package product
        // Default is .staticFramework
        // productTypes: ["Alamofire": .framework,] 
        productTypes: [:]
    )
#endif

let package = Package(
    name: "toduck",
    dependencies: [
            .package(url: "https://github.com/Alamofire/Alamofire", from: "5.0.0"),
            .package(url: "https://github.com/SnapKit/SnapKit.git", from: "5.7.1"),
            .package(url: "https://github.com/Moya/Moya.git", from: "15.0.3"),
            .package(url: "https://github.com/devxoul/Then.git", from: "3.0.0")
        ]
)
