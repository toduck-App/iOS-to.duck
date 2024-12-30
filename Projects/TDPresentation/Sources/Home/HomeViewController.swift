//
//  HomeViewController.swift
//  toduck
//
//  Created by 박효준 on 7/15/24.
//

import TDDesign
import UIKit

final class HomeViewController: BaseViewController<BaseView> {
    // MARK: - UI Components
    let segmentedControl = TDSegmentedController(items: ["토덕", "일정", "루틴"])
    let todoViewController = ToduckViewController()
    
    // MARK: - Properties
    private var currentViewController: UIViewController?
    weak var coordinator: HomeCoordinator?

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = TDColor.baseWhite
        
        setupSegmentedControl()
        setupNavigationBar(style: .home, navigationDelegate: coordinator!)
        updateView()
    }

    // MARK: - Setup
    private func setupSegmentedControl() {
        view.addSubview(segmentedControl)

        segmentedControl.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalToSuperview().offset(16)
            $0.width.equalTo(180)
            $0.height.equalTo(44)
        }

        segmentedControl.addTarget(
            self,
            action: #selector(segmentChanged),
            for: .valueChanged
        )

        segmentedControl.selectedSegmentIndex = 0
    }

    // MARK: - Segment Change Handling
    @objc private func segmentChanged() {
        updateView()
    }

    private func updateView() {
        let newViewController: UIViewController
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            newViewController = todoViewController
        case 1:
            let viewModel = ScheduleViewModel()
            newViewController = ScheduleAndRoutineViewController(
                scheduleViewModel: viewModel,
                mode: .schedule
            )
            if let viewController = newViewController as? ScheduleAndRoutineViewController {
                viewController.coordinator = self
            }
        case 2:
            let viewModel = RoutineViewModel()
            newViewController = ScheduleAndRoutineViewController(
                routineViewModel: viewModel,
                mode: .routine
            )
            if let viewController = newViewController as? ScheduleAndRoutineViewController {
                viewController.coordinator = self
            }
        default:
            return
        }

        // 동일한 뷰 컨트롤러라면 작업 생략
        guard currentViewController !== newViewController else { return }

        // 이전 뷰 컨트롤러 제거
        currentViewController?.view.removeFromSuperview()
        currentViewController?.removeFromParent()

        // 새 뷰 컨트롤러 추가
        addChild(newViewController)
        view.addSubview(newViewController.view)

        newViewController.view.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }

        newViewController.didMove(toParent: self)
        currentViewController = newViewController
    }
}

extension HomeViewController: EventMakorDelegate {
    func didTapEventMakor() {
        coordinator?.didTapEventMakor()
    }
}
