import UIKit
import Combine
import TDDesign
import TDCore

final class MyPageViewController: BaseViewController<MyPageView> {
    private let viewModel: MyPageViewModel
    private let input = PassthroughSubject<MyPageViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    weak var coordinator: MyPageCoordinator?
    
    // MARK: - Initialize
    init(
        viewModel: MyPageViewModel
    ) {
        self.viewModel = viewModel
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        input.send(.fetchUserNickname)
    }
    
    // MARK: - Common Methods
    override func configure() {
        view.backgroundColor = .white
        setupNavigationBar()
        
        layoutView.logoutButton.addAction(UIAction { [weak self] _ in
            self?.input.send(.logout)
        }, for: .touchUpInside)
        
        layoutView.deleteAccountButton.addAction(UIAction { [weak self] _ in
            self?.coordinator?.didTapWithdrawButton()
        }, for: .touchUpInside)
    }
    
    override func binding() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .fetchedUserNickname(let nickname):
                    self?.layoutView.profileView.usernameLabel.setText(nickname)
                case .failureAPI(let message):
                    self?.showErrorAlert(errorMessage: message)
                case .logoutFinished:
                    self?.coordinator?.didTapLogoutButton() // TODO: 로그인 화면으로 이동
                }
            }.store(in: &cancellables)
    }
    
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.shadowColor = nil

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        if #available(iOS 15.0, *) {
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
        
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
        
        // 우측 네비게이션 바 버튼 설정 (알림 버튼)
        let alarmButton = UIButton(type: .custom)
        alarmButton.setImage(TDImage.Bell.topOffMedium, for: .normal)
        alarmButton.addAction(UIAction { _ in
            TDLogger.debug("MyPageViewController - 알람 버튼 클릭")
        }, for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: alarmButton)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        if let responderEvent = event as? CustomEventWrapper {
            if responderEvent.customType == .profileImageTapped {
                coordinator?.didTapProfileButton()
            }
        }
    }
}
