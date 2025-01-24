//
//  BadgeLabel.swift
//  TDPresentation
//
//  Created by 정지용 on 1/14/25.
//

import UIKit
import SnapKit

import TDDesign

final class BadgeLabel: BaseView {
    private let badgeLabel: UILabel = {
        let label = UILabel()
        label.font = TDFont.mediumCaption2.font
        label.textColor = TDColor.Primary.primary500
        return label
    }()
    
    init(text: String) {
        super.init(frame: .zero)
        badgeLabel.text = text
        setupViews()
        setupLayoutConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        let labelSize = badgeLabel.intrinsicContentSize
        let width = labelSize.width + LayoutConstants.horizontalContentSize
        let height = labelSize.height + LayoutConstants.verticalContentSize
        return CGSize(width: width, height: height)
    }
}

// MARK: - Private Methods
private extension BadgeLabel {
    func setupViews() {
        addSubview(badgeLabel)
        backgroundColor = TDColor.Primary.primary25
        layer.cornerRadius = LayoutConstants.badgeCornerRadius
        clipsToBounds = true
    }
    
    func setupLayoutConstraints() {
        badgeLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
}

// MARK: - Constants
private extension BadgeLabel {
    enum LayoutConstants {
        static let badgeCornerRadius: CGFloat = 4
        static let verticalContentSize: CGFloat = 5 * 2
        static let horizontalContentSize: CGFloat = 6 * 2
    }
}
