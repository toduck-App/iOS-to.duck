import SnapKit
import TDDesign
import Then
import UIKit

final class SocialTextFieldView: UIView {
    private let title = TDRequiredTitle()
    private let currentCounterLabel = TDLabel(toduckFont: .regularBody2, toduckColor: TDColor.Neutral.neutral800)
    private let maxCounterLabel = TDLabel(toduckFont: .regularBody2, toduckColor: TDColor.Neutral.neutral600)
    
    private lazy var textView = UITextView().then {
        $0.layer.cornerRadius = 8
        $0.layer.borderColor = TDColor.Neutral.neutral300.cgColor
        $0.layer.borderWidth = 1
        $0.textColor = TDColor.Neutral.neutral800
        $0.font = TDFont.regularBody2.font
        $0.isScrollEnabled = true
        $0.textContainerInset = UIEdgeInsets(top: 14, left: 12, bottom: 14, right: 12)
        $0.delegate = self
        $0.backgroundColor = TDColor.baseWhite
    }
    
    private let placeholderLabel = TDLabel(toduckFont: .regularBody2, toduckColor: TDColor.Neutral.neutral500).then {
        $0.setText("자유롭게 내용을 입력해주세요")
    }
    
    private let maxCharacter: Int
    
    init(title: String, isRequired: Bool, maxCharacter: Int) {
        self.maxCharacter = maxCharacter
        super.init(frame: .zero)
        
        self.title.setTitleLabel(title)
        if isRequired {
            self.title.setRequiredLabel()
        }
        
        maxCounterLabel.setText("/ \(maxCharacter)")
        currentCounterLabel.setText("0")
        
        setLayout()
    }
    
    override init(frame: CGRect) {
        self.maxCharacter = 0
        super.init(frame: frame)
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SocialTextFieldView {
    private func setLayout() {
        addSubviews()
        setConstraints()
    }
    
    private func addSubviews() {
        addSubview(title)
        addSubview(textView)
        addSubview(currentCounterLabel)
        addSubview(maxCounterLabel)
        
        textView.addSubview(placeholderLabel)
    }
    
    private func setConstraints() {
        title.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(112)
        }
        
        maxCounterLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalTo(title)
        }
        
        currentCounterLabel.snp.makeConstraints { make in
            make.trailing.equalTo(maxCounterLabel.snp.leading).offset(-4)
            make.centerY.equalTo(maxCounterLabel)
        }
        
        placeholderLabel.snp.makeConstraints { make in
            make.top.equalTo(textView.textContainerInset.top).offset(14)
            make.leading.equalTo(textView).offset(16)
            make.trailing.equalTo(textView).offset(-12)
        }
    }
}

extension SocialTextFieldView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let text = textView.text ?? ""
        
        if text.count > maxCharacter {
            let trimmedText = String(text.prefix(maxCharacter))
            textView.text = trimmedText
        }
        
        currentCounterLabel.setText("\(textView.text.count)")
        placeholderLabel.isHidden = !textView.text.isEmpty ? true : false
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}
