import TDCore
import FittedSheets
import TDDomain
import UIKit

protocol SocialEventJoinDelegate: AnyObject {
    func didTapJoin()
    func didTapCancel()
}

final class SocialEventJoinCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [any Coordinator]()
    var finishDelegate: CoordinatorFinishDelegate?
    var delegate: SocialEventJoinDelegate?
    var injector: DependencyResolvable
    var socialId: Int
    
    init(
        navigationController: UINavigationController,
        injector: DependencyResolvable,
        socialId: Int
    ) {
        self.navigationController = navigationController
        self.injector = injector
        self.socialId = socialId
    }
    
    func start() {
        let participateEventUseCase = injector.resolve(ParticipateEventUseCase.self)
        let viewModel = SocialEventJoinViewModel(
            participateEventUseCase: participateEventUseCase,
            socialId: socialId
        )
        let eventJoinViewController = SocialEventJoinViewController(viewModel: viewModel)
        eventJoinViewController.coordinator = self
        let sheetController = SheetViewController(
            controller: eventJoinViewController,
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
        sheetController.cornerRadius = 28
        navigationController.present(sheetController, animated: true)
    }
    
    func didTapJoin() {
        delegate?.didTapJoin()
    }
    
    func didTapCancle() {
        delegate?.didTapCancel()
    }
}
