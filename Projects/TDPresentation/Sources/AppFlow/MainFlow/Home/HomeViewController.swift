import TDDesign
import TDCore
import UIKit

final class HomeViewController: BaseViewController<BaseView> {
    // MARK: - UI Components
    private let segmentedControl = TDSegmentedControl(items: ["토덕", "일정", "루틴"])
    private let todoViewController = ToduckViewController()
    
    // MARK: - Properties
    private var currentViewController: UIViewController?
    weak var coordinator: HomeCoordinator?
    
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
            self?.updateView()
        }, for: .valueChanged)
        
        segmentedControl.selectedSegmentIndex = 0
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
        let newViewController = getViewController(for: segmentedControl.selectedSegmentIndex)
        guard currentViewController !== newViewController else { return }
        
        replaceCurrentViewController(with: newViewController)
    }
    
    private func getViewController(for index: Int) -> UIViewController {
        switch index {
        case 0:
            return todoViewController
        case 1:
            let viewModel = ScheduleViewModel()
            return createScheduleAndRoutineViewController(viewModel: viewModel, mode: .schedule)
        case 2:
            let viewModel = RoutineViewModel()
            return createScheduleAndRoutineViewController(viewModel: viewModel, mode: .routine)
        default:
            return UIViewController()
        }
    }
    
    private func createScheduleAndRoutineViewController(viewModel: Any, mode: ScheduleAndRoutineViewController.Mode) -> ScheduleAndRoutineViewController {
        let viewController = (mode == .schedule)
            ? ScheduleAndRoutineViewController(scheduleViewModel: viewModel as? ScheduleViewModel, mode: mode)
            : ScheduleAndRoutineViewController(routineViewModel: viewModel as? RoutineViewModel, mode: mode)
        
        viewController.coordinator = self
        return viewController
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
}

// MARK: - EventMakorDelegate
extension HomeViewController: EventMakorDelegate {
    func didTapEventMakor(mode: ScheduleAndRoutineViewController.Mode) {
        coordinator?.didTapEventMakor(mode: mode)
    }
}

// MARK: - Layout Constants
private extension HomeViewController {
    enum LayoutConstants {
        static let segmentedControlLeadingOffset: CGFloat = 16
        static let segmentedControlWidth: CGFloat = 180
        static let segmentedControlHeight: CGFloat = 44
    }
}
