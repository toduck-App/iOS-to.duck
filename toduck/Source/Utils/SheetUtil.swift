//
//  SheetUtil.swift
//  toduck
//
//  Created by 박효준 on 8/4/24.
//

import UIKit

struct SheetUtil {
    /// ViewController가 갖는 view의 높이를 계산하는데 사용됨
    static func calculateHeight(for viewController: UIViewController) -> CGFloat {
        viewController.view.layoutIfNeeded()
        
//        let viewSize: CGSize = UIView.layoutFittingCompressedSize
//        
//        return viewController.view.systemLayoutSizeFitting(viewSize).height
        
        let targetSize = CGSize(width: viewController.view.bounds.width, height: 0)
        var height = viewController.view.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        ).height
            
        return height
    }
}
