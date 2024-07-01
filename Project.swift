import ProjectDescription

let dependencies: [TargetDependency] = [
    .external(name: "Alamofire",condition: nil),
    .external(name: "SnapKit",condition: nil),
    .external(name: "Moya",condition: nil),
    .external(name: "Then",condition: nil),
]

let targets: [Target] = [
    .target(
        name: "toduck",
        destinations: .iOS,
        product: .app,
        bundleId: "to.duck.toduck",
        infoPlist: .dictionary([
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
//          resources: ["toduck/Resources/**"],
        dependencies: dependencies
    )
]

let project = Project(
    name: "toduck",
    settings: .settings(defaultSettings: .recommended),
    targets: targets
)




