//
//  TabbarItem.swift
//  toduck
//
//  Created by 박효준 on 7/16/24.
//

import UIKit

public enum TabbarItem: CaseIterable {
    case home, timer, diary, social, mypage
    
    var item: UITabBarItem {
        switch self {
        case .home:
            return .init(title: "홈", image: TDImage.Home.medium, tag: 0)
        case .timer:
            return .init(title: "집중", image: TDImage.Timer.medium, tag: 1)
        case .diary:
            return .init(title: "일기", image: TDImage.Diary.medium, tag: 2)
        case .social:
            return .init(title: "소셜", image: TDImage.Social.medium, tag: 3)
        case .mypage:
            return .init(title: "마이페이지", image: TDImage
                .Setting.bottomMedium, tag: 4)
        }
    }
}
