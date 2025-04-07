import UIKit

final class EditInformationViewController: BaseViewController<EditInformationView> {
    weak var coordinator: EditInformationCoordinator?
    
    override func configure() {
        layoutView.backgroundColor = .white
        navigationController?.setupNestedNavigationBar(
            leftButtonTitle: "회원 정보 수정",
            leftButtonAction: UIAction { _ in
                self.coordinator?.popViewController()
            },
            rightButtonTitle: "저장",
            rightButtonAction: UIAction { _ in
                // TODO: 저장 기능 연동
                self.coordinator?.popViewController()
            }
        )
    }
}
