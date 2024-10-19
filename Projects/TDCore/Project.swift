import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: TDModule.TDCore.rawValue,
    targets: [
        Target.target(
            name: TDModule.TDCore.rawValue,
            product: .staticLibrary,
            sources: .sources,
            dependencies: [
            ]
        )
    ]
)
