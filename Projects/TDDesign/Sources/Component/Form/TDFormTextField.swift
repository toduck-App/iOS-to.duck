import SnapKit
import Then
import UIKit

/// `TDFormTextField` 내부의 텍스트가 변경되거나 편집이 시작/끝났을 때
/// 필요한 정보를 외부로 전달해주는 Delegate 프로토콜
public protocol TDFormTextFieldDelegate: AnyObject {
    /// 텍스트가 변경되었을 때 호출되는 메서드
    /// - Parameters:
    ///   - textField: 호출한 TextField
    ///   - text: 현재 입력된 텍스트
    func tdTextField(_ textField: TDFormTextField, didChangeText text: String)
    
    /// 편집이 시작되었을 때 호출되는 메서드
    /// - Parameter textField: 호출한 TextField
    func tdTextFieldDidBeginEditing(_ textField: TDFormTextField)
    
    /// 편집이 끝났을 때 호출되는 메서드
    /// - Parameter textField: 호출한 TextField
    func tdTextFieldDidEndEditing(_ textField: TDFormTextField)
}

public extension TDFormTextFieldDelegate {
    func tdTextFieldDidBeginEditing(_ textField: TDFormTextField) {}
    func tdTextFieldDidEndEditing(_ textField: TDFormTextField) {}
}

/// 여러 속성을 가진 싱글 라인 TextField 컴포넌트
/// - title: 상단에 들어가는 제목
/// - isRequired: 필수 항목 여부
/// - maxCharacter: 최대 글자수
/// - placeholder: TextField가 비어있을 때 표시할 문구
public final class TDFormTextField: UIView {
    // MARK: - Properties

    /// Delegate
    public weak var delegate: TDFormTextFieldDelegate?
    
    private let maxCharacter: Int

    // MARK: - UI Properties
    
    private let titleHorizontalStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
    }
    private let titleImageView = UIImageView()
    private let titleLabel = TDRequiredTitle()
    private let currentCounterLabel = TDLabel(toduckFont: .regularBody2, toduckColor: TDColor.Neutral.neutral800)
    private let maxCounterLabel = TDLabel(toduckFont: .regularBody2, toduckColor: TDColor.Neutral.neutral600)
    
    private let textField: TDTextField

    // MARK: - Initializers

    public init(
        image: UIImage? = nil,
        title: String,
        isRequired: Bool,
        maxCharacter: Int,
        placeholder: String
    ) {
        self.titleImageView.image = image
        self.maxCharacter = maxCharacter
        self.textField = TDTextField(placeholder: placeholder, labelText: "")
        super.init(frame: .zero)
        
        // Title 설정
        titleImageView.contentMode = .scaleAspectFit
        titleLabel.setTitleLabel(title)
        
        // 필수 항목 표시
        if isRequired {
            titleLabel.setRequiredLabel()
        }
        
        // 카운터 초기화
        currentCounterLabel.setText("0")
        maxCounterLabel.setText("/ \(maxCharacter)")
        
        setupLayout()
        setupDelegate()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout

extension TDFormTextField {
    private func setupLayout() {
        addSubview(titleHorizontalStackView)
        if titleImageView.image != nil {
            titleHorizontalStackView.addArrangedSubview(titleImageView)
        }
        titleHorizontalStackView.addArrangedSubview(titleLabel)
        addSubview(textField)
        addSubview(currentCounterLabel)
        addSubview(maxCounterLabel)
        
        titleHorizontalStackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
        }
        
        maxCounterLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalTo(titleLabel)
        }
        
        currentCounterLabel.snp.makeConstraints { make in
            make.trailing.equalTo(maxCounterLabel.snp.leading).offset(-4)
            make.centerY.equalTo(maxCounterLabel)
        }
    }
    
    private func setupDelegate() {
        textField.setTextFieldDelegate(self)
        
        if let textFieldCore = textField.getCoreTextField() {
            textFieldCore.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
        }
    }
}

// MARK: - UITextFieldDelegate

extension TDFormTextField: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ uiTextField: UITextField) {
        delegate?.tdTextFieldDidBeginEditing(self)
    }

    public func textFieldDidEndEditing(_ uiTextField: UITextField) {
        delegate?.tdTextFieldDidEndEditing(self)
    }
    
    @objc
    private func textDidChange(_ uiTextField: UITextField) {
        guard let text = uiTextField.text else { return }
        
        // 최대 글자수 초과 방지
        if text.count > maxCharacter {
            let trimmedText = String(text.prefix(maxCharacter))
            uiTextField.text = trimmedText
        }
        
        // 현재 글자수 표시
        currentCounterLabel.setText("\(uiTextField.text?.count ?? 0)")
        
        // Delegate 호출: 현재 입력된 텍스트 전달
        delegate?.tdTextField(self, didChangeText: uiTextField.text ?? "")
    }
}
