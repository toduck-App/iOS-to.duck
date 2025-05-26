import ProjectDescription

extension Project {
    public static let bundleID = "to.duck.toduck"
    public static let iosVersion = "16.0"
}

extension Project {
    public static func project(
        name: String,
        targets: [Target] = [],
        additionalFiles: [FileElement] = []
    ) -> Project {
        Project(
            name: name,
            targets: targets,
            additionalFiles: additionalFiles
        )
    }
}
