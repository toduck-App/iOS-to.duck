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
        appearance.configureWithDefaultBackground()
        appearance.titleTextAttributes = [.foregroundColor: TDColor.baseBlack]
        appearance.backgroundColor = TDColor.baseWhite
        let backButtonImage = TDImage.Direction.leftMedium
            .withRenderingMode(.alwaysTemplate)

        let backButtonAppearance = UIBarButtonItemAppearance()
        backButtonAppearance.normal.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.clear,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 0)
        ]

        topViewController.navigationController?.navigationBar.tintColor = TDColor.Neutral.neutral800
        
        appearance.shadowColor = .clear
        appearance.setBackIndicatorImage(backButtonImage, transitionMaskImage: backButtonImage)
        appearance.backButtonAppearance = backButtonAppearance

        topViewController.navigationController?.navigationBar.standardAppearance = appearance
        topViewController.navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
}
