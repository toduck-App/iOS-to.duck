import Combine
import TDDomain
import UIKit
import TDCore
import TDDesign

final class FindPasswordViewController: BaseViewController<FindPasswordView> {
    private let viewModel: FindPasswordViewModel
    private let input = PassthroughSubject<FindPasswordViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    weak var coordinator: FindAccountCoordinator?
    
    init(
        viewModel: FindPasswordViewModel
    ) {
        self.viewModel = viewModel
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        layoutView.idTextField.delegate = self
        layoutView.phoneNumberTextField.delegate = self
        layoutView.verificationNumberTextField.delegate = self
        keyboardAdjustableView = layoutView.nextButton
        
        layoutView.postButton.addAction(UIAction { [weak self] _ in
            self?.input.send(.postPhoneNumber)
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
                case .loginIdInvalid(let message):
                    self?.showErrorAlert(errorMessage: message)
                case .phoneNumberInvalid:
                    self?.layoutView.invaildPhoneNumberLabel.isHidden = false
                    self?.layoutView.phoneNumberContainerView.layer.borderColor = TDColor.Semantic.error.cgColor
                    self?.layoutView.phoneNumberContainerView.backgroundColor = TDColor.Semantic.error.withAlphaComponent(0.05)
                case .phoneNumberValid:
                    self?.layoutView.verificationNumberContainerView.isHidden = false
                    self?.layoutView.invaildPhoneNumberLabel.isHidden = true
                    self?.layoutView.phoneNumberContainerView.backgroundColor = TDColor.Neutral.neutral50
                    self?.layoutView.phoneNumberContainerView.layer.borderColor = TDColor.Neutral.neutral300.cgColor
                case .verificationCodeInvalid:
                    self?.layoutView.invaildVerificationNumberLabel.isHidden = false
                    self?.layoutView.verificationNumberContainerView.layer.borderColor = TDColor.Semantic.error.cgColor
                    self?.layoutView.verificationNumberContainerView.backgroundColor = TDColor.Semantic.error.withAlphaComponent(0.05)
                case .verificationCodeValid(let phoneNumber, let loginId):
                    let changePasswordUseCase = DIContainer.shared.resolve(ChangePasswordUseCase.self)
                    let changePasswordViewModel = ChangePasswordViewModel(changePasswordUseCase: changePasswordUseCase, phoneNumber: phoneNumber, loginId: loginId)
                    let changePasswordViewController = ChangePasswordViewController(viewModel: changePasswordViewModel)
                    changePasswordViewController.coordinator = self?.coordinator
                    self?.navigationController?.pushViewController(changePasswordViewController, animated: true)
                case .validIdAndPhoneNumber:
                    self?.layoutView.postButton.isEnabled = true
                    self?.layoutView.postButton.layer.borderWidth = 0
                case .updateVerificationTimer(let time):
                    self?.layoutView.verificationNumberTimerLabel.setText(time)
                case .failureAPI(let message):
                    self?.showErrorAlert(errorMessage: message)
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - UITextFieldDelegate
extension FindPasswordViewController: UITextFieldDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        guard let text = textField.text else { return false }
        let newLength = text.count + string.count - range.length
        
        switch textField {
        case layoutView.idTextField:
            return newLength <= 20
        case layoutView.phoneNumberTextField:
            return newLength <= 11
        case layoutView.verificationNumberTextField:
            return newLength <= 6
        default:
            return false
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == layoutView.idTextField {
            let id = textField.text ?? ""
            input.send(.validateId(id: id))
        }
        
        if textField == layoutView.phoneNumberTextField {
            let phoneNumber = textField.text ?? ""
            input.send(.validatePhoneNumber(phoneNumber: phoneNumber))
        }
        
        if textField == layoutView.verificationNumberTextField {
            layoutView.nextButton.isEnabled = textField.text?.count == 6
            layoutView.nextButton.layer.borderWidth = 0
        }
    }
}
