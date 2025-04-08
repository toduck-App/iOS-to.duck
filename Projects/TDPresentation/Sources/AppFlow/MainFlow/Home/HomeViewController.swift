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
        if index == 0 {
            navigationController?.navigationBar.barTintColor = TDColor.Neutral.neutral50
            navigationController?.navigationBar.backgroundColor = TDColor.Neutral.neutral50
            view.backgroundColor = TDColor.Neutral.neutral50
            segmentedControl.tintColor = TDColor.Neutral.neutral50
            segmentedControl.updateIndicatorColor(
                foreground: TDColor.Neutral.neutral800,
                background: TDColor.Neutral.neutral50
            )
        } else {
            navigationController?.navigationBar.barTintColor = TDColor.baseWhite
            navigationController?.navigationBar.backgroundColor = TDColor.baseWhite
            view.backgroundColor = TDColor.baseWhite
            segmentedControl.tintColor = TDColor.baseWhite
            
            segmentedControl.updateIndicatorColor(
                foreground: TDColor.Neutral.neutral800,
                background: TDColor.baseWhite
            )
        }
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
            let viewModel = TodoViewModel(fetchScheduleListUseCase: fetchScheduleListUseCase)
            let todoViewController = TodoViewController(viewModel: viewModel)
            todoViewController.coordinator = coordinator
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
}

// MARK: - EventMakorDelegate
extension HomeViewController: EventMakorDelegate {
    func didTapEventMakor(mode: EventMakorViewController.Mode, selectedDate: Date?) {
        guard let selectedDate else { return }
        coordinator?.didTapEventMakor(mode: mode, selectedDate: selectedDate)
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
