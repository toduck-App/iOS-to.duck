import TDDesign
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
        setupNavigationBar(style: .home, navigationDelegate: coordinator!) {
            print("HomeViewController - setupNavigationBar")
        }
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
