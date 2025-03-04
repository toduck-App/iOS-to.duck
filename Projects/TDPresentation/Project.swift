import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: TDModule.TDPresentation.rawValue,
    targets: [
        Target.target(
            name: TDModule.TDPresentation.rawValue,
            product: .framework,
            bundleId: Project.bundleID + ".presentation",
            sources: .sources,
            dependencies: [
                // Module
                .domain(),
                .design(),
                .core(),
                
                // External
                .external(dependency: .Then),
                .external(dependency: .SnapKit),
                .external(dependency: .Lottie),
                .external(dependency: .FSCalendar),
                .external(dependency: .Kingfisher),
                .external(dependency: .FittedSheets),
            ]
        ),
        Target.target(
            name: "\(TDModule.TDPresentation.rawValue)Test",
            product: .unitTests,
            bundleId: Project.bundleID + ".presentationtest",
            sources: .tests,
            dependencies: [
                .presentation()
            ]
        ),
    ]
)
