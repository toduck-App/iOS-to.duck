import UIKit
import SnapKit
import TDCore
import TDDesign

final class AuthView: BaseView {
    let mainButton = TDBaseButton(title: "Main")
    let signInButton = TDBaseButton(title: "Sign In")
    let signUpButton = TDBaseButton(title: "Sign Up")
    
    override func addview() {
        addSubview(mainButton)
        addSubview(signInButton)
        addSubview(signUpButton)
    }
    
    override func layout() {
        mainButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.height.equalTo(50)
        }
        
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
