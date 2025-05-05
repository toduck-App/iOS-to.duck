//
//  WithdrawReasonInputView.swift
//  TDPresentation
//
//  Created by 정지용 on 1/29/25.
//

import UIKit
import TDDomain
import TDDesign

protocol WithdrawReasonInputViewDelegate: AnyObject {
    func withdrawReasonInputViewDidTapNextButton(_ withdrawReasonInputView: WithdrawReasonInputView, selectedReason: WithdrawReasonType, reasonText: String)
}


final class WithdrawReasonInputView: BaseView {
    weak var delegate: WithdrawReasonInputViewDelegate?
    private var selectedReason: WithdrawReasonType?
    
    private let contentView = UIView()
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.alwaysBounceHorizontal = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
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
    
    private let reasonStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    private let spacerView = UIView()
    
    private let nextButton = TDButton(
        title: "다음",
        size: .large
    )
    
    override func addview() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        [titleLabel, infoLabel].forEach { labelStack.addArrangedSubview($0) }
        [
            TDCheckboxField(type: WithdrawReasonType.hardToUse),
            TDCheckboxField(type: WithdrawReasonType.missingFeatures),
            TDCheckboxField(type: WithdrawReasonType.frequentErrors),
            TDCheckboxField(type: WithdrawReasonType.foundBetterApp),
            TDCheckboxField(type: WithdrawReasonType.rejoinWithNewAccount),
            TDCheckboxField(type: WithdrawReasonType.other)
        ].forEach {
            $0.delegate = self
            reasonStack.addArrangedSubview($0)
        }
        [labelStack, reasonStack, spacerView, nextButton].forEach { contentView.addSubview($0) }
    }
    
    override func configure() {
        titleLabel.setText("탈퇴 이유를 알려주세요")
        infoLabel.setText("""
        더 사용하기 편하고 좋은 서비스를 제공하기 위해
        토덕 운영진은 더욱 더 노력하겠습니다.
        """)
        
        titleLabel.numberOfLines = 0
        infoLabel.numberOfLines = 0
        
        titleLabel.setLineHeightMultiple(LayoutConstants.labelLineHeightMultiple)
        infoLabel.setLineHeightMultiple(LayoutConstants.labelLineHeightMultiple)
        
        nextButton.isEnabled = false
        nextButton.layer.borderColor = TDColor.Primary.primary500.cgColor
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    override func layout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.top.bottom.equalTo(scrollView.contentLayoutGuide)
            $0.leading.trailing.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        labelStack.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top).offset(LayoutConstants.topPadding)
            $0.leading.trailing.equalToSuperview().inset(LayoutConstants.horizontalPadding)
        }
        
        reasonStack.snp.makeConstraints {
            $0.top.equalTo(labelStack.snp.bottom).offset(LayoutConstants.reasonStackTopSpacing)
            $0.leading.trailing.equalToSuperview().inset(LayoutConstants.horizontalPadding)
        }
        
        spacerView.snp.makeConstraints {
            $0.top.equalTo(reasonStack.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(LayoutConstants.horizontalPadding)
            $0.height.equalTo(LayoutConstants.maxSpacerHeight)
        }
        
        nextButton.snp.makeConstraints {
            $0.top.equalTo(spacerView.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(LayoutConstants.horizontalPadding)
            $0.bottom.equalToSuperview().inset(LayoutConstants.bottomPadding)
            $0.height.equalTo(LayoutConstants.nextButtonSize)
        }
    }
}

private extension WithdrawReasonInputView {
    @objc
    func nextButtonTapped() {
        guard let selectedReason = reasonStack.arrangedSubviews.compactMap({ $0 as? TDCheckboxField }).first(where: { $0.checkbox.isSelected })?.reasonType else { return }
        self.selectedReason = selectedReason
        let reasonText = (reasonStack.arrangedSubviews.compactMap { $0 as? TDCheckboxField }).first(where: { $0.checkbox.isSelected })?.textView.text ?? ""
        delegate?.withdrawReasonInputViewDidTapNextButton(self, selectedReason: selectedReason, reasonText: reasonText)
    }
}

extension WithdrawReasonInputView: TDCheckboxFieldDelegate {
    func TDCheckboxFieldDelegateDidChange(_ field: TDCheckboxField, _ isSelected: Bool, type: WithdrawReasonType) {
        if isSelected {
            reasonStack.arrangedSubviews.forEach { subview in
                guard let subview = subview as? TDCheckboxField else { return }
                if subview.reasonType != field.reasonType {
                    subview.checkbox.isSelected = false
                    subview.handleCheckboxState(false)
                }
            }
            spacerView.snp.updateConstraints {
                $0.height.equalTo(LayoutConstants.minSpacerHeight)
            }
        } else {
            spacerView.snp.updateConstraints {
                $0.height.equalTo(LayoutConstants.maxSpacerHeight)
            }
        }
        nextButton.isEnabled = isSelected
    }
}

private extension WithdrawReasonInputView {
    enum LayoutConstants {
        static let topPadding: CGFloat = 18
        static let labelStackSpacing: CGFloat = 14
        static let horizontalPadding: CGFloat = 16
        static let nextButtonSize: CGFloat = 56
        static let bottomPadding: CGFloat = 28
        static let labelLineHeightMultiple: CGFloat = 1.2
        static let reasonStackInnerSpacing: CGFloat = 11
        static let reasonStackTopSpacing: CGFloat = 32
        static let minSpacerHeight: CGFloat = 83
        static let maxSpacerHeight: CGFloat = 213
    }
}
