import Combine
import TDCore
import TDDesign
import UIKit

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
        input.send(.fetchUserDetail)
        input.send(.fetchUserNickname)
    }

    // MARK: - Common Methods

    override func configure() {
        view.backgroundColor = .white
        layoutView.socialButtonView.delegate = self
        setupNavigationBar()

        layoutView.logoutButton.addAction(UIAction { [weak self] _ in
            self?.input.send(.logout)
        }, for: .touchUpInside)

        layoutView.deleteAccountButton.addAction(UIAction { [weak self] _ in
            self?.coordinator?.didTapWithdrawButton()
        }, for: .touchUpInside)

        layoutView.didSelectMenuItem = { [weak self] indexPath in
            guard let self else { return }
            switch (indexPath.section, indexPath.item) {
            // 계정 관리
            case (0, 0):
                print("알림 설정")
//                coordinator?.didTapNotificationSettings() // ex. 알림 설정
            case (0, 1):
                print("작성 글 관리")
//                coordinator?.didTapPostManagement() // 작성 글 관리
            case (0, 2):
                print("나의 댓글")
//                coordinator?.didTapMyComments() // 나의 댓글
            case (0, 3):
                print("차단 관리")
//                coordinator?.didTapBlockManagement() // 차단 관리
            // 고객 센터
            case (1, 0):
                print("문의 하기")
//                coordinator?.didTapAskSupport() // 문의 하기
            case (1, 1):
                print("문의 내역")
//                coordinator?.didTapInquiryHistory() // 문의 내역
            case (1, 2):
                print("공지사항")
//                coordinator?.didTapNotice() // 공지사항
            case (1, 3):
                print("사용 가이드")
//                coordinator?.didTapUserGuide() // 사용 가이드
            // 서비스 약관
            case (2, 0):
                print("서비스 약관")
            //                coordinator?.didTapTermsOfUse() // 이용 약관
            case (2, 1):
                print("개인정보 처리 방침")
//                coordinator?.didTapPrivacyPolicy() // 개인정보 처리방침
            default:
                break
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
                    self?.coordinator?.didTapLogoutButton() // TODO: 로그인 화면으로 이동
                case .fetchedUserDetail(let userDetail):
                    let followingCount = userDetail.followingCount
                    let followerCount = userDetail.followerCount
                    let postCount = userDetail.totalPostCount
                    self?.layoutView.profileView.configure(followingCount: followingCount, followerCount: followerCount, postCount: postCount)
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

extension MyPageViewController: UICollectionViewDelegate {}

extension MyPageViewController: MyPageSocialButtonDelegate {
    func didTapProfileButton() {
        coordinator?.didTapProfileButton()
    }

    func didTapShareButton() {
        guard let userId = TDTokenManager.shared.userId else { return }
        let icon = TDImage.appIcon
        let profileURL = URL(string: "toduck://profile?userId=\(userId)")!
        let shareItem = ProfileShareItem(
            url: profileURL,
            title: "Toduck에서 나의 프로필을 확인하세요!",
            icon: icon
        )

        let activityVC = UIActivityViewController(
            activityItems: [shareItem],
            applicationActivities: nil
        )

        if let popover = activityVC.popoverPresentationController {
            popover.sourceView = layoutView.socialButtonView
        }
        present(activityVC, animated: true)
    }
}
