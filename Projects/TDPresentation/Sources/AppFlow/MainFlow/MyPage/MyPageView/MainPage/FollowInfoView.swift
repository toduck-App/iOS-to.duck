//
//  FollowInfoView.swift
//  TDPresentation
//
//  Created by 정지용 on 1/10/25.
//

import UIKit
import SnapKit

import TDDesign

final class FollowInfoView: UIView {
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        stackView.spacing = LayoutConstants.stackViewSpacing
        return stackView
    }()
    
    private let typeLabel = TDLabel(toduckFont: .mediumCaption1, toduckColor: TDColor.Neutral.neutral600)
    
    private let numberLabel = TDLabel(toduckFont: .boldBody3, toduckColor: TDColor.Neutral.neutral800)
    
    init(type: String, number: Int) {
        super.init(frame: .zero)
        setupViews(type, number)
        setupLayoutConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(
        type: String,
        number: Int
    ) {
        typeLabel.text = type
        numberLabel.text = "\(number)"
    }
}

// MARK: - Private Methods
private extension FollowInfoView {
    func setupViews(
        _ type: String,
        _ number: Int
    ) {
        typeLabel.setText(type)
        numberLabel.setText("\(number)")
        addSubview(stackView)
        [typeLabel, numberLabel].forEach {
            stackView.addArrangedSubview($0)
        }
    }
    
    func setupLayoutConstraints() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        typeLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
        }
        
        numberLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
        }
    }
}

// MARK: - Constants
private extension FollowInfoView {
    enum LayoutConstants {
        static let stackViewSpacing: CGFloat = 8
    }
}
