//
//  TimerCoordinator.swift
//  toduck
//
//  Created by 박효준 on 7/16/24.
//

import TDCore
import TDDesign
import TDDomain
import UIKit

final class TimerCoordinator: Coordinator {
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
        let timerUseCase = injector.resolve(TimerUseCase.self)

        let fetchTimerSettingUseCase = injector.resolve(FetchTimerSettingUseCase.self)
        let updateTimerSettingUseCase = injector.resolve(UpdateTimerSettingUseCase.self)

        let fetchFocusCountUseCase = injector.resolve(FetchFocusCountUseCase.self)
        let updateFocusCountUseCase = injector.resolve(UpdateFocusCountUseCase.self)
        let timerViewModel = TimerViewModel(
            timerUseCase: timerUseCase,
            fetchTimerSettingUseCase: fetchTimerSettingUseCase,
            updateTimerSettingUseCase: updateTimerSettingUseCase,
            fetchFocusCountUseCase: fetchFocusCountUseCase,
            updateFocusCountUseCase: updateFocusCountUseCase
        )

        let timerViewController = TimerViewController(viewModel: timerViewModel)

        timerViewController.coordinator = self
        navigationController.pushViewController(
            timerViewController, animated: false
        )
    }
}

// MARK: - Coordinator Finish Delegate

extension TimerCoordinator: CoordinatorFinishDelegate {
    func didFinish(childCoordinator: Coordinator) {
        childCoordinators.removeAll { $0 === childCoordinator }
    }
}

// MARK: - Navigation Delegate

extension TimerCoordinator: NavigationDelegate {
    func didTapCalendarButton() {
        let toduckCalendarCoordinator = ToduckCalendarCoordinator(
            navigationController: navigationController)
        toduckCalendarCoordinator.finishDelegate = self
        childCoordinators.append(toduckCalendarCoordinator)
        toduckCalendarCoordinator.start()
    }
}
