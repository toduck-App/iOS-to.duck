import UIKit
import SnapKit
import TDCore
import TDDesign

final class AuthView: BaseView {
    let signInButton = TDBaseButton(title: "Sign In")
    let signUpButton = TDBaseButton(title: "Sign Up")
    
    override func addview() {
        addSubview(signInButton)
        addSubview(signUpButton)
    }
    
    override func layout() {
        signInButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(signUpButton.snp.top).offset(-20)
            make.height.equalTo(50)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
    }
}
