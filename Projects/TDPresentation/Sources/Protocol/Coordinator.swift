import TDCore
import UIKit

public protocol Coordinator: AnyObject {
    var navigationController : UINavigationController { get set }
    var childCoordinators: [Coordinator] { get set }
    var finishDelegate: CoordinatorFinishDelegate? { get set }
    
    func start()
    func finish(by type: DismissType)
}

extension Coordinator {
    public func finish(by type: DismissType) {
        childCoordinators.forEach { $0.finish(by: .pop) }
        
        switch type {
        case .pop:
            navigationController.popViewController(animated: true)
        case .popNotAnimated:
            navigationController.popViewController(animated: false)
        case .modal:
            navigationController.dismiss(animated: true)
        case .sheet(let completion):
            navigationController.dismiss(animated: true, completion: completion)
        }
        
        finishDelegate?.didFinish(childCoordinator: self)
    }
}
