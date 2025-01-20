//
//  MyPageMenuView.swift
//  TDPresentation
//
//  Created by 정지용 on 1/14/25.
//

import UIKit
import SnapKit

final class MyPageSocialButtonView: UIView {
    let menuStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = LayoutConstants.menuStackViewSpacing
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupViews()
        setupLayoutConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Methods
private extension MyPageSocialButtonView {
    func setupViews() {
        addSubview(menuStackView)
        [
            MyPageMenuContainer(type: .calendar),
            MyPageMenuContainer(type: .routine),
            MyPageMenuContainer(type: .share)
        ].forEach { menuStackView.addArrangedSubview($0) }
    }
    
    func setupLayoutConstraints() {
        menuStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(LayoutConstants.stackViewUpperPadding)
            $0.bottom.equalToSuperview().offset(-LayoutConstants.stackViewLowerPadding)
            $0.leading.trailing.equalToSuperview().inset(LayoutConstants.stackViewHorizontalPadding)
        }
    }
}

// MARK: - Constants
private extension MyPageSocialButtonView {
    enum LayoutConstants {
        static let menuStackViewSpacing: CGFloat = 10
        static let stackViewUpperPadding: CGFloat = 8
        static let stackViewLowerPadding: CGFloat = 20
        static let stackViewHorizontalPadding: CGFloat = 17.5
    }
}
