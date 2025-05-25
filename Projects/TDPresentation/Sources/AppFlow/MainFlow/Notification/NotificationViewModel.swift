import Combine
import TDDomain

final class NotificationViewModel: BaseViewModel {
    enum Input {
        case fetchNotificationList(page: Int, size: Int)
        case readAllNotifications
        case toggleUserFollow(userId: Int, isFollowing: Bool)
    }
    
    enum Output {
        case fetchedNotificationList
        case successUserFollowToggle
        case failure(String)
    }
    private let toggleUserFollowUseCase: ToggleUserFollowUseCase
    private let fetchNotificationListUseCase: FetchNotificationListUseCase
    private let readAllNotificationsUseCase: ReadAllNotificationsUseCase
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    private(set) var notifications: [TDNotificationDetail] = []
    var currentPage = 0
    var isLastPage = false
    var isLoading = false
    
    init(
        toggleUserFollowUseCase: ToggleUserFollowUseCase,
        fetchNotificationListUseCase: FetchNotificationListUseCase,
        readAllNotificationsUseCase: ReadAllNotificationsUseCase
    ) {
        self.toggleUserFollowUseCase = toggleUserFollowUseCase
        self.fetchNotificationListUseCase = fetchNotificationListUseCase
        self.readAllNotificationsUseCase = readAllNotificationsUseCase
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .toggleUserFollow(let userId, let isFollowing):
                Task { await self?.toggleUserFollow(userId: userId, isFollowing: isFollowing) }
            case .fetchNotificationList(let page, let size):
                Task { await self?.fetchNotificationList(page: page, size: size) }
            case .readAllNotifications:
                Task { await self?.readAllNotifications() }
            }
        }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    private func fetchNotificationList(page: Int, size: Int) async {
        guard !isLoading else { return }
        isLoading = true

        do {
            let result = try await fetchNotificationListUseCase.execute(page: page, size: size)
            
            if page == 0 {
                self.notifications = result
            } else {
                self.notifications.append(contentsOf: result)
            }

            self.currentPage = page
            self.isLastPage = result.count < size
            output.send(.fetchedNotificationList)
        } catch {
            output.send(.failure(error.localizedDescription))
        }

        isLoading = false
    }
    
    private func toggleUserFollow(userId: Int, isFollowing: Bool) async {
        do {
            try await toggleUserFollowUseCase.execute(
                currentFollowState: isFollowing,
                targetUserID: userId
            )
            self.notifications = try await fetchNotificationListUseCase.execute(page: 0, size: 20)
            output.send(.successUserFollowToggle)
        } catch {
            output.send(.failure(error.localizedDescription))
        }
    }
    
    private func readAllNotifications() async {
        do {
            try await readAllNotificationsUseCase.execute()
        } catch {
            output.send(.failure(error.localizedDescription))
        }
    }
}

