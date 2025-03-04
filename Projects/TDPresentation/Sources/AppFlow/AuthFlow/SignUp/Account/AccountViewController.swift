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
        
        setupButtonActions()
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
                    self?.layoutView.idContainerView.layer.borderWidth = 1
                    self?.layoutView.idContainerView.backgroundColor = TDColor.Semantic.error.withAlphaComponent(0.05)
                    self?.layoutView.idFieldStateLabel.setColor(TDColor.Semantic.error)
                case .validId:
                    self?.layoutView.idContainerView.layer.borderWidth = 0
                    self?.layoutView.idContainerView.backgroundColor = TDColor.Neutral.neutral100
                    self?.layoutView.idFieldStateLabel.setText("사용 가능한 아이디입니다.")
                    self?.layoutView.idFieldStateLabel.setColor(TDColor.Semantic.success)
                case .invalidPassword:
                    self?.layoutView.invaildPasswordLabel.isHidden = false
                    self?.layoutView.passwordContainerView.layer.borderColor = TDColor.Semantic.error.cgColor
                    self?.layoutView.passwordContainerView.layer.borderWidth = 1
                    self?.layoutView.passwordContainerView.backgroundColor = TDColor.Semantic.error.withAlphaComponent(0.05)
                case .validPassword:
                    self?.layoutView.invaildPasswordLabel.isHidden = true
                    self?.layoutView.passwordContainerView.layer.borderWidth = 0
                    self?.layoutView.passwordContainerView.backgroundColor = TDColor.Neutral.neutral100
                case .passwordMismatch:
                    self?.layoutView.invaildVerifyPasswordLabel.isHidden = false
                    self?.layoutView.verifyPasswordContainerView.layer.borderColor = TDColor.Semantic.error.cgColor
                    self?.layoutView.verifyPasswordContainerView.layer.borderWidth = 1
                    self?.layoutView.verifyPasswordContainerView.backgroundColor = TDColor.Semantic.error.withAlphaComponent(0.05)
                case .passwordMatched:
                    self?.layoutView.invaildVerifyPasswordLabel.isHidden = true
                    self?.layoutView.verifyPasswordContainerView.layer.borderWidth = 0
                    self?.layoutView.verifyPasswordContainerView.backgroundColor = TDColor.Neutral.neutral100
                case .updateNextButtonState(let isEnabled):
                    self?.layoutView.nextButton.isEnabled = isEnabled
                    self?.layoutView.nextButton.layer.borderWidth = 0
                case .updateDuplicateVerificationButtonState(let isEnabled):
                    self?.layoutView.duplicateVerificationButton.isEnabled = isEnabled
                    self?.layoutView.duplicateVerificationButton.layer.borderWidth = 0
                }
            }.store(in: &cancellables)
    }
    
    private func setupButtonActions() {
        layoutView.duplicateVerificationButton.addAction(UIAction { [weak self] _ in
            guard let id = self?.layoutView.idTextField.text else { return }
            self?.input.send(.validateId(id))
        }, for: .touchUpInside)

        layoutView.nextButton.addAction(UIAction { [weak self] _ in
            let password = self?.layoutView.passwordTextField.text ?? ""
            let verifyPassword = self?.layoutView.verifyPasswordTextField.text ?? ""
            
            self?.input.send(.validatePassword(password))
            self?.input.send(.checkPasswordMatch(password, verifyPassword))
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
