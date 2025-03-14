import TDCore
import UIKit

public protocol CoordinatorFinishDelegate: AnyObject {
    func didFinish(childCoordinator: Coordinator)
}

public protocol Coordinator: AnyObject {
    var navigationController : UINavigationController { get set }
    var childCoordinators: [Coordinator] { get set }
    var finishDelegate: CoordinatorFinishDelegate? { get set }
    
    func start()
    func finish(shouldPop: Bool)
}

extension Coordinator {
    public func finish(shouldPop: Bool = true) {
        childCoordinators.forEach { $0.finish(shouldPop: false) }
        finishDelegate?.didFinish(childCoordinator: self)
        
        if shouldPop {
            navigationController.popViewController(animated: true)
        }
    }
}
