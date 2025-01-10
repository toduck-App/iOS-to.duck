import TDDesign
import UIKit

extension UINavigationController {
    /// - Parameters:
    ///   - viewController: Push할 ViewController
    ///   - animated: 애니메이션 여부
    func pushTDViewController(
        _ viewController: UIViewController,
        animated: Bool
    ) {
        self.pushViewController(viewController, animated: animated)

        guard let topViewController = self.topViewController else { return }

        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = [.foregroundColor: TDColor.baseBlack]

        topViewController.navigationController?.navigationBar.standardAppearance = appearance
        topViewController.navigationController?.navigationBar.scrollEdgeAppearance = appearance

        // 왼쪽 버튼 설정
        let leftButton = UIButton(type: .custom)
        leftButton.setImage(TDImage.Direction.leftMedium.withRenderingMode(.alwaysTemplate), for: .normal)
        leftButton.tintColor = TDColor.Neutral.neutral600

        let popAction = UIAction { [weak self] _ in
            self?.popViewController(animated: true)
        }
        leftButton.addAction(popAction, for: .touchUpInside)

        topViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
    }
}
