//
//  UINavigationController+SetupNavigationBar.swift
//  TDPresentation
//
//  Created by 정지용 on 1/22/25.
//

import UIKit
import SnapKit

import TDDesign

extension UINavigationController {
    func setupNestedNavigationBar(
        leftButtonTitle: String,
        leftButtonAction: UIAction?,
        rightButtonTitle: String? = nil,
        rightButtonAction: UIAction? = nil
    ) {
        guard let topViewController else { return }
        topViewController.navigationItem.leftBarButtonItem = createLeftBarButton(
            title: leftButtonTitle,
            action: leftButtonAction
        )
        if let rightButtonTitle {
            topViewController.navigationItem.rightBarButtonItem = createRightBarButton(
                title: rightButtonTitle,
                font: TDFont.boldHeader4.font,
                action: rightButtonAction
            )
        }
    }
    
    func updateRightButtonState(to state: UIControl.State) {
        guard let container = topViewController?.navigationItem.rightBarButtonItem?.customView,
              let rightButton = container.subviews.first(where: { $0 is UIButton }) as? UIButton else {
            return
        }
        
        if state == .normal {
            rightButton.isEnabled = true
            rightButton.isUserInteractionEnabled = true
        } else {
            rightButton.isEnabled = false
            rightButton.isUserInteractionEnabled = false
        }
    }
}

private extension UINavigationController {
    private func createLeftBarButton(
        title: String,
        action: UIAction?
    ) -> UIBarButtonItem {
        let container = UIButton(type: .custom)
        let backButtonView = UIImageView(image: TDImage.Direction.leftMedium.withRenderingMode(.alwaysTemplate))
        
        let titleLabel = TDLabel(toduckFont: .boldHeader4, toduckColor: TDColor.Neutral.neutral800)
        titleLabel.text = title
        backButtonView.tintColor = TDColor.Neutral.neutral800
        [backButtonView, titleLabel].forEach { container.addSubview($0) }
        
        if let action {
            container.addAction(action, for: .touchUpInside)
        }
        
        container.addAction(UIAction { _ in
            backButtonView.tintColor = TDColor.Neutral.neutral600
            titleLabel.textColor = TDColor.Neutral.neutral600
        }, for: .touchDown)
        
        container.addAction(UIAction { _ in
            backButtonView.tintColor = TDColor.Neutral.neutral800
            titleLabel.textColor = TDColor.Neutral.neutral800
        }, for: [.touchUpInside, .touchCancel, .touchDragExit])
        
        backButtonView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.height.width.equalTo(LayoutConstants.leftImageViewSize)
            $0.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(backButtonView.snp.trailing).offset(LayoutConstants.leftItemSpacing)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        
        return UIBarButtonItem(customView: container)
    }
    
    private func createRightBarButton(
        title: String,
        font: UIFont,
        action: UIAction?
    ) -> UIBarButtonItem {
        let container = UIView()
        let button = UIButton(type: .system)
        
        button.setTitle(title, for: .normal)
        button.setTitleColor(TDColor.Neutral.neutral600, for: .disabled)
        button.setTitleColor(TDColor.Neutral.neutral800, for: .normal)
        button.isUserInteractionEnabled = false
        button.titleLabel?.font = font
        button.sizeToFit()
        button.isEnabled = false
        container.addSubview(button)
        
        if let action {
            button.addAction(action, for: .touchUpInside)
        }
        
        button.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        
        container.snp.makeConstraints {
            $0.width.equalTo(LayoutConstants.rightBarButtonItemWidth)
        }
        
        return UIBarButtonItem(customView: container)
    }
}

fileprivate enum LayoutConstants {
    static let leftItemSpacing: CGFloat = 16
    static let leftImageViewSize: CGFloat = 24
    static let rightBarButtonItemWidth: CGFloat = 51
}
