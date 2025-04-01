import Combine
import UIKit
import TDCore
import TDDesign

final class SignInViewController: BaseViewController<SignInView> {
    private let viewModel: SignInViewModel
    private let input = PassthroughSubject<SignInViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    weak var coordinator: SignInCoordinator?
    
    init(
        viewModel: SignInViewModel
    ) {
        self.viewModel = viewModel
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        keyboardAdjustableView = layoutView.nextButton
        layoutView.idTextField.delegate = self
        layoutView.passwordTextField.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapFindIdPassword))
        layoutView.findAccountContainerView.addGestureRecognizer(tapGesture)
        
        layoutView.nextButton.addAction(UIAction { [weak self] _ in
            self?.input.send(.didTapSignIn)
        }, for: .touchUpInside)
    }
    
    @objc
    private func didTapFindIdPassword() {
        coordinator?.didFindAccount()
    }
    
    override func binding() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .validSignIn:
                    self?.coordinator?.finish(by: .pop)
                case .invalidSignIn:
                    UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn) {
                        self?.layoutView.failedContainerView.alpha = 1
                    } completion: { _ in
                        UIView.animate(withDuration: 1, delay: 4.0, options: .curveEaseOut) {
                            self?.layoutView.failedContainerView.alpha = 0
                        }
                    }
                }
            }.store(in: &cancellables)
    }
}

// MARK: - UITextFieldDelegate
extension SignInViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == layoutView.idTextField {
            input.send(.loginIdChanged(textField.text ?? ""))
        } else if textField == layoutView.passwordTextField {
            input.send(.passwordChanged(textField.text ?? ""))
        }
        
        validateInputFields()
    }
    
    /// 입력 필드 유효성 검사 및 버튼 활성화 처리
    private func validateInputFields() {
        let idText = layoutView.idTextField.text ?? ""
        let passwordText = layoutView.passwordTextField.text ?? ""
        
        let isIdValid = idText.count >= 5 && idText.count <= 20
        #if DEBUG
        let isPasswordValid = passwordText.count >= 4 && passwordText.count <= 16
        #else
        let isPasswordValid = passwordText.count >= 8 && passwordText.count <= 16
        #endif
        
        let isFormValid = isIdValid && isPasswordValid
        
        layoutView.nextButton.isEnabled = isFormValid
        layoutView.nextButton.layer.borderWidth = 0
    }
}
