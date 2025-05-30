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
        let saveFocusUseCase = injector.resolve(SaveFocusUseCase.self)
        let focusTimerUseCase = injector.resolve(FocusTimerUseCase.self)
        let restTimerUseCase = injector.resolve(RestTimerUseCase.self)
        let pauseTimerUseCase = injector.resolve(PauseTimerUseCase.self)

        let fetchTimerSettingUseCase = injector.resolve(FetchTimerSettingUseCase.self)
        let updateTimerSettingUseCase = injector.resolve(UpdateTimerSettingUseCase.self)

        let fetchTimerThemeUseCase = injector.resolve(FetchTimerThemeUseCase.self)
        let updateTimerThemeUseCase = injector.resolve(UpdateTimerThemeUseCase.self)

        let timerViewModel = TimerViewModel(
            saveFocusUseCase: saveFocusUseCase,
            focusTimerUseCase: focusTimerUseCase,
            restTimerUseCase: restTimerUseCase,
            pauseTimerUseCase: pauseTimerUseCase,
            fetchTimerSettingUseCase: fetchTimerSettingUseCase,
            updateTimerSettingUseCase: updateTimerSettingUseCase,
            fetchTimerThemeUseCase: fetchTimerThemeUseCase,
            updateTimerThemeUseCase: updateTimerThemeUseCase
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
            navigationController: navigationController, injector: injector)
        toduckCalendarCoordinator.finishDelegate = self
        childCoordinators.append(toduckCalendarCoordinator)
        toduckCalendarCoordinator.start()
    }
}
