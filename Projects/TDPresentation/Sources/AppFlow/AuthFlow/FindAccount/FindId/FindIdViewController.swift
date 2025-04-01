import Combine
import UIKit
import TDCore
import TDDesign

final class FindIdViewController: BaseViewController<FindIdView> {
    private let viewModel: FindIdViewModel
    private let input = PassthroughSubject<FindIdViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    weak var coordinator: FindAccountCoordinator?
    
    init(
        viewModel: FindIdViewModel
    ) {
        self.viewModel = viewModel
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        layoutView.phoneNumberTextField.delegate = self
        layoutView.verificationNumberTextField.delegate = self
        keyboardAdjustableView = layoutView.nextButton
        
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
                case .verificationCodeValid(let userId):
                    let showIdViewController = ShowIdViewController()
                    showIdViewController.setUserId(with: userId)
                    showIdViewController.coordinator = self?.coordinator
                    self?.navigationController?.pushViewController(showIdViewController, animated: true)
                case .updateVerificationTimer(let time):
                    self?.layoutView.verificationNumberTimerLabel.setText(time)
                case .failureAPI(let message):
                    self?.showErrorAlert(with: message)
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - UITextFieldDelegate
extension FindIdViewController: UITextFieldDelegate {
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
            layoutView.nextButton.isEnabled = textField.text?.count == 6
            layoutView.nextButton.layer.borderWidth = 0
        }
    }
}
