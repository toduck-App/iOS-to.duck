import Combine
import UIKit
import TDCore
import TDDesign

final class PhoneVerificationViewController: BaseViewController<PhoneVerificationView> {
    private let viewModel: PhoneVerificationViewModel
    private let input = PassthroughSubject<PhoneVerificationViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    weak var coordinator: PhoneVerificationCoordinator?
    
    init(
        viewModel: PhoneVerificationViewModel
    ) {
        self.viewModel = viewModel
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        layoutView.carrierDropDownView.delegate = self
        layoutView.carrierDropDownView.dataSource = CarrierDropDownMenuItem.allCases.map { $0.dropDownItem }
        layoutView.phoneNumberTextField.delegate = self
        layoutView.verificationNumberTextField.delegate = self
        
        layoutView.postButton.addAction(UIAction { [weak self] _ in
            let phoneNumber = self?.layoutView.phoneNumberTextField.text ?? ""
            self?.input.send(.postPhoneNumber(phoneNumber: phoneNumber))
        }, for: .touchUpInside)
        
        layoutView.nextButton.addAction(UIAction { [weak self] _ in
            let code = self?.layoutView.verificationNumberTextField.text ?? ""
            self?.input.send(.postVerificationCode(code: code))
        }, for: .touchUpInside)
    }
    
    override func binding() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] action in
                switch action {
                case .phoneNumberInvalid:
                    self?.layoutView.invaildPhoneNumberLabel.isHidden = false
                    print("전화번호 형식이 올바르지 않습니다.")
                case .phoneNumberValid:
                    self?.layoutView.verificationNumberContainerView.isHidden = false
                    self?.layoutView.invaildPhoneNumberLabel.isHidden = true
                    print("전화번호 형식이 올바릅니다.")
                case .phoneNumberAlreadyExist:
                    print("이미 가입된 전화번호입니다.")
                case .verificationCodeInvalid:
                    self?.layoutView.invaildVerificationNumberLabel.isHidden = false
                    print("인증번호 형식이 올바르지 않습니다.")
                case .verificationCodeValid:
                    print("인증번호 형식이 올바릅니다.")
                    self?.coordinator?.startAccountViewCoordinator()
                case .updateVerificationTimer(let time):
                    self?.layoutView.verificationNumberTimerLabel.setText(time)
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - TDDropDownDelegate
extension PhoneVerificationViewController: TDDropDownDelegate {
    func dropDown(
        _ dropDownView: TDDropdownHoverView,
        didSelectRowAt indexPath: IndexPath
    ) {
        let option = CarrierDropDownMenuItem.allCases[indexPath.row]
        layoutView.carrierLabel.setText(option.rawValue)
    }
}

// MARK: - UITextFieldDelegate
extension PhoneVerificationViewController: UITextFieldDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        guard let text = textField.text else { return false }
        let newLength = text.count + string.count - range.length
        
        switch textField {
        case layoutView.phoneNumberTextField:
            return newLength <= 11
        case layoutView.verificationNumberTextField:
            return newLength <= 6
        default:
            return false
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == layoutView.verificationNumberTextField {
            layoutView.nextButton.isUserInteractionEnabled = textField.text?.count == 6
        }
    }
}
