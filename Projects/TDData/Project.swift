//
//  Project.swift
//  Packages
//
//  Created by 박효준 on 10/19/24.
//

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
                .network()
            ]
        )
    ]
)