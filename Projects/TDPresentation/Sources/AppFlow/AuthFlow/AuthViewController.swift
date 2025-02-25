import Combine
import UIKit
import TDCore
import TDDesign

final class AuthViewController: BaseViewController<AuthView> {
    weak var coordinator: AuthCoordinator?
    
    override func configure() {
        layoutView.signUpButton.addAction(UIAction { [weak self] _ in
            self?.coordinator?.didSignUpButtonTapped()
        }, for: .touchUpInside)
    }
}

