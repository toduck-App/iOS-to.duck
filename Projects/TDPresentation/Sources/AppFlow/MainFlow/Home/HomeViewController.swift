import TDDesign
import TDDomain
import TDCore
import UIKit

final class HomeViewController: BaseViewController<BaseView> {
    private var coach: CoachMarkPresenter?

    // MARK: - UI Components
    let segmentedControl = TDSegmentedControl(items: ["토덕", "투두"])
    let dividedLine = UIView.dividedLine()
    
    // MARK: - Properties
    private var cachedViewControllers = [Int: UIViewController]()
    private var currentViewController: UIViewController?
    weak var coordinator: HomeCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !TDTokenManager.shared.isFirstLogin {
            TDTokenManager.shared.launchFirstLogin()
            showFirstLoginCoachMarks()
        }
    }
    
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
            let fetchRoutineUseCase = DIContainer.shared.resolve(FetchRoutineUseCase.self)
            let fetchWeeklyTodoListUseCase = DIContainer.shared.resolve(FetchWeeklyTodoListUseCase.self)
            let processDailyTodoListUseCase = DIContainer.shared.resolve(ProcessDailyTodoListUseCase.self)
            let removeTodoItemFromLocalDataUseCase = DIContainer.shared.resolve(RemoveTodoItemFromLocalDataUseCase.self)
            let finishScheduleUseCase = DIContainer.shared.resolve(FinishScheduleUseCase.self)
            let finishRoutineUseCase = DIContainer.shared.resolve(FinishRoutineUseCase.self)
            let deleteScheduleUseCase = DIContainer.shared.resolve(DeleteScheduleUseCase.self)
            let deleteRoutineAfterCurrentDayUseCase = DIContainer.shared.resolve(DeleteRoutineAfterCurrentDayUseCase.self)
            let deleteRoutineForCurrentDayUseCase = DIContainer.shared.resolve(DeleteRoutineForCurrentDayUseCase.self)
            let viewModel = TodoViewModel(
                createScheduleUseCase: createScheduleUseCase,
                createRoutineUseCase: createRoutineUseCase,
                fetchWeeklyTodoListUseCase: fetchWeeklyTodoListUseCase,
                processDailyTodoListUseCase: processDailyTodoListUseCase,
                fetchRoutineUseCase: fetchRoutineUseCase,
                finishScheduleUseCase: finishScheduleUseCase,
                finishRoutineUseCase: finishRoutineUseCase,
                deleteScheduleUseCase: deleteScheduleUseCase,
                deleteRoutineAfterCurrentDayUseCase: deleteRoutineAfterCurrentDayUseCase,
                deleteRoutineForCurrentDayUseCase: deleteRoutineForCurrentDayUseCase,
                removeTodoItemFromLocalDataUseCase: removeTodoItemFromLocalDataUseCase
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

extension HomeViewController {
    private func showFirstLoginCoachMarks() {
        guard
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let window = windowScene.windows.first(where: { $0.isKeyWindow })
        else { return }

        let presenter = CoachMarkPresenter(containerView: window)
        presenter.delegate = self
        presenter.nextTitle = "다음"
        presenter.doneTitle = "완료"
        presenter.skipTitle = "건너뛰기"
        presenter.allowBackgroundTapToAdvance = false
        self.coach = presenter
        let todoVC = self.getViewController(for: 1) as? TodoViewController
        let toduckVC = self.getViewController(for: 0) as? ToduckViewController

        let step1 = CoachStep(
            targetProvider: { [weak self] in self?.segmentedControl.segmentView(at: 0) },
            title: "토덕",
            icon: TDImage.Tomato.neutral,
            description: "지금 할 일을 일러스트로 확인해요!\n급한 일정부터 집중해서 수행할 수 있도록 도와줘요.",
            highlightTokens: ["급한 일정부터 집중"],
            preferredDirection: .down,
            onEnter: { [weak self] in
                toduckVC?.setCoachMarkData(true)
                self?.segmentedControl.setSelectedIndex(0)
                todoVC?.setCoachMarkData(true)
            }
        )

        let step2 = CoachStep(
            targetProvider: { [weak self] in self?.segmentedControl.segmentView(at: 1) },
            title: "투두",
            icon: TDImage.clockNeutral,
            description: "일정과 루틴을 시간 순으로 한 눈에 확인 하고,\n완료한 투두는 체크박스를 눌러 관리해요",
            highlightTokens: ["시간 순", "완료한 투두는 체크박스"],
            preferredDirection: .down,
            onEnter: { [weak self] in
                toduckVC?.setCoachMarkData(false)
                self?.segmentedControl.setSelectedIndex(1)
                todoVC?.setCoachMarkData(true)
            },
            allowBackgroundTapToAdvance: nil,
            centerImage: TDImage.CoachMark.step2,
            centerImageMaxWidth: UIScreen.main.bounds.width,
            centerImageYOffset: 60
        )


        let step3 = CoachStep(
            targetProvider: { [weak self] in (self?.cachedViewControllers[1] as? TodoViewController)?.floatingActionMenuView },
            title: "일정 추가",
            icon: TDImage.checkNeutral,
            iconSize: .init(width: 18, height: 18),
            description: "중요한 약속이나 업무 등, 날짜와 시간을 지정해 관리해야 할 일을 등록해요.",
            highlightTokens: ["날짜와 시간을 지정해 관리해야 할 일"],
            preferredDirection: .up,
            onEnter: {
                todoVC?.showFloatingMenuForCoachMark(menu: .schedule)
            },
            allowBackgroundTapToAdvance: false
        )

        let step4 = CoachStep(
            targetProvider: { [weak self] in (self?.cachedViewControllers[1] as? TodoViewController)?.floatingActionMenuView },
            title: "루틴 추가",
            icon: TDImage.cycleSmall,
            iconSize: .init(width: 18, height: 18),
            description: "작은 습관이나 반복되는 일상은 루틴으로 등록해요.\n⚠️ 루틴은 캘린더에 나타나지 않아요",
            highlightTokens: ["작은 습관", "반복되는 일상"],
            preferredDirection: .up,
            onEnter: {
                todoVC?.showFloatingMenuForCoachMark(menu: .routine)
            },
            allowBackgroundTapToAdvance: false
        )

        presenter.start(steps: [step1, step2, step3, step4])
    }

}
extension HomeViewController: CoachMarkPresenterDelegate {
    func coachMarkDidFinish(_ presenter: CoachMarkPresenter, skipped: Bool) {
        self.coach = nil
        (cachedViewControllers[1] as? TodoViewController)?.unlockFloatingMenuForCoachMark()
    }

    func coachMarkDidMove(_ presenter: CoachMarkPresenter, to index: Int) {
        // MARK: 더미 데이터 넣어주는 용도
        
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
