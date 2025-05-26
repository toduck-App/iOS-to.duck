//
//  TDCheckboxField.swift
//  TDPresentation
//
//  Created by 정지용 on 2/17/25.
//

import UIKit
import SnapKit
import TDDomain
import TDDesign

protocol TDCheckboxFieldDelegate: AnyObject {
    func TDCheckboxFieldDelegateDidChange(_ field: TDCheckboxField, _ isSelected: Bool, type: WithdrawReasonType)
}

final class TDCheckboxField: BaseView {
    weak var delegate: TDCheckboxFieldDelegate?
    private let maxCharacter = Constants.maxCharacterCount
    private var textViewHeightConstraint: Constraint?
    
    private let checkboxContainer = UIView()
    private let checkboxLabel = TDLabel(toduckFont: .mediumBody1)
    private let placeholderLabel = TDLabel(toduckFont: .mediumBody3, toduckColor: TDColor.Neutral.neutral500)
    
    let reasonType: WithdrawReasonType
    let checkbox = TDCheckbox(
        backgroundColor: TDColor.Primary.primary500,
        foregroundColor: TDColor.baseWhite
    )
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.layer.cornerRadius = LayoutConstants.textViewCornerRadius
        textView.layer.borderColor = TDColor.Neutral.neutral300.cgColor
        textView.layer.borderWidth = LayoutConstants.textViewBorderWidth
        textView.textColor = TDColor.Neutral.neutral800
        textView.font = TDFont.regularBody4.font
        textView.isScrollEnabled = true
        textView.textContainerInset = UIEdgeInsets(
            top: LayoutConstants.textViewVerticalInset,
            left: LayoutConstants.textViewHorizontalInset,
            bottom: LayoutConstants.textViewVerticalInset,
            right: LayoutConstants.textViewHorizontalInset
        )
        textView.backgroundColor = TDColor.Neutral.neutral50
        textView.isHidden = true
        return textView
    }()
    
    init(type: WithdrawReasonType) {
        self.reasonType = type
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addview() {
        [checkbox, checkboxLabel].forEach { checkboxContainer.addSubview($0) }
        textView.addSubview(placeholderLabel)
        [checkboxContainer, textView].forEach(addSubview)
    }
    
    override func configure() {
        textView.delegate = self
        placeholderLabel.numberOfLines = 0
        placeholderLabel.lineBreakMode = .byWordWrapping
        checkbox.onToggle = { [weak self] isSelected in
            guard let self else { return }
            self.handleCheckboxState(isSelected)
            self.delegate?.TDCheckboxFieldDelegateDidChange(self, isSelected, type: self.reasonType)
        }
    }
    
    override func layout() {
        checkboxContainer.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview()
            $0.height.equalTo(LayoutConstants.checkboxContainerHeight)
        }
        
        checkbox.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        checkboxLabel.snp.makeConstraints {
            $0.leading.equalTo(checkbox.snp.trailing)
                .offset(LayoutConstants.checkboxLabelOffset)
            $0.centerY.equalToSuperview()
        }
        
        textView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(checkboxContainer.snp.bottom)
                .offset(LayoutConstants.textViewOffset)
            textViewHeightConstraint = $0.height.equalTo(0).constraint
            $0.bottom.equalToSuperview()
        }
        
        placeholderLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
                .inset(LayoutConstants.textViewVerticalInset)
            $0.leading.trailing.equalToSuperview()
                .inset(LayoutConstants.textViewVerticalInset)
        }
    }
    
    func handleCheckboxState(_ isSelected: Bool) {
        textView.isHidden = !isSelected
        textViewHeightConstraint?.update(offset: isSelected ? LayoutConstants.textViewHeight : 0)
        if !isSelected {
            textView.text = nil
            placeholderLabel.isHidden = false
        }
        invalidateIntrinsicContentSize()
    }
}

extension TDCheckboxField: UITextViewDelegate {
    public func textViewDidChange(_ textView: UITextView) {
        let text = textView.text ?? ""
        
        if text.count > maxCharacter {
            let trimmedText = String(text.prefix(maxCharacter))
            textView.text = trimmedText
        }
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}

private extension TDCheckboxField {
    func setupView() {
        checkboxLabel.setText(reasonType.description)
        placeholderLabel.setText(reasonType.placeholder)
    }
}

private extension TDCheckboxField {
    enum Constants {
        static let maxCharacterCount: Int = 300
    }
    
    enum LayoutConstants {
        static let textViewOffset: CGFloat = 11
        static let textViewHeight: CGFloat = 130
        static let textViewCornerRadius: CGFloat = 8
        static let textViewBorderWidth: CGFloat = 1
        static let textViewHorizontalInset: CGFloat = 12
        static let textViewVerticalInset: CGFloat = 14
        static let checkboxContainerHeight: CGFloat = 42
        static let checkboxLabelOffset: CGFloat = 10
    }
}
