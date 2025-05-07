import TDDesign
import TDDomain
import TDCore
import UIKit

final class HomeViewController: BaseViewController<BaseView> {
    // MARK: - UI Components
    private let segmentedControl = TDSegmentedControl(items: ["토덕", "투두"])
    
    // MARK: - Properties
    private var cachedViewControllers = [Int: UIViewController]()
    private var currentViewController: UIViewController?
    weak var coordinator: HomeCoordinator?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateNavigationBarColor(for: segmentedControl.selectedIndex)
    }
    
    // MARK: - Base Methods
    override func configure() {
        view.backgroundColor = TDColor.baseWhite
        setupSegmentedControl()
        setupNavigationBar()
        updateView()
    }
    
    // MARK: - Setup Methods
    private func setupSegmentedControl() {
        view.addSubview(segmentedControl)
        
        segmentedControl.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalToSuperview().offset(LayoutConstants.segmentedControlLeadingOffset)
            $0.width.equalTo(LayoutConstants.segmentedControlWidth)
            $0.height.equalTo(LayoutConstants.segmentedControlHeight)
        }
        
        segmentedControl.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            
            let selectedIndex = self.segmentedControl.selectedIndex
            let currentIndex = self.cachedViewControllers.first(where: { $0.value === self.currentViewController })?.key
            
            if selectedIndex == currentIndex {
                if let todoVC = self.currentViewController as? TodoViewController {
                    todoVC.updateWeekCalendarForDate(at: Date())
                }
            } else {
                self.updateView()
            }
        }, for: .valueChanged)
    }
    
    private func setupNavigationBar() {
        // 좌측 네비게이션 바 버튼 설정 (캘린더 + 로고)
        let calendarButton = UIButton(type: .custom)
        calendarButton.setImage(TDImage.Calendar.top2Medium, for: .normal)
        calendarButton.addAction(UIAction { [weak self] _ in
            self?.coordinator?.didTapCalendarButton()
        }, for: .touchUpInside)
        
        let toduckLogoImageView = UIImageView(image: TDImage.toduckLogo)
        toduckLogoImageView.contentMode = .scaleAspectFit
        
        let leftBarButtonItems = [
            UIBarButtonItem(customView: calendarButton),
            UIBarButtonItem(customView: toduckLogoImageView)
        ]
        
        navigationItem.leftBarButtonItems = leftBarButtonItems
        
        // 우측 네비게이션 바 버튼 설정 (알림)
        let alarmButton = UIButton(type: .custom)
        alarmButton.setImage(TDImage.Bell.topOffMedium, for: .normal)
        alarmButton.addAction(UIAction { [weak self] _ in
            self?.coordinator?.didTapAlarmButton()
            TDLogger.debug("홈 화면 네비게이션 우측 알람 버튼 클릭")
        }, for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: alarmButton)
    }
    
    // MARK: - View Update
    private func updateView() {
        let newViewController = getViewController(for: segmentedControl.selectedIndex)
        guard currentViewController !== newViewController else { return }
        
        updateNavigationBarColor(for: segmentedControl.selectedIndex)
        replaceCurrentViewController(with: newViewController)
    }
    
    private func updateNavigationBarColor(for index: Int) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        if index == 0 {
            let color = TDColor.Neutral.neutral50
            appearance.backgroundColor = color
            appearance.shadowColor = .clear
            navigationController?.navigationBar.tintColor = TDColor.Neutral.neutral900

            view.backgroundColor = color
            segmentedControl.tintColor = color
            segmentedControl.updateIndicatorColor(
                foreground: TDColor.Neutral.neutral800,
                background: color
            )
        } else {
            let color = TDColor.baseWhite
            appearance.backgroundColor = color
            appearance.shadowColor = .clear
            navigationController?.navigationBar.tintColor = TDColor.Neutral.neutral900

            view.backgroundColor = color
            segmentedControl.tintColor = color
            segmentedControl.updateIndicatorColor(
                foreground: TDColor.Neutral.neutral800,
                background: color
            )
        }

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
    }
    
    private func getViewController(for index: Int) -> UIViewController {
        if let cachedVC = cachedViewControllers[index] {
            return cachedVC
        }

        let newViewController: UIViewController
        let fetchScheduleListUseCase = DIContainer.shared.resolve(FetchScheduleListUseCase.self)
        switch index {
        case 0:
            let shouldMarkAllDayUseCase = DIContainer.shared.resolve(ShouldMarkAllDayUseCase.self)
            let viewModel = ToduckViewModel(
                fetchScheduleListUseCase: fetchScheduleListUseCase,
                shouldMarkAllDayUseCase: shouldMarkAllDayUseCase
            )
            let toduckViewController = ToduckViewController(viewModel: viewModel)
            toduckViewController.delegate = self
            newViewController = toduckViewController
        case 1:
            let createScheduleUseCase = DIContainer.shared.resolve(CreateScheduleUseCase.self)
            let createRoutineUseCase = DIContainer.shared.resolve(CreateRoutineUseCase.self)
            let fetchRoutineListForDatesUseCase = DIContainer.shared.resolve(FetchRoutineListForDatesUseCase.self)
            let fetchRoutineUseCase = DIContainer.shared.resolve(FetchRoutineUseCase.self)
            let finishScheduleUseCase = DIContainer.shared.resolve(FinishScheduleUseCase.self)
            let finishRoutineUseCase = DIContainer.shared.resolve(FinishRoutineUseCase.self)
            let deleteScheduleUseCase = DIContainer.shared.resolve(DeleteScheduleUseCase.self)
            let deleteRoutineAfterCurrentDayUseCase = DIContainer.shared.resolve(DeleteRoutineAfterCurrentDayUseCase.self)
            let deleteRoutineForCurrentDayUseCase = DIContainer.shared.resolve(DeleteRoutineForCurrentDayUseCase.self)
            let viewModel = TodoViewModel(
                createScheduleUseCase: createScheduleUseCase,
                createRoutineUseCase: createRoutineUseCase,
                fetchScheduleListUseCase: fetchScheduleListUseCase,
                fetchRoutineListForDatesUseCase: fetchRoutineListForDatesUseCase,
                fetchRoutineUseCase: fetchRoutineUseCase,
                finishScheduleUseCase: finishScheduleUseCase,
                finishRoutineUseCase: finishRoutineUseCase,
                deleteScheduleUseCase: deleteScheduleUseCase,
                deleteRoutineAfterCurrentDayUseCase: deleteRoutineAfterCurrentDayUseCase,
                deleteRoutineForCurrentDayUseCase: deleteRoutineForCurrentDayUseCase
            )
            let todoViewController = TodoViewController(viewModel: viewModel)
            todoViewController.delegate = coordinator
            newViewController = todoViewController
        default:
            newViewController = UIViewController()
        }

        cachedViewControllers[index] = newViewController
        return newViewController
    }
    
    private func replaceCurrentViewController(with newViewController: UIViewController) {
        // 기존 뷰 컨트롤러 제거
        currentViewController?.view.removeFromSuperview()
        currentViewController?.removeFromParent()
        
        // 새 뷰 컨트롤러 추가
        addChild(newViewController)
        view.addSubview(newViewController.view)
        
        newViewController.view.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        newViewController.didMove(toParent: self)
        currentViewController = newViewController
    }
    
    func resetToToduck() {
        segmentedControl.setSelectedIndex(0)
        updateView()
    }
}

// MARK: - EventMakorDelegate
extension HomeViewController: TodoViewControllerDelegate {
    func didTapEventMakor(
        mode: TodoCreatorViewController.Mode,
        selectedDate: Date?,
        preEvent: (any TodoItem)?,
        delegate: TodoCreatorCoordinatorDelegate?
    ) {
        guard let selectedDate else { return }
        coordinator?.didTapEventMakor(mode: mode, selectedDate: selectedDate, preEvent: preEvent, delegate: delegate)
    }
}

extension HomeViewController: ToduckViewDelegate {
    func didTapNoScheduleContainerView() {
        segmentedControl.setSelectedIndex(1)
        updateView()
    }
}

// MARK: - Layout Constants
private extension HomeViewController {
    enum LayoutConstants {
        static let segmentedControlLeadingOffset: CGFloat = 16
        static let segmentedControlWidth: CGFloat = 120
        static let segmentedControlHeight: CGFloat = 44
    }
}
