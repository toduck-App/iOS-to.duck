//
//  MyPageMenuContainer.swift
//  TDPresentation
//
//  Created by 정지용 on 1/14/25.
//

import UIKit
import SnapKit

import TDDesign

enum ContainerType {
    case calendar
    case routine
    case share
}

final class MyPageMenuContainer: UIView {
    let icon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = LayoutConstants.iconCornerRadius
        return imageView
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.font = TDFont.mediumBody2.font
        label.textColor = TDColor.Neutral.neutral800
        return label
    }()
    
    init(type: ContainerType) {
        super.init(frame: .zero)
        setupViews(type: type)
        setupLayoutConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Methods
private extension MyPageMenuContainer {
    func setupViews(type: ContainerType) {
        layer.cornerRadius = LayoutConstants.containerCornerRadius
        backgroundColor = TDColor.Neutral.neutral50
        [icon, label].forEach { addSubview($0) }
        
        switch type {
        case .calendar:
            icon.image = TDImage.Calendar.top2Medium
            label.text = "오늘의 일정"
        case .routine:
            icon.image = TDImage.checkMedium.withRenderingMode(.alwaysTemplate)
            icon.tintColor = TDColor.Neutral.neutral500
            icon.backgroundColor = TDColor.Neutral.neutral300
            label.text = "오늘의 루틴"
        case .share:
            icon.image = TDImage.Social.medium
            label.text = "공유하기"
        }
    }
    
    func setupLayoutConstraints() {
        icon.snp.makeConstraints {
            $0.top.equalToSuperview().offset(LayoutConstants.verticalPadding)
            $0.centerX.equalToSuperview()
        }
        
        label.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-LayoutConstants.verticalPadding)
            $0.centerX.equalToSuperview()
        }
    }
}

// MARK: - Constants
private extension MyPageMenuContainer {
    enum LayoutConstants {
        static let verticalPadding: CGFloat = 14
        static let iconCornerRadius: CGFloat = 4
        static let containerCornerRadius: CGFloat = 8
    }
}
