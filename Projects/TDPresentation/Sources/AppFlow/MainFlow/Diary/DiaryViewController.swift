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
    
    /// 세그먼트 컨트롤 (기분 / 집중도)
    let diarySegmentedControl = TDSegmentedControl(items: ["기분", "집중도"])
    
    /// 일기 및 집중도 캘린더를 전환하는 컨테이너
    private let calendarSwitchContainerView = UIView()
    private let diaryCalendarViewController = DiaryCalendarViewController(viewModel: DiaryCalendarViewModel(fetchUserNicknameUseCase: DIContainer.shared.resolve(FetchUserNicknameUseCase.self)))
    private let focusCalendarViewController = FocusCalendarViewController() // 구현되어 있다고 가정
    
    
    // MARK: - Properties
    enum CalendarType {
        case diary, focus
    }
    weak var coordinator: DiaryCoordinator?
    private let viewModel: DiaryViewModel
    private let input = PassthroughSubject<DiaryViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    private var selectedDate = Date().normalized
    
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
        
        setupSegmentedControl()
        switchCalendar(to: .diary)
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

        stackView.addArrangedSubview(analyzeView)
        stackView.addArrangedSubview(diarySegmentedControl)
        stackView.addArrangedSubview(calendarSwitchContainerView)
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
        diarySegmentedControl.snp.makeConstraints {
            $0.height.equalTo(48)
        }
        calendarSwitchContainerView.snp.makeConstraints {
            $0.height.equalTo(456 + 300)
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
            }.store(in: &cancellables)
    }

    override func configure() {
        setupNavigationBar()

    }

    private func switchCalendar(to type: CalendarType) {
        children.forEach { $0.removeFromParent(); $0.view.removeFromSuperview() }

        let selectedVC: BaseViewController = (type == .diary) ? diaryCalendarViewController : focusCalendarViewController

        addChild(selectedVC)
        calendarSwitchContainerView.addSubview(selectedVC.view)
        selectedVC.view.snp.makeConstraints { $0.edges.equalToSuperview() }
        selectedVC.didMove(toParent: self)
    }

    private func setupSegmentedControl() {
        diarySegmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
    }

    @objc private func segmentedControlValueChanged(_ sender: TDSegmentedControl) {
        let selectedType: CalendarType = sender.selectedIndex == 0 ? .diary : .focus
        switchCalendar(to: selectedType)
    }
    
    // MARK: - 네비게이션 바 설정
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
 }
