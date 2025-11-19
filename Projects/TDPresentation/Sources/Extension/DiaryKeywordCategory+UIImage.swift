//
//  DiaryKeywordCategory+UIImage.swift
//  TDPresentation
//
//  Created by 승재 on 11/16/25.
//

import TDDomain
import TDDesign
import UIKit

extension DiaryKeywordCategory {
    var image: UIImage {
        switch self {
        case .person:
            TDImage.peopleNeutral
        case .place:
            TDImage.placeSmall
        case .situation:
            TDImage.talkNeutral
        case .result:
            TDImage.Category.heart
                .withRenderingMode(.alwaysOriginal)
                .withTintColor(TDColor.Neutral.neutral300)
        }
    }
}
