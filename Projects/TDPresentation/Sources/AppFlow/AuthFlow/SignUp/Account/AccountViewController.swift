import Combine
import UIKit
import TDCore
import TDDesign

final class AccountViewController: BaseViewController<AccountView> {
    private let viewModel: AccountViewModel
    private let input = PassthroughSubject<AccountViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    weak var coordinator: AccountCoordinator?
    
    init(viewModel: AccountViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        layoutView.idTextField.delegate = self
        layoutView.passwordTextField.delegate = self
        layoutView.verifyPasswordTextField.delegate = self
        keyboardAdjustableView = layoutView.nextButton
        setupButtonActions()
        navigationController?.setupNestedNavigationBar(
            leftButtonTitle: "",
            leftButtonAction: UIAction { [weak self] _ in
                self?.coordinator?.finish(by: .pop)
            }
        )
    }
    
    override func binding() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())

        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .invalidIdFormat:
                    self?.layoutView.idFieldStateLabel.setText("5~20자 영문 소문자, 숫자를 사용하여 입력해주세요.")
                    self?.layoutView.idContainerView.layer.borderColor = TDColor.Semantic.error.cgColor
                    self?.layoutView.idContainerView.backgroundColor = TDColor.Semantic.error.withAlphaComponent(0.05)
                    self?.layoutView.idFieldStateLabel.setColor(TDColor.Semantic.error)
                case .validId:
                    self?.layoutView.idContainerView.backgroundColor = TDColor.Neutral.neutral50
                    self?.layoutView.idContainerView.layer.borderColor = TDColor.Neutral.neutral300.cgColor
                    self?.layoutView.idFieldStateLabel.isHidden = true
                case .notDuplicateId:
                    self?.layoutView.idFieldStateLabel.isHidden = false
                    self?.layoutView.idFieldStateLabel.setText("사용 가능한 아이디입니다.")
                    self?.layoutView.idFieldStateLabel.setColor(TDColor.Semantic.success)
                case .invalidPassword:
                    self?.layoutView.invaildPasswordLabel.isHidden = false
                    self?.layoutView.passwordContainerView.layer.borderColor = TDColor.Semantic.error.cgColor
                    self?.layoutView.passwordContainerView.backgroundColor = TDColor.Semantic.error.withAlphaComponent(0.05)
                case .validPassword:
                    self?.layoutView.invaildPasswordLabel.isHidden = true
                    self?.layoutView.passwordContainerView.layer.borderColor = TDColor.Neutral.neutral300.cgColor
                    self?.layoutView.passwordContainerView.backgroundColor = TDColor.Neutral.neutral50
                case .passwordMismatch:
                    self?.layoutView.invaildVerifyPasswordLabel.isHidden = false
                    self?.layoutView.verifyPasswordContainerView.layer.borderColor = TDColor.Semantic.error.cgColor
                    self?.layoutView.verifyPasswordContainerView.backgroundColor = TDColor.Semantic.error.withAlphaComponent(0.05)
                case .passwordMatched:
                    self?.layoutView.invaildVerifyPasswordLabel.isHidden = true
                    self?.layoutView.verifyPasswordContainerView.layer.borderColor = TDColor.Neutral.neutral300.cgColor
                    self?.layoutView.verifyPasswordContainerView.backgroundColor = TDColor.Neutral.neutral50
                case .updateNextButtonState(let isEnabled):
                    self?.layoutView.nextButton.isEnabled = isEnabled
                    self?.layoutView.nextButton.layer.borderWidth = 0
                case .updateDuplicateVerificationButtonState(let isEnabled):
                    self?.layoutView.duplicateVerificationButton.isEnabled = isEnabled
                    self?.layoutView.duplicateVerificationButton.layer.borderWidth = 0
                case .duplicateId:
                    self?.showErrorAlert(
                        titleError: "앗! 이미 사용중인 아이디에요",
                        errorMessage: "다른 아이디를 사용해 주세요",
                        image: TDImage.duplicateId
                    )
                case .successRegister:
                    self?.coordinator?.startRegisterSuccessViewCoordinator()
                case .failureRegister(let message):
                    self?.showErrorAlert(errorMessage: message)
                }
            }.store(in: &cancellables)
    }
    
    @objc
    override func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }

        UIView.animate(withDuration: duration) {
            self.layoutView.nextButton.transform = CGAffineTransform(translationX: 0, y: -keyboardFrame.height + 20)
            self.layoutView.contentWrapperView.transform = CGAffineTransform(translationX: 0, y: -100)
        }
    }
    
    @objc
    override func keyboardWillHide(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
              let button = keyboardAdjustableView else { return }

        UIView.animate(withDuration: duration) {
            self.layoutView.contentWrapperView.transform = .identity
            button.transform = .identity
        }
    }
    
    private func setupButtonActions() {
        layoutView.duplicateVerificationButton.addAction(UIAction { [weak self] _ in
            self?.input.send(.duplicateIdVerification)
        }, for: .touchUpInside)

        layoutView.nextButton.addAction(UIAction { [weak self] _ in
            self?.input.send(.registerUser)
        }, for: .touchUpInside)
    }
}

// MARK: - UITextFieldDelegate
extension AccountViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == layoutView.idTextField {
            let id = layoutView.idTextField.text ?? ""
            input.send(.validateId(id))
        }
        
        if textField == layoutView.passwordTextField {
            let password = layoutView.passwordTextField.text ?? ""
            input.send(.validatePassword(password))
        }
        
        if textField == layoutView.verifyPasswordTextField {
            let password = layoutView.passwordTextField.text ?? ""
            let verifyPassword = layoutView.verifyPasswordTextField.text ?? ""
            input.send(.checkPasswordMatch(password, verifyPassword))
        }
    }
}
