import Combine
import UIKit
import TDCore
import TDDesign

final class AuthViewController: BaseViewController<AuthView> {
    weak var coordinator: AuthCoordinator?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.isNavigationBarHidden = false
    }
    
    override func configure() {
        layoutView.mainButton.addAction(UIAction { [weak self] _ in
            self?.coordinator?.didMainButtonTapped()
        }, for: .touchUpInside)
        
        layoutView.signInButton.addAction(UIAction { [weak self] _ in
            self?.coordinator?.didSignInButtonTapped()
        }, for: .touchUpInside)
        
        layoutView.signUpButton.addAction(UIAction { [weak self] _ in
            self?.coordinator?.didSignUpButtonTapped()
        }, for: .touchUpInside)
    }
}

