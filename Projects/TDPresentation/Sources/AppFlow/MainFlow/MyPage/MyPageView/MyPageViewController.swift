import Combine
import TDCore
import TDDesign
import UIKit

final class MyPageViewController: BaseViewController<MyPageView> {
    private let viewModel: MyPageViewModel
    private let input = PassthroughSubject<MyPageViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    weak var coordinator: MyPageCoordinator?

    private let menuSections: [MenuSection] = [
        MenuSection(
            header: "계정 관리",
            items: [
                .notificationSettings,
                .postManagement,
                .myComments,
                .blockManagement
            ]
        ),
        MenuSection(
            header: "서비스 약관",
            items: [
                .termsOfUse,
                .privacyPolicy
            ]
        )
    ]

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
        input.send(.fetchUserDetail)
        input.send(.fetchUserNickname)
    }

    // MARK: - Common Methods

    override func configure() {
        view.backgroundColor = .white
        layoutView.socialButtonView.delegate = self
        setupNavigationBar()

        layoutView.logoutButton.addAction(UIAction { [weak self] _ in
            self?.showCommonAlert(
                message: "로그아웃 하시겠어요?",
                image: TDImage.Mood.sad,
                cancelTitle: "취소",
                confirmTitle: "확인",
                onConfirm: {
                    self?.input.send(.logout)
                }
            )
        }, for: .touchUpInside)

        layoutView.deleteAccountButton.addAction(UIAction { [weak self] _ in
            self?.coordinator?.didTapWithdrawButton()
        }, for: .touchUpInside)

        layoutView.setMenuSections(menuSections)

        layoutView.didSelectMenuItem = { [weak self] menu in
            guard let self else { return }
            switch menu {
            case .notificationSettings:
                coordinator?.didTapNotificationSettings()
            case .postManagement:
                coordinator?.didTapPostManagement()
            case .myComments:
                coordinator?.didTapMyComments()
            case .blockManagement:
                coordinator?.didTapBlockManagement()
            case .termsOfUse:
                coordinator?.didTapTermsOfUse()
            case .privacyPolicy:
                coordinator?.didTapPrivacyPolicy()
            }
        }
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
                    self?.coordinator?.didTapLogoutButton()
                case .fetchedUserDetail(let user, let userDetail):
                    let followingCount = userDetail.followingCount
                    let followerCount = userDetail.followerCount
                    let postCount = userDetail.totalPostCount
                    self?.layoutView.profileView.configure(
                        profileImage: user.icon,
                        followingCount: followingCount,
                        followerCount: followerCount,
                        postCount: postCount
                    )
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
                if let nickName = viewModel.nickName {
                    coordinator?.didTapProfileButton(nickName: nickName)
                }
            }
        }
    }
}

extension MyPageViewController: UICollectionViewDelegate {}

extension MyPageViewController: MyPageSocialButtonDelegate {
    func didTapProfileButton() {
        if let nickName = viewModel.nickName {
            coordinator?.didTapProfileButton(nickName: nickName)
        }
    }

    func didTapShareButton() {
        coordinator?.didTapShareProfile()
    }
}

struct MenuSection {
    let header: String
    let items: [MenuItem]
}

enum MenuItem {
    case notificationSettings
    case postManagement
    case myComments
    case blockManagement
    case termsOfUse
    case privacyPolicy

    var title: String {
        switch self {
        case .notificationSettings: "알림 설정"
        case .postManagement: "작성 글 관리"
        case .myComments: "나의 댓글"
        case .blockManagement: "차단 관리"
        case .termsOfUse: "이용 약관"
        case .privacyPolicy: "개인정보 처리방침"
        }
    }
}
