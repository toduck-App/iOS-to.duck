import UIKit
import SnapKit
import TDCore
import TDDesign

final class SignUpView: BaseView {
    let signUpButton = TDBaseButton(title: "Sign Up")
    
    override func addview() {
        addSubview(signUpButton)
    }
    
    override func layout() {
        signUpButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
    }
}

