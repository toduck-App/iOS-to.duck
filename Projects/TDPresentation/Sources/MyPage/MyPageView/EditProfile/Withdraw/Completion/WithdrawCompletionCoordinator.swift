//
//  WithdrawCompletionCoordinator.swift
//  TDPresentation
//
//  Created by 정지용 on 3/27/25.
//

import UIKit

import TDCore

final class WithdrawCompletionCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var finishDelegate: CoordinatorFinishDelegate?
    var injector: DependencyResolvable
    
    init(
        navigationController: UINavigationController,
        injector: DependencyResolvable
    ) {
        self.navigationController = navigationController
        self.injector = injector
    }
    
    func start() {
        let withdrawCompletionViewController = WithdrawCompletionViewController()
        withdrawCompletionViewController.hidesBottomBarWhenPushed = true
        withdrawCompletionViewController.coordinator = self
        navigationController.pushViewController(withdrawCompletionViewController, animated: true)
    }
    
    func popViewController() {
        navigationController.popViewController(animated: true)
        finishDelegate?.didFinish(childCoordinator: self)
    }

    func popToRootViewController() {
        navigationController.popToRootViewController(animated: true)
        finishDelegate?.didFinish(childCoordinator: self)
    }
}

extension WithdrawCompletionCoordinator: CoordinatorFinishDelegate {
    func didFinish(childCoordinator: Coordinator) {
        childCoordinators.removeAll { $0 === childCoordinator }
    }
}
