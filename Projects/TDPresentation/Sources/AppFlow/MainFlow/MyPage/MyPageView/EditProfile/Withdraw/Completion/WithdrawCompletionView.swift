//
//  WithdrawCompletionView.swift
//  TDPresentation
//
//  Created by 정지용 on 3/27/25.
//

import UIKit

import SnapKit
import TDDesign

protocol WithdrawCompletionViewDelegate: AnyObject {
    func WithdrawCompletionViewDidTapNextButton(_ view: WithdrawCompletionView)
}

final class WithdrawCompletionView: BaseView {
    weak var delegate: WithdrawCompletionViewDelegate?
    
    private let labelStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = LayoutConstants.labelStackSpacing
        return stackView
    }()
    
    private let titleLabel = TDLabel(
        toduckFont: .boldHeader3,
        toduckColor: TDColor.Neutral.neutral800
    )
    
    private let infoLabel = TDLabel(
        toduckFont: .mediumBody2,
        toduckColor: TDColor.Neutral.neutral500
    )
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.image = TDImage.Illust.withdraw
        return imageView
    }()
    
    private let nextButton = TDButton(
        title: "확인",
        size: .large
    )
    
    override func addview() {
        [titleLabel, infoLabel].forEach(labelStack.addArrangedSubview)
        [labelStack, imageView, nextButton].forEach(addSubview)
    }
    
    override func configure() {
        titleLabel.setText("회원 탈퇴가 완료되었어요")
        infoLabel.setText("""
        그동한 함께한 시간이 아쉽지만, 토덕은 언제나 여기서 기다릴게요.
        도움이 필요할때면 언제든 돌아오세요!
        """)
        
        titleLabel.numberOfLines = 0
        infoLabel.numberOfLines = 0
        titleLabel.setLineHeightMultiple(LayoutConstants.labelLineHeightMultiple)
        infoLabel.setLineHeightMultiple(LayoutConstants.labelLineHeightMultiple)
        
        nextButton.layer.borderColor = TDColor.Primary.primary500.cgColor
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    override func layout() {
        labelStack.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(LayoutConstants.topPadding)
            $0.leading.trailing.equalToSuperview().inset(LayoutConstants.horizontalPadding)
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(labelStack.snp.bottom).offset(LayoutConstants.imageViewSpacing)
            $0.leading.trailing.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(LayoutConstants.horizontalPadding)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(28)
            $0.height.equalTo(LayoutConstants.nextButtonSize)
        }
    }
}

private extension WithdrawCompletionView {
    @objc
    func nextButtonTapped() {
        delegate?.WithdrawCompletionViewDidTapNextButton(self)
    }
}

private extension WithdrawCompletionView {
    enum LayoutConstants {
        static let topPadding: CGFloat = 18
        static let imageViewSpacing: CGFloat = 120
        static let labelStackSpacing: CGFloat = 14
        static let labelLineHeightMultiple: CGFloat = 1.2
        static let horizontalPadding: CGFloat = 16
        static let nextButtonSize: CGFloat = 56
    }
}
