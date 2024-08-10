//
//  TDSheetPresentation.swift
//  toduck
//
//  Created by 박효준 on 8/4/24.
//

import UIKit

protocol TDSheetPresentation where Self: UIViewController {
    func showSheet(with contentViewController: UIViewController)
    // 확장성: setSheetAppearance, sheetWillAppear, sheetWillDisappear 가능
}

extension TDSheetPresentation {
    typealias SheetDetent = UISheetPresentationController.Detent
    
    func showSheet(with contentViewController: UIViewController) {
        if let sheet = contentViewController.sheetPresentationController {
            let identifier = SheetDetent.Identifier("customDetent")
            let customDetent = SheetDetent.custom(identifier: identifier) { _ in
                SheetUtil.calculateHeight(for: contentViewController)
            }
            sheet.detents = [customDetent]
            sheet.prefersGrabberVisible = true
        }
        setBottomConstraint(for: contentViewController.view)
        contentViewController.view.backgroundColor = TDColor.baseWhite
        present(contentViewController, animated: true, completion: nil)
    }
    
    // MARK: 시트지에 보일 뷰 요소 중, 마지막 요소에 bottom 안전구역 지정
    private func setBottomConstraint(for view: UIView) {
        if let lastSubview = view.subviews.last {
            let safeAreaBottomInset = view.safeAreaInsets.bottom
            lastSubview.snp.makeConstraints { make in
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-safeAreaBottomInset)
            }
        }
    }
}
