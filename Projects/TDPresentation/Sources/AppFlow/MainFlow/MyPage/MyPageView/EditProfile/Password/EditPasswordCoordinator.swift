//
//  EditPasswordCoordinator.swift
//  TDPresentation
//
//  Created by 정지용 on 1/23/25.
//

import TDCore

import UIKit

final class EditPasswordCoordinator: Coordinator {
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
        let editPasswordViewController = EditPasswordViewController()
        editPasswordViewController.hidesBottomBarWhenPushed = true
        editPasswordViewController.coordinator = self
        navigationController.pushViewController(editPasswordViewController, animated: true)
    }
    
    func popViewController() {
        navigationController.popViewController(animated: true)
        finishDelegate?.didFinish(childCoordinator: self)
    }
}
