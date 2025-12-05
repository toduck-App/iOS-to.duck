import TDCore
import TDDesign
import TDDomain
import UIKit
import Then
import SnapKit

final class CreateKeywordPopupViewController: TDPopupViewController<CreateKeywordView>, TDDropDownDelegate, UITextFieldDelegate {
    var onCreateHandler: (() -> Void)?
    
    func dropDown(_ dropDownView: TDDesign.TDDropdownHoverView, didSelectRowAt indexPath: IndexPath) {
        self.selectedCategory = keywordCategorys[indexPath.row]
        popupContentView.keywordDropDownView.setTitle(selectedCategory.title)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 20
        let currentString: NSString = (textField.text ?? "") as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        if newString.length >= 1 {
            popupContentView.saveButton.isEnabled = true
        }
        return newString.length <= maxLength
    }
    
    
    let keywordCategorys = UserKeywordCategory.allCases
    var selectedCategory = UserKeywordCategory.allCases[0]
    
    override func configure() {
        super.configure()
        popupContentView.keywordDropDownView.setTitle(selectedCategory.title)
        popupContentView.dropDownHoverView.dataSource = keywordCategorys.map { TDDropdownItem(title: $0.title) }
        popupContentView.dropDownHoverView.delegate = self
        popupContentView.saveButton.isEnabled = false
        popupContentView.textField.delegate = self
        
        
        popupContentView.cancelButton.addAction(UIAction { [weak self] _ in
            self?.dismissPopup()
        }, for: .touchUpInside)
        popupContentView.saveButton.addAction(UIAction { [weak self] _ in
            guard let self, let keyword = popupContentView.textField.text else { return }
            let usecase = DIContainer.shared.resolve(CreateDiaryKeywordUseCase.self)
            self.popupContentView.saveButton.isEnabled = false
            Task {
                do {
                    try await usecase.execute(name: keyword, category: self.selectedCategory)
                    self.onCreateHandler?()
                    self.dismissPopup()
                } catch {
                    self.showErrorAlert(errorMessage: error.localizedDescription)
                    self.popupContentView.saveButton.isEnabled = true
                }
            }
        }, for: .touchUpInside)
    }
}

final class CreateKeywordView: BaseView {
    private let containerView = UIView().then {
        $0.backgroundColor = TDColor.baseWhite
    }
    
    let titleLabel = TDLabel(
        labelText: "키워드 추가",
        toduckFont: .boldHeader4,
        toduckColor: TDColor.Neutral.neutral800
    )
    
    let descriptionLabel = TDLabel(
        labelText: "카테고리",
        toduckFont: .mediumBody2,
        toduckColor: TDColor.Neutral.neutral600
    )
    
    let keywordDropDownView = KeywordDropdownView()
    
    private(set) lazy var dropDownHoverView = TDDropdownHoverView(
        anchorView: keywordDropDownView,
        selectedOption: UserKeywordCategory.allCases[0].title,
        layout: .trailing,
        width: UIScreen.main.bounds.size.width - 32 * 2
    )
    
    let textField = UITextField().then {
        $0.font = TDFont.mediumBody1.font
        $0.textColor = TDColor.Neutral.neutral800
        $0.backgroundColor = TDColor.Neutral.neutral50
        $0.autocapitalizationType = .none
        $0.layer.borderWidth = 1
        $0.leftViewMode = .always
        $0.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        $0.layer.borderColor = TDColor.Neutral.neutral300.cgColor
        $0.layer.cornerRadius = 12
        $0.clearButtonMode = .always
        $0.adjustsFontSizeToFitWidth = true
        let placeholderText = "키워드를 입력해주세요"
        let placeholderColor = TDColor.Neutral.neutral500
        let placeholderFont = TDFont.mediumBody1.font

        $0.attributedPlaceholder = NSAttributedString(
            string: placeholderText,
            attributes: [
                .foregroundColor: placeholderColor,
                .font: placeholderFont
            ]
        )
    }
    
    private let buttonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
    }
    
    let cancelButton = TDBaseButton(
        title: "취소",
        backgroundColor: TDColor.baseWhite,
        foregroundColor: TDColor.Neutral.neutral700,
        radius: 12,
        font: TDFont.boldHeader3.font
    ).then {
        $0.layer.borderColor = TDColor.Neutral.neutral300.cgColor
        $0.layer.borderWidth = 1
    }
    
    let saveButton = TDBaseButton(
        title: "추가",
        backgroundColor: TDColor.Primary.primary500,
        foregroundColor: TDColor.baseWhite,
        radius: 12,
        font: TDFont.boldHeader3.font
    )
    
    override func addview() {
        addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(dropDownHoverView)
        containerView.addSubview(textField)
        containerView.addSubview(buttonStackView)
        buttonStackView.addArrangedSubview(cancelButton)
        buttonStackView.addArrangedSubview(saveButton)
    }
    
    override func configure() {
        containerView.layer.cornerRadius = 28
    }
    
    override func layout() {
        containerView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(28)
            make.height.equalTo(18)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        keywordDropDownView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(16)
            make.leading.trailing.equalTo(containerView).inset(16)
            make.height.equalTo(48)
        }
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(dropDownHoverView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().offset(-16)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.height.equalTo(52)
        }
        
        saveButton.snp.makeConstraints { make in
            make.height.equalTo(52)
        }
    }
}
