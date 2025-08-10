import ProjectDescription

extension Target {
    public static func target(
        name: String,
        product: Product,
        bundleId: String? = nil,
        deploymentTargets: ProjectDescription.DeploymentTargets? = .iOS(Project.iosVersion),
        infoPlist: InfoPlist? = .default,
        sources: SourceFilesList? = nil,
        resources: ResourceFileElements? = nil,
        entitlements: Entitlements? = nil,
        scripts: [TargetScript] = [],
        dependencies: [TargetDependency] = [],
        settings: Settings? = nil
    ) -> Target {
        Target.target(
            name: name,
            destinations: .init([.iPad, .iPhone]),
            product: product,
            bundleId: bundleId ?? Project.bundleID + "." + name.lowercased(),
            deploymentTargets: deploymentTargets,
            infoPlist: infoPlist,
            sources: sources,
            resources: resources,
            entitlements: entitlements,
            scripts: scripts,
            dependencies: dependencies,
            settings: settings
        )
    }
}

extension SourceFilesList {
    public static let sources: SourceFilesList = ["Sources/**"]
    public static let widgetSources: SourceFilesList = ["TDDiaryWidget/**"]
    public static let tests: SourceFilesList = ["Tests/**"]
}
