import ProjectDescription
import ProjectDescriptionHelpers

// MARK: - Target

let appTarget = Target.target(
    name: "toduck",
    product: .app,
    bundleId: Project.bundleID,
    infoPlist: .file(path: .relativeToRoot("Projects/toduck/SupportingFiles/Info.plist")),
    sources: .sources,
    resources: [
        .glob(pattern: .relativeToRoot("Projects/toduck/Resources/**")),
        .glob(pattern: .relativeToRoot("Projects/toduck/Resources/LaunchScreen.storyboard")),
        .glob(pattern: .relativeToRoot("Projects/toduck/SupportingFiles/GoogleService-Info.plist")),
    ],
    entitlements: .file(path: .relativeToRoot("Projects/toduck/SupportingFiles/toduck.entitlements")),
    dependencies: [
        // Module
        .data(),
        .presentation(),
        .core(),
        .design(),
        .network(),
        .storage(),
        .domain(),
    ],
    settings: .settings(
        base: [
            "DEVELOPMENT_LANGUAGE": "ko",
            "OTHER_LDFLAGS": ["$(inherited)", "-ObjC"]
        ],
        configurations: [
            .debug(name: "Debug", xcconfig: "SupportingFiles/Debug.xcconfig"),
            .release(name: "Release", xcconfig: "SupportingFiles/Release.xcconfig")
        ]
    )
)

// MARK: - Project

let project = Project.project(
    name: "toduck",
    targets: [
        appTarget,
    ]
)
