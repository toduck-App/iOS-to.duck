import SnapKit
import UIKit

public final class TDTextField: UIView {
    private var textField: TDTextFieldCore
    private var placeholder: String
    private var labelText: String

    private var errorStack = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
        $0.alignment = .leading
    }

    private var topLabel: TDLabel?

    public var error: String {
        didSet {
            textField.error = hasError
            if hasError {
                if let errorLabel = errorStack.arrangedSubviews.first(where: { $0 is TDLabel }) as? TDLabel {
                    errorStack.removeArrangedSubview(errorLabel)
                    errorLabel.removeFromSuperview()
                }
                let errorLabel = TDLabel(labelText: error, toduckFont: .mediumBody2, toduckColor: TDColor.Semantic.error)
                errorStack.addArrangedSubview(errorLabel)
                topLabel?.setColor(TDColor.Semantic.error)
            } else {
                if let errorLabel = errorStack.arrangedSubviews.first(where: { $0 is TDLabel }) as? TDLabel {
                    errorStack.removeArrangedSubview(errorLabel)
                    errorLabel.removeFromSuperview()
                }
                topLabel?.setColor(TDColor.Neutral.neutral800) // 기본 색상으로 변경
            }
            updateLayout() // 레이아웃 업데이트
        }
    }

    private var hasError: Bool {
        !(error == "")
    }

    private var existLabel: Bool {
        !(labelText == "")
    }

    // MARK: - Initialize

    public init(
        frame: CGRect = .zero,
        placeholder: String = "",
        labelText: String = ""
    ) {
        self.placeholder = placeholder
        self.labelText = labelText
        error = ""
        textField = TDTextFieldCore(placeholder: placeholder)
        super.init(frame: frame)

        setupViews()
        updateLayout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setupTextField(_ text: String) {
        textField.text = text
    }
    
    public func setupPlaceholder(_ placeholder: String) {
        textField.placeholder = placeholder
    }
    
    public func setupFont(_ font: TDFont) {
        textField.font = font.font
    }

    private func setupViews() {
        textField.font = TDFont.mediumBody2.font
        textField.textColor = TDColor.Neutral.neutral800
        let mainStack = UIStackView()
        mainStack.axis = .vertical
        mainStack.spacing = 16
        mainStack.alignment = .leading
        addSubview(mainStack)

        if existLabel {
            let label = TDLabel(labelText: labelText, toduckFont: .mediumHeader5)
            topLabel = label
            mainStack.addArrangedSubview(label)
        }

        mainStack.addArrangedSubview(textField)
        mainStack.addArrangedSubview(errorStack)

        mainStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        textField.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
    }

    private func updateLayout() {
        if hasError {
            errorStack.isHidden = false
        } else {
            errorStack.isHidden = true
        }

        layoutIfNeeded()
    }

    private var labelStack = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10
        $0.alignment = .leading
    }

    func layout() {
        textField.snp.makeConstraints {
            $0.width.equalToSuperview()
        }

        if hasError {
            errorStack.snp.updateConstraints {
                $0.width.equalToSuperview()
            }
            snp.updateConstraints {
                $0.height.equalTo(80)
            }
        } else {
            snp.updateConstraints {
                $0.height.equalTo(48)
            }
        }
    }
}

private final class TDTextFieldCore: UITextField, UITextFieldDelegate {
    public var error: Bool {
        didSet {
            layer.borderColor = error ? TDColor.Semantic.error.cgColor : TDColor.Neutral.neutral300.cgColor
        }
    }

    public convenience init(frame: CGRect = .zero, placeholder: String = "") {
        self.init(frame: frame)
        delegate = self

        self.placeholder = placeholder
        setupTextField()
        layout()
    }

    override init(frame: CGRect) {
        error = false
        super.init(frame: frame)
        placeholder = ""
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupTextField() {
        borderStyle = .none
        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = TDColor.Neutral.neutral300.cgColor
        backgroundColor = TDColor.Neutral.neutral50
        font = TDFont.regularBody4.font
        clearButtonMode = .whileEditing

        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: frame.height))
        leftView = paddingView
        leftViewMode = .always

        attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: TDColor.Neutral.neutral500])
    }

    private func layout() {
        snp.updateConstraints {
            $0.height.equalTo(48)
        }
    }

    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16))
    }

    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 48))
    }

    override public func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        let buttonWidth: CGFloat = 24
        let buttonHeight: CGFloat = 24
        let xPosition = bounds.width - buttonWidth - 16
        let yPosition = (bounds.height - buttonHeight) / 2
        return CGRect(x: xPosition, y: yPosition, width: buttonWidth, height: buttonHeight)
    }

    public func textFieldDidBeginEditing(_: UITextField) {
        layer.borderColor = error ? TDColor.Semantic.error.cgColor : TDColor.Neutral.neutral800.cgColor
    }

    public func textFieldDidEndEditing(_: UITextField) {
        layer.borderColor = error ? TDColor.Semantic.error.cgColor : TDColor.Neutral.neutral300.cgColor
    }
}

extension TDTextField {
    /// 내부의 `TDTextFieldCore`(UITextField) 인스턴스 delegate를 변경하는 메서드
    public func setTextFieldDelegate(_ delegate: UITextFieldDelegate) {
        // textField는 private var textField: TDTextFieldCore 형태이므로
        // setter 메서드를 통해 교체
        textField.delegate = delegate
    }
    
    /// 내부 `TDTextFieldCore`를 직접 반환하는 메서드 (optional)
    /// 필요하다면 사용, 안전하지 않다고 생각되면 사용 안 해도 됨
    public func getCoreTextField() -> UITextField? {
        return textField
    }
}
