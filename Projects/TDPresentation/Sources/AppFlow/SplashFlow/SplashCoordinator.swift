import TDCore
import TDDomain
import UIKit

public final class SplashCoordinator: Coordinator {
    public var navigationController: UINavigationController
    public var childCoordinators: [Coordinator] = []
    public var finishDelegate: CoordinatorFinishDelegate?
    public var injector: DependencyResolvable
    
    public init(
        navigationController: UINavigationController,
        injector: DependencyResolvable
    ) {
        self.navigationController = navigationController
        self.injector = injector
    }
    
    public func start() {
        let validateVersionUseCase = injector.resolve(ValidateVersionUseCase.self)
        let splashViewModel = SplashViewModel(validateVersionUseCase: validateVersionUseCase)
        let splashViewController = SplashViewController(viewModel: splashViewModel)
        splashViewController.coordinator = self
        navigationController.setViewControllers([splashViewController], animated: false)
    }
}
