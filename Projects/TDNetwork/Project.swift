import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.project(
    name: TDModule.TDNetwork.rawValue,
    targets: [
        Target.target(
            name: TDModule.TDNetwork.rawValue,
            product: .framework,
            bundleId: Project.bundleID + ".network",
            sources: .sources,
            dependencies: [
                .core(),
                .domain(),
                .data()
            ]
        ),
        Target.target(
            name: "\(TDModule.TDNetwork.rawValue)Test",
            product: .unitTests,
            bundleId: Project.bundleID + ".networktest",
            sources: .tests,
            dependencies: [
                .network()
            ]
        )
    ]
)
