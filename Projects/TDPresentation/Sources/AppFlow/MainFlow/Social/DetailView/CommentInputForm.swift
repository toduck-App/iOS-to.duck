import SnapKit
import TDDesign
import Then
import UIKit

final class CommentInputForm: UIView, UITextViewDelegate {
    let sendButton = UIButton().then {
        $0.setTitle("등록", for: .normal)
        $0.titleLabel?.font = TDFont.boldBody2.font
        $0.setTitleColor(TDColor.Neutral.neutral700, for: .normal)
        $0.setTitleColor(TDColor.Neutral.neutral400, for: .disabled)
        $0.isEnabled = false
    }
    
    private let imageButton = UIButton().then {
        $0.setImage(TDImage.imageMedium, for: .normal)
    }
    
    private let textView = UITextView().then {
        $0.font = TDFont.mediumBody3.font
        $0.textColor = TDColor.Neutral.neutral800
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 12
        $0.isScrollEnabled = false
        $0.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        $0.showsVerticalScrollIndicator = false
    }
    
    private let placeholderLabel = UILabel().then {
        $0.text = "댓글을 남겨주세요."
        $0.font = TDFont.mediumBody3.font
        $0.textColor = TDColor.Neutral.neutral400
    }
    
    private var textViewHeightConstraint: Constraint?
    
    private var minHeight: CGFloat {
        return TDFont.mediumBody3.font.lineHeight + textView.textContainerInset.top + textView.textContainerInset.bottom
    }
    
    private var maxHeight: CGFloat {
        return 3 * TDFont.mediumBody3.font.lineHeight + textView.textContainerInset.top + textView.textContainerInset.bottom
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = TDColor.baseWhite
        
        addSubview(imageButton)
        addSubview(textView)
        addSubview(sendButton)
        textView.addSubview(placeholderLabel)
        
        textView.delegate = self
        
        imageButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(20)
            make.size.equalTo(24)
        }
        
        sendButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalTo(imageButton)
            make.height.equalTo(24)
            make.width.equalTo(32)
        }
        
        textView.snp.makeConstraints { make in
            make.leading.equalTo(imageButton.snp.trailing).offset(16)
            make.trailing.equalTo(sendButton.snp.leading).offset(-20)
            make.top.equalTo(imageButton)
            self.textViewHeightConstraint = make.height.equalTo(minHeight).constraint
        }
        
        placeholderLabel.snp.makeConstraints { make in
            make.top.equalTo(textView.textContainerInset.top)
            make.leading.equalTo(textView.textContainerInset.left + 2)
            make.trailing.lessThanOrEqualToSuperview().offset(-textView.textContainerInset.right)
        }
        
        self.snp.makeConstraints { make in
            make.bottom.equalTo(textView).offset(textView.textContainerInset.bottom)
        }
    }
    
    // MARK: - UITextViewDelegate
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
        if textView.text.isEmpty {
            sendButton.isEnabled = false
        } else {
            sendButton.isEnabled = true
        }
        
        
        let fittingSize = textView.sizeThatFits(CGSize(width: textView.frame.width, height: CGFloat.greatestFiniteMagnitude))
        if fittingSize.height <= maxHeight {
            textViewHeightConstraint?.update(offset: fittingSize.height)
            textView.isScrollEnabled = false
        } else {
            textViewHeightConstraint?.update(offset: maxHeight)
            textView.isScrollEnabled = true
            let range = NSRange(location: textView.text.count - 1, length: 1)
            textView.scrollRangeToVisible(range)
        }
        self.layoutIfNeeded()
    }
    
    // MARK: - Public Methods
    
    public func setTapSendButton(_ action: UIAction) {
        sendButton.addAction(action, for: .touchUpInside)
    }
    
    public func setTapImageButton(_ action: UIAction) {
        imageButton.addAction(action, for: .touchUpInside)
    }
    
    public func getText() -> String? {
        return textView.text
    }
    
    public func clearText() {
        textView.text = ""
        textViewDidChange(textView)
    }
}
