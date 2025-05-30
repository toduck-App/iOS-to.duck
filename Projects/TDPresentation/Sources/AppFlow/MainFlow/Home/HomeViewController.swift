import TDDesign
import TDDomain
import TDCore
import UIKit

final class HomeViewController: BaseViewController<BaseView> {
    // MARK: - UI Components
    let segmentedControl = TDSegmentedControl(items: ["토덕", "투두"])
    let dividedLine = UIView.dividedLine()
    
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
        dividedLine.backgroundColor = TDColor.Neutral.neutral200
        setupSegmentedControl()
        setupNavigationBar()
        setupSwipeGestures()
        setupNotification()
        updateView()
    }
    
    // MARK: - Setup Methods
    private func setupSegmentedControl() {
        view.addSubview(segmentedControl)
        view.addSubview(dividedLine)
        
        segmentedControl.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalToSuperview().offset(LayoutConstants.segmentedControlLeadingOffset)
            $0.width.equalTo(LayoutConstants.segmentedControlWidth)
            $0.height.equalTo(LayoutConstants.segmentedControlHeight)
        }
        
        dividedLine.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
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
        }, for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: alarmButton)
    }
    
    private func setupSwipeGestures() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeft.direction = .left
        swipeLeft.delegate = self
        view.addGestureRecognizer(swipeLeft)

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeRight.direction = .right
        swipeRight.delegate = self
        view.addGestureRecognizer(swipeRight)
    }

    @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        let currentIndex = segmentedControl.selectedIndex

        switch gesture.direction {
        case .left:
            if currentIndex < 1 {
                segmentedControl.setSelectedIndex(currentIndex + 1)
                updateView()
            }
        case .right:
            if currentIndex > 0 {
                segmentedControl.setSelectedIndex(currentIndex - 1)
                updateView()
            }
        default:
            break
        }
    }
    
    private func setupNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleCellSwipeForSegment),
            name: .didSwipeCellToSegmentLeft,
            object: nil
        )
    }
    
    @objc
    private func handleCellSwipeForSegment() {
        segmentedControl.setSelectedIndex(0)
        updateView()
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
            $0.top.equalTo(dividedLine.snp.bottom)
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

// MARK: - UIGestureRecognizerDelegate
extension HomeViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let view = touch.view, view is UIControl {
            return false
        }
        
        let tableView = (cachedViewControllers[1] as? TodoViewController)?
            .todoTableView
        let locationInTable = touch.location(in: tableView)
        if let tableView = tableView, tableView.bounds.contains(locationInTable) {
            if tableView.indexPathForRow(at: locationInTable) == nil {
                return true
            }
            return false
        }
        
        var current: UIView? = touch.view
        while let view = current {
            if view is UIScrollView {
                return false
            }
            current = view.superview
        }
        return true
    }
}

// MARK: - EventMakorDelegate
extension HomeViewController: TodoViewControllerDelegate {
    func didTapTodoMakor(
        mode: TDTodoMode,
        selectedDate: Date?,
        preTodo: (any TodoItem)?,
        delegate: TodoCreatorCoordinatorDelegate?
    ) {
        guard let selectedDate else { return }
        coordinator?.didTapTodoMakor(
            mode: mode,
            selectedDate: selectedDate,
            preTodo: preTodo,
            delegate: delegate
        )
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
