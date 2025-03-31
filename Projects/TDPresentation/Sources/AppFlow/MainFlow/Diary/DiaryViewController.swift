import UIKit
import Combine
import FSCalendar
import SnapKit
import TDCore
import TDDomain
import TDDesign

final class DiaryViewController: BaseViewController<BaseView> {
    
    // MARK: - UI Components
    
    let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.alwaysBounceVertical = true
        $0.delegate = nil
    }
    
    private let contentView = UIView()
    
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 24
        $0.alignment = .fill
        $0.distribution = .fill
    }
    
    /// 분석 뷰
    let analyzeView = DiaryAnalyzeView(diaryCount: 25, focusPercent: 55)
    
    let diaryContentContainerView = UIView()
    /// 세그먼트 컨트롤 (기분 / 집중도)
    let diarySegmentedControl = TDSegmentedControl(items: ["기분", "집중도"])
    
    /// 일기 및 집중도 캘린더를 전환하는 컨테이너
    private let calendarSwitchContainerView = UIView()
    
    private let diaryPostButtonContainerView = UIView().then {
        $0.backgroundColor = TDColor.Neutral.neutral50
        $0.layer.masksToBounds = false
    }
    private let diaryPostButton = TDBaseButton(
        title: "일기 작성",
        backgroundColor: TDColor.Primary.primary500,
        foregroundColor: TDColor.baseWhite,
        font: TDFont.boldHeader3.font,
        radius: 12
    )
    
    
    // MARK: - Properties
    
    enum CalendarType {
        case diary, focus
    }
    
    weak var coordinator: DiaryCoordinator?
    
    private let viewModel: DiaryViewModel
    private let input = PassthroughSubject<DiaryViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    private var selectedDate = Date().normalized
    private var cachedViewControllers = [Int: UIViewController]()
    private var currentViewController: UIViewController?
    
    
    // MARK: - Initializer
    
    init(viewModel: DiaryViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        input.send(.fetchUserNickname)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavigationAppearance()
    }
    
    
    // MARK: - View Setup
    
    override func addView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        contentView.addSubview(diaryPostButtonContainerView)
        
        stackView.addArrangedSubview(analyzeView)
        stackView.addArrangedSubview(diaryContentContainerView)
        diaryContentContainerView.addSubview(diarySegmentedControl)
        diaryContentContainerView.addSubview(calendarSwitchContainerView)
        diaryPostButtonContainerView.addSubview(diaryPostButton)
    }
    
    override func layout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        analyzeView.snp.makeConstraints {
            $0.height.equalTo(230)
        }
        
        diaryContentContainerView.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(900)
        }
        
        diarySegmentedControl.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.width.equalTo(130)
        }
        
        calendarSwitchContainerView.snp.makeConstraints {
            $0.top.equalTo(diarySegmentedControl.snp.bottom).offset(16)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        diaryPostButtonContainerView.snp.makeConstraints {
           
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(112)
        }
        
        diaryPostButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(28)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().offset(-28)
        }
    }
    
    override func binding() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .fetchedUserNickname(let nickname):
                    self?.analyzeView.configure(nickname: nickname)
                case .failureAPI(let message):
                    self?.showErrorAlert(with: message)
                }
            }
            .store(in: &cancellables)
    }
    
    override func configure() {
        diaryContentContainerView.backgroundColor = TDColor.baseWhite
        calendarSwitchContainerView.backgroundColor = TDColor.baseWhite
        setupNavigationBar()
        setupActions()
        updateView()
        scrollView.delegate = self
    }
    
    
    // MARK: - View Update
    
    private func updateView() {
        let newViewController = getViewController(for: diarySegmentedControl.selectedIndex)
        guard currentViewController !== newViewController else { return }
        replaceCurrentViewController(with: newViewController)
        if diarySegmentedControl.selectedIndex == 1 {
            diaryPostButtonContainerView.isHidden = true
        } else {
            diaryPostButtonContainerView.isHidden = false
        }
    }
    
    private func getViewController(for index: Int) -> UIViewController {
        if let cachedVC = cachedViewControllers[index] {
            return cachedVC
        }
        
        let newViewController: UIViewController
        
        switch index {
        case 0:
            let fetchUserNicknameUseCase = DIContainer.shared.resolve(FetchUserNicknameUseCase.self)
            let viewModel = DiaryCalendarViewModel(fetchUserNicknameUseCase: fetchUserNicknameUseCase)
            let diaryCalendarViewController = DiaryCalendarViewController(viewModel: viewModel)
            newViewController = diaryCalendarViewController
            
        case 1:
            newViewController = FocusCalendarViewController()
            
        default:
            newViewController = UIViewController()
        }
        
        cachedViewControllers[index] = newViewController
        return newViewController
    }
    
    private func replaceCurrentViewController(with newViewController: UIViewController) {
        currentViewController?.view.removeFromSuperview()
        currentViewController?.removeFromParent()
        
        addChild(newViewController)
        calendarSwitchContainerView.addSubview(newViewController.view)
        
        newViewController.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        newViewController.didMove(toParent: self)
        currentViewController = newViewController
    }
    
    
    // MARK: - Setup
    
    private func setupNavigationBar() {
        // 좌측 네비게이션 바 버튼 설정 (캘린더 + 로고)
        let calendarButton = UIButton(type: .custom)
        calendarButton.setImage(TDImage.Calendar.top2Medium, for: .normal)
        calendarButton.addAction(UIAction { [weak self] _ in
            self?.coordinator?.didTapCalendarButton()
        }, for: .touchUpInside)
        
        let toduckLogoImageView = UIImageView(image: TDImage.toduckLogo)
        toduckLogoImageView.contentMode = .scaleAspectFit
        
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(customView: calendarButton),
            UIBarButtonItem(customView: toduckLogoImageView)
        ]
        
        // 우측 네비게이션 바 버튼 설정 (알람 버튼)
        let alarmButton = UIButton(type: .custom)
        alarmButton.setImage(TDImage.Bell.topOffMedium, for: .normal)
        alarmButton.addAction(UIAction { [weak self] _ in
            TDLogger.debug("DiaryViewController - 알람 버튼 클릭")
            self?.coordinator?.didTapAlarmButton()
        }, for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: alarmButton)
    }
    
    private func setupNavigationAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = TDColor.Neutral.neutral50
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.shadowColor = .clear
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func setupActions() {
        diarySegmentedControl.addAction(UIAction { [weak self] _ in
            self?.updateView()
        }, for: .valueChanged)
        
        diaryPostButton.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            coordinator?.didTapCreateDiaryButton(selectedDate: selectedDate)
        }, for: .touchUpInside)
    }
}

// MARK: - UIScrollViewDelegate
extension DiaryViewController: UIScrollViewDelegate {
    /// Scroll 감지하여 버튼 배경색 변경
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard diarySegmentedControl.selectedIndex == 0,
              let diaryCalendarVC = currentViewController as? DiaryCalendarViewController,
              let calendarContainerView = diaryCalendarVC.calendarContainerView.superview else { return }

        let calendarFrame = calendarContainerView.convert(diaryCalendarVC.calendarContainerView.frame, to: view)

        if calendarFrame.maxY <= diaryPostButtonContainerView.frame.minY {
            diaryPostButtonContainerView.backgroundColor = .clear
        } else {
            diaryPostButtonContainerView.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        }
    }
}
