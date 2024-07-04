import ProjectDescription

let targets: [Target] = [
    .target(
        name: "toduck",
        destinations: [.iPhone],
        product: .app,
        bundleId: "to.duck.toduck",
        infoPlist: .extendingDefault(with: [
            "CFBundleIdentifier": "to.duck.toduck",
            "CFBundleVersion": "1.0",
            "CFBundleShortVersionString": "1.0",
            "CFBundleExecutable": "toduck",
            "UIApplicationSceneManifest": [
                "UIApplicationSupportsMultipleScenes": false,
                "UISceneConfigurations": [
                    "UIWindowSceneSessionRoleApplication": [
                        [
                            "UISceneConfigurationName": "Default Configuration",
                            "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                        ]
                    ]
                ]
            ],
            "UILaunchScreen": [
                "UIColorName": "",
                "UIImageName": ""
            ]
        ]),
        sources: ["toduck/**"],
        resources: ["toduck/Resources/**"],
        dependencies: [
            .external(name: "Alamofire"),
            .external(name: "SnapKit"),
            .external(name: "Kingfisher"),
            .external(name: "Moya"),
            .external(name: "Then")]
    )
]

let project = Project(
    name: "toduck",
    settings: .settings(defaultSettings: .recommended),
    targets: targets
)




