//
//  WithdrawReasonInputCoordinator.swift
//  TDPresentation
//
//  Created by 정지용 on 1/29/25.
//

import UIKit

import TDCore

final class WithdrawReasonInputCoordinator: Coordinator {
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
        let withdrawReasonInputViewController = WithdrawReasonInputViewController()
        withdrawReasonInputViewController.hidesBottomBarWhenPushed = true
        withdrawReasonInputViewController.coordinator = self
        navigationController.pushViewController(withdrawReasonInputViewController, animated: true)
    }
    
    func popViewController() {
        navigationController.popViewController(animated: true)
        finishDelegate?.didFinish(childCoordinator: self)
    }
}

extension WithdrawReasonInputCoordinator: CoordinatorFinishDelegate {
    func didFinish(childCoordinator: Coordinator) {
        childCoordinators.removeAll { $0 === childCoordinator }
    }
}

extension WithdrawReasonInputCoordinator {
    func didTapNextButton() {
        let withdrawCompletionCoordinator = WithdrawCompletionCoordinator(
            navigationController: navigationController,
            injector: injector
        )
        withdrawCompletionCoordinator.finishDelegate = self
        childCoordinators.append(withdrawCompletionCoordinator)
        withdrawCompletionCoordinator.start()
    }
}
