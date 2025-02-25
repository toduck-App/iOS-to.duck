import Combine
import UIKit
import TDCore
import TDDesign

final class SignUpViewController: BaseViewController<SignUpView> {
    weak var coordinator: SignUpCoordinator?
    
    override func configure() {
        layoutView.signInButton.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            self.coordinator?.didSignInButtonTapped(self)
        }, for: .touchUpInside)
        
        layoutView.signUpButton.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            self.coordinator?.didSignUpButtonTapped(self)
        }, for: .touchUpInside)
    }
}

