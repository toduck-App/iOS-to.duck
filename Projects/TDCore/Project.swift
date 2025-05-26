import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: TDModule.TDCore.rawValue,
    targets: [
        Target.target(
            name: TDModule.TDCore.rawValue,
            product: .framework,
            bundleId: Project.bundleID + ".core",
            sources: .sources,
            dependencies: [
                .external(dependency: .Swinject),
                .external(dependency: .KeyChainManager),
                .external(dependency: .Then)
            ]
        )
    ]
)
