//
//  WithdrawCoordinator.swift
//  TDPresentation
//
//  Created by 정지용 on 1/23/25.
//

import UIKit

import TDCore

final class WithdrawCoordinator: Coordinator {
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
        let withdrawViewController = WithdrawViewController()
        withdrawViewController.hidesBottomBarWhenPushed = true
        withdrawViewController.coordinator = self
        navigationController.pushViewController(withdrawViewController, animated: true)
    }
    
    func popViewController() {
        navigationController.popViewController(animated: true)
        finishDelegate?.didFinish(childCoordinator: self)
    }
}

extension WithdrawCoordinator: CoordinatorFinishDelegate {
    func didFinish(childCoordinator: Coordinator) {
        childCoordinators.removeAll { $0 === childCoordinator }
    }
}

extension WithdrawCoordinator {
    func didTapNextButton() {
        let withdrawReasonInputCoordinator = WithdrawReasonInputCoordinator(
            navigationController: navigationController,
            injector: injector
        )
        withdrawReasonInputCoordinator.finishDelegate = self
        childCoordinators.append(withdrawReasonInputCoordinator)
        withdrawReasonInputCoordinator.start()
    }
}
