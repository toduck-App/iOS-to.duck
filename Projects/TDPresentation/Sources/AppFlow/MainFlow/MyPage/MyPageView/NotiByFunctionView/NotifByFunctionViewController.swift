import UIKit
import TDDesign

final class NotifByFunctionViewController: BaseViewController<NotifByFunctionView> {
    weak var coordinator: NotifByFunctionCoordinator?

    let initialStates: [Bool] = [ true, false, true, false, true ]
    let functionNames = ["공지 사항","홈","집중","일기","소셜"]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupToggles()
    }

    private func setupToggles() {
        guard layoutView.toggles.count == initialStates.count else { return }

        for (index, toggle) in layoutView.toggles.enumerated() {
            toggle.isOn = initialStates[index]
            toggle.addTarget(
                self,
                action: #selector(didChangeToggle(_:)),
                for: .valueChanged
            )
        }
    }

    // 네비게이션 바 설정
    override func configure() {
        navigationController?.setupNestedNavigationBar(
            leftButtonTitle: "기능별 알림",
            leftButtonAction: UIAction { [weak self] _ in
                self?.coordinator?.finish(by: .pop)
            }
        )
    }
    @objc private func didChangeToggle(_ sender: TDToggle) {
        let idx = sender.tag
        let name = functionNames[idx]
        print("[\(name)] 알림이 \(sender.isOn ? "켜짐(On)" : "꺼짐(Off)")")
    }
}
