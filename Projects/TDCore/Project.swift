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
                .external(name: "Swinject")
            ]
        ),
        Target.target(
            name: "\(TDModule.TDCore.rawValue)Test",
            product: .unitTests,
            sources: .tests,
            dependencies: [
                .external(name: "Swinject")
            ]
        )
    ]
)
