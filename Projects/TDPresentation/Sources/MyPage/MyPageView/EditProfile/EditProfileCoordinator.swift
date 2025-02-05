//
//  EditProfileCoordinator.swift
//  TDPresentation
//
//  Created by 정지용 on 1/20/25.
//

import UIKit

import TDCore

final class EditProfileCoordinator: Coordinator {
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
        let editProfileViewController = EditProfileViewController()
        editProfileViewController.coordinator = self
        navigationController.pushViewController(editProfileViewController, animated: true)
    }
    
    func popViewController() {
        navigationController.popViewController(animated: true)
        finishDelegate?.didFinish(childCoordinator: self)
    }
}

// MARK: - Coordinator Finish Delegate
extension EditProfileCoordinator: CoordinatorFinishDelegate {
    func didFinish(childCoordinator: Coordinator) {
        childCoordinators.removeAll { $0 === childCoordinator }
    }
}
