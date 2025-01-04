import SnapKit
import Then
import UIKit

/// `TDTextView` 내부의 텍스트가 변경되거나 편집이 시작/끝났을 때
/// 필요한 정보를 외부로 전달해주는 Delegate 프로토콜
public protocol TDFormTextViewDelegate: AnyObject {
    /// 텍스트가 변경되었을 때 호출되는 메서드
    /// - Parameters:
    ///   - textView: 호출한 TextView
    ///   - text: 현재 입력된 텍스트
    func tdTextView(_ textView: TDFormTextView, didChangeText text: String)
    
    /// 편집이 시작되었을 때 호출되는 메서드
    /// - Parameter textView: 호출한 TextView
    func tdTextViewDidBeginEditing(_ textView: TDFormTextView)
    
    /// 편집이 끝났을 때 호출되는 메서드
    /// - Parameter textView: 호출한 TextView
    func tdTextViewDidEndEditing(_ textView: TDFormTextView)
}

public extension TDFormTextViewDelegate {
    func tdTextViewDidBeginEditing(_ textView: TDFormTextView) {}
    func tdTextViewDidEndEditing(_ textView: TDFormTextView) {}
}

/// 여러 줄을 입력할 수 있는 TextView 컴포넌트
/// - title: 상단에 들어가는 제목
/// - isRequired: 필수 항목 여부
/// - maxCharacter: 최대 글자수
/// - placeholder: TextView가 비어있을 때 표시할 문구
public final class TDFormTextView: UIView {
    // MARK: - Properties

    /// Delegate
    public weak var delegate: TDFormTextViewDelegate?
    
    private let maxCharacter: Int
    
    // MARK: - UI Properties

    private let titleLabel = TDRequiredTitle()
    private let currentCounterLabel = TDLabel(toduckFont: .regularBody2, toduckColor: TDColor.Neutral.neutral800)
    private let maxCounterLabel = TDLabel(toduckFont: .regularBody2, toduckColor: TDColor.Neutral.neutral600)
    
    private lazy var textView = UITextView().then {
        $0.layer.cornerRadius = 8
        $0.layer.borderColor = TDColor.Neutral.neutral300.cgColor
        $0.layer.borderWidth = 1
        $0.textColor = TDColor.Neutral.neutral800
        $0.font = TDFont.mediumBody2.font
        $0.isScrollEnabled = true
        $0.textContainerInset = UIEdgeInsets(top: 14, left: 12, bottom: 14, right: 12)
        $0.delegate = self
        $0.backgroundColor = TDColor.baseWhite
    }
    
    private let placeholderLabel = TDLabel(toduckFont: .regularBody2, toduckColor: TDColor.Neutral.neutral500)
    
    // MARK: - Initializers

    public init(title: String,
                isRequired: Bool,
                maxCharacter: Int,
                placeholder: String)
    {
        self.maxCharacter = maxCharacter
        super.init(frame: .zero)
        
        // Title 설정
        titleLabel.setTitleLabel(title)
        
        // 필수 항목 표시
        if isRequired {
            titleLabel.setRequiredLabel()
        }
        
        // 카운터 초기화
        currentCounterLabel.setText("0")
        maxCounterLabel.setText("/ \(maxCharacter)")
        
        // placeholder 설정
        placeholderLabel.setText(placeholder)
        
        setupLayout()
    }
    
    /// Storyboard나 XIB 사용 시 필요한 생성자. 여기서는 사용하지 않음.
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout

extension TDFormTextView {
    private func setupLayout() {
        addSubviews()
        setConstraints()
    }
    
    private func addSubviews() {
        addSubview(titleLabel)
        addSubview(textView)
        addSubview(currentCounterLabel)
        addSubview(maxCounterLabel)
        textView.addSubview(placeholderLabel)
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(112)
        }
        
        maxCounterLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalTo(titleLabel)
        }
        
        currentCounterLabel.snp.makeConstraints { make in
            make.trailing.equalTo(maxCounterLabel.snp.leading).offset(-4)
            make.centerY.equalTo(maxCounterLabel)
        }
        
        placeholderLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-12)
        }
    }
}

// MARK: - UITextViewDelegate

extension TDFormTextView: UITextViewDelegate {
    public func textViewDidChange(_ textView: UITextView) {
        let text = textView.text ?? ""
        
        // 최대 글자수 초과 방지
        if text.count > maxCharacter {
            let trimmedText = String(text.prefix(maxCharacter))
            textView.text = trimmedText
        }
        
        // 현재 글자수 표시
        currentCounterLabel.setText("\(textView.text.count)")
        
        // placeholder 표시 여부
        placeholderLabel.isHidden = !textView.text.isEmpty
        
        // Delegate 호출: 현재 입력된 텍스트 전달
        delegate?.tdTextView(self, didChangeText: textView.text)
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
        delegate?.tdTextViewDidBeginEditing(self)
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
        delegate?.tdTextViewDidEndEditing(self)
    }
}
