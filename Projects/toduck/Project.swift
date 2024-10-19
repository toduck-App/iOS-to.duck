import ProjectDescription
import ProjectDescriptionHelpers

// MARK: - Target

let appTarget = Target.target(
    name: "toduck",
    product: .app,
    bundleId: Project.bundleID + ".app".lowercased(),
    infoPlist: .file(path: .relativeToRoot("Projects/toduck/Supporting Files/Info.plist")),
    sources: .sources,
    resources: [
        .glob(pattern: .relativeToRoot("Projects/toduck/Resources/**")),
    ],
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
    settings: .settings(configurations: [
        .debug(name: "Debug", xcconfig: "Projects/toduck/Supporting Files/Debug.xcconfig"),
        .release(name: "Release", xcconfig: "Projects/toduck/Supporting Files/Release.xcconfig")
    ])
)

// MARK: - Project

let project = Project.project(
    name: "toduck",
    targets: [
        appTarget,
    ]
)
