//
//  EditProfileMenuCoordinator.swift
//  TDPresentation
//
//  Created by 정지용 on 1/20/25.
//

import UIKit

import TDCore

final class EditProfileMenuCoordinator: Coordinator {
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
        let editProfileMenuViewController = EditProfileMenuViewController()
        editProfileMenuViewController.coordinator = self
        navigationController.pushViewController(editProfileMenuViewController, animated: true)
    }
}

// MARK: - Coordinator Finish Delegate
extension EditProfileMenuCoordinator: CoordinatorFinishDelegate {
    func didFinish(childCoordinator: Coordinator) {
        childCoordinators.removeAll { $0 === childCoordinator }
    }
}

// MARK: - Navigation Delegate
extension EditProfileMenuCoordinator {
    func didTapEditProfileButton() {
        let editProfileCoordinator = EditProfileCoordinator(
            navigationController: navigationController,
            injector: injector
        )
        editProfileCoordinator.finishDelegate = self
        childCoordinators.append(editProfileCoordinator)
        editProfileCoordinator.start()
    }
    
    func didTapEditInformationButton() {
        let editInformationCoordinator = EditInformationCoordinator(
            navigationController: navigationController,
            injector: injector
        )
        editInformationCoordinator.finishDelegate = self
        childCoordinators.append(editInformationCoordinator)
        editInformationCoordinator.start()
    }
    
    func didTapEditPasswordButton() {
        let editPasswordCoordinator = EditPasswordCoordinator(
            navigationController: navigationController,
            injector: injector
        )
        editPasswordCoordinator.finishDelegate = self
        childCoordinators.append(editPasswordCoordinator)
        editPasswordCoordinator.start()
    }
}
