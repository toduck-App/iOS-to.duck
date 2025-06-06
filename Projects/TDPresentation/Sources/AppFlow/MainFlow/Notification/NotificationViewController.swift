import TDDesign
import TDCore
import Combine
import UIKit
import Kingfisher

final class NotificationViewController: BaseViewController<BaseView> {
    // MARK: - UI Components
    private let notificationTableView = UITableView()
    private let noAlarmContainerView = UIView()
    private let noAlarmImageView = UIImageView(image: TDImage.noEvent)
    private let noAlarmLabel = TDLabel(
        labelText: "도착한 알림이 없어요",
        toduckFont: .boldBody1,
        toduckColor: TDColor.Neutral.neutral600
    )
    private let refreshControl = UIRefreshControl()
    
    // MARK: - Properties
    private let viewModel: NotificationViewModel
    private let input = PassthroughSubject<NotificationViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    weak var coordinator: NotificationCoordinator?
    
    // MARK: - Initializer
    init(
        viewModel: NotificationViewModel
    ) {
        self.viewModel = viewModel
        super.init()
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadNotifications()
    }
    
    // MARK: - Common Methods
    override func addView() {
        layoutView.addSubview(notificationTableView)
        layoutView.addSubview(noAlarmContainerView)
        noAlarmContainerView.addSubview(noAlarmImageView)
        noAlarmContainerView.addSubview(noAlarmLabel)
    }
    
    override func layout() {
        notificationTableView.snp.makeConstraints { make in
            make.edges.equalTo(layoutView.safeAreaLayoutGuide)
        }
        
        noAlarmContainerView.snp.makeConstraints { make in
            make.top.equalTo(layoutView.safeAreaLayoutGuide.snp.top).offset(56)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(152)
        }
        noAlarmImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(96)
        }
        noAlarmLabel.snp.makeConstraints { make in
            make.top.equalTo(noAlarmImageView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
    }
    
    override func binding() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self else { return }
                switch event {
                case .fetchedNotificationList:
                    notificationTableView.reloadData()
                    noAlarmContainerView.isHidden = !viewModel.notifications.isEmpty
                    refreshControl.endRefreshing()
                case .successUserFollowToggle:
                    notificationTableView.reloadData()
                case .failure(let message):
                    showErrorAlert(errorMessage: message)
                }
            }.store(in: &cancellables)
    }
    
    override func configure() {
        setupNavigationBar()
        setupNotificationTableView()
        setupRefreshControl()
    }
    
    private func setupNavigationBar() {
        navigationController?.setupNestedNavigationBar(
            leftButtonTitle: "",
            leftButtonAction: UIAction { [weak self] _ in
                self?.coordinator?.finish(by: .pop)
            }
        )
    }
    
    private func setupNotificationTableView() {
        notificationTableView.delegate = self
        notificationTableView.dataSource = self
        notificationTableView.register(
            NotificationCell.self,
            forCellReuseIdentifier: NotificationCell.identifier
        )
        notificationTableView.backgroundColor = .clear
        notificationTableView.separatorStyle = .none
        notificationTableView.showsVerticalScrollIndicator = false
    }
    
    private func setupRefreshControl() {
        notificationTableView.refreshControl = refreshControl
        refreshControl.addTarget(
            self,
            action: #selector(refreshNotificationList),
            for: .valueChanged
        )
    }
    
    @objc
    private func refreshNotificationList() {
        loadNotifications()
    }
    
    private func loadNotifications() {
        input.send(.fetchNotificationList(page: 0, size: 20))
        input.send(.readAllNotifications)
    }
}

extension NotificationViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        let notification = viewModel.notifications[indexPath.row]
        coordinator?.didSelectNotification(notification)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height

        if offsetY > contentHeight - frameHeight - 200 {
            guard !viewModel.isLastPage else { return }
            input.send(.fetchNotificationList(page: viewModel.currentPage + 1, size: 20))
        }
    }
}

extension NotificationViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        viewModel.notifications.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NotificationCell.identifier,
            for: indexPath
        ) as? NotificationCell else { return UITableViewCell() }
        
        let notification = viewModel.notifications[indexPath.row]
        let time = notification.createdAt.toRelativeTime()

        // 프로필 이미지 설정
        if let imageUrl = notification.senderImageUrl,
           let url = URL(string: imageUrl) {
            cell.profileImageView.kf.setImage(with: url)
        } else {
            cell.profileImageView.image = TDImage.Profile.large
        }

        // 제목, 부제목 생성
        let info = notification.data
        let type = notification.type
        let title = info.titleText
        let subtitle = info.subtitleText
        let senderName = info.senderName

        cell.configure(
            senderName: senderName,
            title: title,
            time: time,
            type: type,
            description: subtitle,
            isRead: notification.isRead,
            isFollowed: notification.isFollowed
        )
        
        if let userId = notification.senderId,
           let isFollowed = notification.isFollowed {
            cell.configureFollowButton { [weak self] in
                self?.input.send(.toggleUserFollow(userId: userId, isFollowing: isFollowed))
            }
        }
        cell.selectionStyle = .none
        
        return cell
    }

    
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        88
    }
}
