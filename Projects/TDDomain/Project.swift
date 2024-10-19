import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.project(
    name: TDModule.TDDomain.rawValue,
    targets: [
        Target.target(
            name: TDModule.TDDomain.rawValue,
            product: .framework,
            bundleId: Project.bundleID + ".domain",
            sources: .sources,
            dependencies: [
            ]
        ),
    ]
)
