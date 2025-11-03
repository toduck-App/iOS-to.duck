import Kingfisher
import SnapKit
import TDDesign
import Then
import UIKit

protocol SocialEventJoinViewDelegate: AnyObject {
    func eventSheetDidTapJoin(_ view: SocialEventJoinView, phoneNumber: String)
}

final class SocialEventJoinView: BaseView {
    // MARK: - Public
    weak var delegate: SocialEventJoinViewDelegate?

    // MARK: - UI Components
    private let vStack = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 16
        $0.alignment = .fill
        $0.distribution = .fill
        $0.isLayoutMarginsRelativeArrangement = true
    }

    private let titleVStack = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 12
        $0.alignment = .fill
        $0.distribution = .fill
        $0.isLayoutMarginsRelativeArrangement = true
    }

    private let titleHStack = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .center
        $0.distribution = .fillProportionally
        $0.isLayoutMarginsRelativeArrangement = true
    }

    private let titleIcon = UIImageView().then {
        $0.image = TDImage.Direction.curvedArrowMedium
        $0.contentMode = .scaleAspectFit
        $0.setContentHuggingPriority(.required, for: .horizontal)
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
    }

    private let titleLabel = TDLabel(
        labelText: "경험담 작성 이벤트에 참여하시겠어요?",
        toduckFont: .boldHeader4,
        toduckColor: TDColor.Neutral.neutral800
    )

    private let descriptionVStack = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
        $0.alignment = .leading
        $0.distribution = .fillProportionally
    }

    private let descriptionLabel = TDLabel(
        toduckFont: .regularBody2,
        toduckColor: TDColor.Neutral.neutral600
    ).then {
        $0.setText("ㆍ 추첨을 통해 5명에게 배달의 민족 1만원권 상품권을 드려요")
        $0.numberOfLines = 0
    }

    private let descriptionLabel2 = TDLabel(
        toduckFont: .regularBody2,
        toduckColor: TDColor.Neutral.neutral600
    ).then {
        $0.setText("ㆍ 개인정보는 경품 발송에만 이용되며, 발송 이후 즉시 파기돼요")
        $0.numberOfLines = 0
    }

    private let phoneNumberTitleLabel = TDLabel(
        toduckFont: .mediumBody1,
        toduckColor: TDColor.Neutral.neutral800
    ).then {
        $0.setText("휴대폰 번호")
    }

    private let phoneNumberContainerView = UIView().then {
        $0.layer.cornerRadius = 8
        $0.backgroundColor = TDColor.Neutral.neutral50
        $0.layer.borderWidth = 1
        $0.layer.borderColor = TDColor.Neutral.neutral300.cgColor
        $0.isAccessibilityElement = true
        $0.accessibilityLabel = "휴대폰 번호 입력"
    }

    private let phoneNumberTextField = UITextField().then {
        $0.font = TDFont.mediumHeader3.font
        $0.textColor = TDColor.Neutral.neutral800
        $0.backgroundColor = TDColor.Neutral.neutral50
        $0.keyboardType = .numberPad
        $0.adjustsFontSizeToFitWidth = true
        $0.minimumFontSize = 10
        $0.clearButtonMode = .whileEditing
        $0.accessibilityTraits.insert(.updatesFrequently)
        let placeholderText = "- 없이 휴대전화 번호 입력"
        let placeholderColor = TDColor.Neutral.neutral500
        let placeholderFont = TDFont.mediumHeader3.font

        $0.attributedPlaceholder = NSAttributedString(
            string: placeholderText,
            attributes: [
                .foregroundColor: placeholderColor,
                .font: placeholderFont
            ]
        )
    }

    private let errorLabel = TDLabel(
        labelText: "휴대폰 번호 형식이 잘못되었습니다.",
        toduckFont: .regularCaption1,
        toduckColor: TDColor.Semantic.error
    ).then {
        $0.isHidden = true
        $0.numberOfLines = 0
    }

    private var checkBoxHStack = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .center
        $0.distribution = .fillProportionally
    }

    private let checkBoxButton = TDCheckbox(
        backgroundColor: TDColor.Primary.primary50,
        foregroundColor: TDColor.Primary.primary500
    )

    private let checkBoxLabel = TDLabel(
        labelText: "개인정보 수집/이용 동의 (필수)",
        toduckFont: .mediumBody2,
        toduckColor: TDColor.Neutral.neutral600
    )

    lazy var joinButton = TDBaseButton(
        title: "참여하기",
        backgroundColor: TDColor.Primary.primary500,
        foregroundColor: TDColor.baseWhite,
        font: TDFont.boldHeader3.font,
        radius: 12
    ).then {
        $0.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            delegate?.eventSheetDidTapJoin(self, phoneNumber: phoneNumberTextField.text ?? "")
        }, for: .touchUpInside)
    }

    // MARK: - State
    private var isPhoneValid: Bool = false {
        didSet { applyValidationUI() }
    }
    private var isConsentOn: Bool = false {
        didSet { updateJoinButtonState() }
    }

    // MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - BaseView Hooks
    override func configure() {
        joinButton.isEnabled = false

        checkBoxButton.onToggle = { [weak self] isOn in
            self?.isConsentOn = isOn
        }

        phoneNumberTextField.addTarget(self, action: #selector(onPhoneEditingChanged), for: .editingChanged)

        phoneNumberTextField.addTarget(self, action: #selector(onPhoneEditingDidEnd), for: .editingDidEnd)
    }

    override func addview() {
        addSubview(vStack)

        vStack.addArrangedSubview(titleVStack)
        titleVStack.addArrangedSubview(titleHStack)
        titleHStack.addArrangedSubview(titleIcon)
        titleHStack.addArrangedSubview(titleLabel)

        titleVStack.addArrangedSubview(descriptionVStack)
        [descriptionLabel, descriptionLabel2].forEach { descriptionVStack.addArrangedSubview($0) }

        vStack.addArrangedSubview(phoneNumberTitleLabel)

        phoneNumberContainerView.addSubview(phoneNumberTextField)
        vStack.addArrangedSubview(phoneNumberContainerView)

        vStack.addArrangedSubview(errorLabel)

        [checkBoxButton, checkBoxLabel].forEach { checkBoxHStack.addArrangedSubview($0) }
        vStack.addArrangedSubview(checkBoxHStack)

        vStack.addArrangedSubview(joinButton)
    }

    override func layout() {
        vStack.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(28)
            make.horizontalEdges.equalToSuperview().inset(18)
        }

        titleVStack.snp.makeConstraints { make in
            make.height.equalTo(88)
        }

        [descriptionLabel, descriptionLabel2].forEach {
            $0.snp.makeConstraints { make in
                make.height.equalTo(20)
            }
        }

        phoneNumberContainerView.snp.makeConstraints { make in
            make.height.equalTo(56)
        }

        phoneNumberTextField.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(0)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        errorLabel.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(16)
        }

        checkBoxHStack.snp.makeConstraints { make in
            make.height.equalTo(62)
        }
    }

    // MARK: - Validation
    private func isValidPhoneNumber(with phoneNumber: String) -> Bool {
        let phoneRegex = #"^010[0-9]{8}$"#
        return phoneNumber.range(of: phoneRegex, options: .regularExpression) != nil
    }

    @objc private func onPhoneEditingChanged() {
        let raw = phoneNumberTextField.text ?? ""
        isPhoneValid = isValidPhoneNumber(with: raw)
        updateJoinButtonState()
    }

    @objc private func onPhoneEditingDidEnd() {
        let raw = phoneNumberTextField.text ?? ""
        isPhoneValid = isValidPhoneNumber(with: raw)
        updateJoinButtonState()
    }

    private func updateJoinButtonState() {
        joinButton.isEnabled = (isConsentOn && isPhoneValid)
    }

    private func applyValidationUI() {
        if isPhoneValid {
            phoneNumberContainerView.layer.borderColor = TDColor.Neutral.neutral300.cgColor
            errorLabel.isHidden = true
        } else {
            phoneNumberContainerView.layer.borderColor = TDColor.Semantic.error.cgColor
            errorLabel.isHidden = false
        }
    }
}
