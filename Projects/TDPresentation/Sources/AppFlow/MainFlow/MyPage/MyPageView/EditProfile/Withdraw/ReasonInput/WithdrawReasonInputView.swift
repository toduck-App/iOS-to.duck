//
//  WithdrawReasonInputView.swift
//  TDPresentation
//
//  Created by 정지용 on 1/29/25.
//

import UIKit

import TDDesign

protocol WithdrawReasonInputViewDelegate: AnyObject {
    func withdrawReasonInputViewDidTapNextButton(_ withdrawReasonInputView: WithdrawReasonInputView)
}

enum ReasonType {
    case hardToUse
    case missingFeatures
    case frequentErrors
    case foundBetterApp
    case rejoinWithNewAccount
    case other
    
    var description: String {
        switch self {
        case .hardToUse:
            return "사용 방법이 어려워요"
        case .missingFeatures:
            return "원하는 기능이 없어요"
        case .frequentErrors:
            return "오류가 자주 발생해요"
        case .foundBetterApp:
            return "더 좋은 어플이 있어요"
        case .rejoinWithNewAccount:
            return "다른 계정으로 다시 가입하고 싶어요"
        case .other:
            return "기타"
        }
    }
    
    var placeholder: String {
        switch self {
        case .hardToUse:
            return """
            토덕 어플 사용 중 어떤 어려움을 겪으셨는지 알려주세요. 
            토덕은 언제나 여러분의 의견을 기다립니다. (130자 제한)
            """
        case .missingFeatures:
            return """
            토덕 어플에 추가되었으면 하는 기능을 자유롭게 이야기 해 주세요.
            토덕은 언제나 여러분의 의견을 기다립니다. (130자 제한)
            """
        case .frequentErrors:
            return """
            토덕 어플 사용 중 어떤 어려움을 겪으셨는지 알려주세요. 
            토덕은 언제나 여러분의 의견을 기다립니다. (130자 제한)
            """
        case .foundBetterApp:
            return """
            토덕 어플보다 더 좋은 기능을 가진 어플이 있다면 알려주세요. 
            토덕은 언제나 여러분의 의견을 기다립니다. (130자 제한)
            """
        case .rejoinWithNewAccount:
            return """
            다른 계정으로 재가입을 원하시는 이유를 알려주세요. 
            토덕은 언제나 여러분의 의견을 기다립니다. (130자 제한)
            """
        case .other:
            return """
            토덕의 발전을 위해 아쉬운 점이 있다면, 편하게 작성해주세요. 
            토덕은 언제나 여러분의 의견을 기다립니다. (130자 제한)
            """
        }
    }
}

final class WithdrawReasonInputView: BaseView {
    weak var delegate: WithdrawReasonInputViewDelegate?
    private var selectedReason: ReasonType?
    
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
            TDCheckboxField(type: ReasonType.hardToUse),
            TDCheckboxField(type: ReasonType.missingFeatures),
            TDCheckboxField(type: ReasonType.frequentErrors),
            TDCheckboxField(type: ReasonType.foundBetterApp),
            TDCheckboxField(type: ReasonType.rejoinWithNewAccount),
            TDCheckboxField(type: ReasonType.other)
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
        delegate?.withdrawReasonInputViewDidTapNextButton(self)
    }
}

extension WithdrawReasonInputView: TDCheckboxFieldDelegate {
    func TDCheckboxFieldDelegateDidChange(_ field: TDCheckboxField, _ isSelected: Bool, type: ReasonType) {
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
