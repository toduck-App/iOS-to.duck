import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: TDModule.TDData.rawValue,
    targets: [
        Target.target(
            name: TDModule.TDData.rawValue,
            product: .framework,
            bundleId: Project.bundleID + ".data",
            sources: .sources,
            dependencies: [
                .domain(),
                .core(),
            ]
        ),
        Target.target(
            name: "\(TDModule.TDData.rawValue)Test",
            product: .unitTests,
            bundleId: Project.bundleID + ".datatest",
            sources: .tests,
            dependencies: [
                .data()
            ]
        )
    ]
)
