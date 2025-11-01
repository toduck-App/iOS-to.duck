import FittedSheets
import Kingfisher
import TDCore
import TDDomain
import UIKit

final class EventSheetCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var finishDelegate: CoordinatorFinishDelegate?
    var injector: DependencyResolvable
    weak var deepLinkRouter: DeepLinkRoutable?
    
    init(
        navigationController: UINavigationController,
        injector: DependencyResolvable,
    ) {
        self.navigationController = navigationController
        self.injector = injector
    }
    
    func start() {
        let fetchEventUseCase = injector.resolve(FetchEventsUseCase.self)
        Task {
            let eventList = await fetchEventUseCase.execute()
            if eventList.isEmpty { return }

            let urls = eventList.compactMap { $0.thumbURL }
            let aspects = await KingfisherManager.shared.fetchImageAspects(for: urls)

            await MainActor.run {
                let vc = EventSheetViewController(events: eventList,
                                                  precomputedAspects: aspects)
                vc.coordinator = self
                let sheet = SheetViewController(
                    controller: vc,
                    sizes: [.intrinsic],
                    options: .init(
                        pullBarHeight: 0,
                        shouldExtendBackground: false,
                        setIntrinsicHeightOnNavigationControllers: false,
                        useFullScreenMode: false,
                        shrinkPresentingViewController: false,
                        isRubberBandEnabled: false
                    )
                )
                sheet.cornerRadius = 28
                navigationController.present(sheet, animated: true)
            }
        }
    }

    func didTapDetailView(eventId: Int) {
        let fetchEventDetailUseCase = injector.resolve(FetchEventDetailsUseCase.self)
        Task {
            guard let eventdetail = try await fetchEventDetailUseCase.execute(eventId: eventId) else { return }
            await MainActor.run {
                let vc = EventDetailViewController(eventDetail: eventdetail)
                vc.coordinator = self
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen

                navigationController.presentedViewController?.dismiss(animated: true) { [weak self] in
                    self?.navigationController.present(nav, animated: true)
                }
            }
        }
    }
    
    func finish(by type: DismissType) {
        navigationController.presentedViewController?.dismiss(animated: true)
        finishDelegate?.didFinish(childCoordinator: self)
    }
}
