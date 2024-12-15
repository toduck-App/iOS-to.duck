import FittedSheets
import TDCore
import TDDomain
import UIKit

protocol SocialReportDelegate {
    func didTapReportType(_ type: ReportType)
    func didTapReport()
}

final class SocialReportCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [any Coordinator]()
    var finishDelegate: CoordinatorFinishDelegate?
    var injector: DependencyResolvable = DIContainer.shared

    let postID: Int

    init(navigationController: UINavigationController, id: Int) {
        self.navigationController = navigationController
        self.postID = id
    }

    func start() {
        let controller = SocialReportViewController()
        let sheetController = SheetViewController(
            controller: controller,
            sizes: [.fixed(410)],
            options: .init(
                pullBarHeight: 0,
                shouldExtendBackground: false,
                setIntrinsicHeightOnNavigationControllers: false,
                useFullScreenMode: false,
                shrinkPresentingViewController: false,
                isRubberBandEnabled: false
            )
        )
        controller.coordinator = self
        sheetController.cornerRadius = 28
        navigationController.present(sheetController, animated: true, completion: nil)
    }
}

extension SocialReportCoordinator: SocialReportDelegate {
    func didTapReportType(_ type: ReportType) {
        navigationController.viewControllers.last?.dismiss(animated: true, completion: nil)

        let sizes: [SheetSize] = type == .custom ? [.fixed(412)] : [.fixed(320)]
        let controller = SocialReportDetailViewController(reason: type)
        let sheetController = SheetViewController(
            controller: controller,
            sizes: sizes,
            options: .init(
                pullBarHeight: 0,
                shouldExtendBackground: false,
                setIntrinsicHeightOnNavigationControllers: false,
                useFullScreenMode: false,
                shrinkPresentingViewController: false,
                isRubberBandEnabled: false
            )
        )
        controller.coordinator = self
        sheetController.cornerRadius = 28
        navigationController.present(sheetController, animated: true, completion: nil)
    }

    func didTapReport() {
        navigationController.viewControllers.last?.dismiss(animated: true, completion: nil)
    }
}
