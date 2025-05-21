import UIKit
import SnapKit

import TDDesign

final class EditPasswordView: BaseView {
    private let passwordFieldStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = LayoutConstants.fieldSpacing
        return stackView
    }()
    
    private let currentPasswordField = TDTextField(
        placeholder: "현재 비밀번호를 입력해주세요",
        labelText: "현재 비밀번호"
    )
    
    private let newPasswordField = TDTextField(
        placeholder: "영문 대/소문자, 숫자, 특수문자 포함 8자 이상",
        labelText: "새 비밀번호"
    )
    
    private let rePasswordField = TDTextField(
        placeholder: "새 비밀번호를 한 번 더 입력해주세요",
        labelText: "비밀번호 확인"
    )
    
    override func addview() {
        [currentPasswordField, newPasswordField, rePasswordField].forEach {
            passwordFieldStack.addArrangedSubview($0)
        }
        addSubview(passwordFieldStack)
    }
    
    override func layout() {
        passwordFieldStack.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(LayoutConstants.topPadding)
            $0.leading.trailing.equalToSuperview().inset(LayoutConstants.horizontalPadding)
        }
    }
}

private extension EditPasswordView {
    enum LayoutConstants {
        static let topPadding: CGFloat = 20
        static let fieldSpacing: CGFloat = 18
        static let horizontalPadding: CGFloat = 16
    }
}
