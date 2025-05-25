import Combine
import Foundation
import TDDomain

final class NotificationViewModel: BaseViewModel {
    enum Input {
        case fetchNotificationList(page: Int, size: Int)
        case toggleUserFollow(userId: Int, isFollowing: Bool)
        case readAllNotifications
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
    private let toggleUserFollowInput = PassthroughSubject<(Int, Bool), Never>()
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
            case .fetchNotificationList(let page, let size):
                Task { await self?.fetchNotificationList(page: page, size: size) }
            case .toggleUserFollow(let userId, let isFollowing):
                self?.toggleUserFollowInput.send((userId, isFollowing))
            case .readAllNotifications:
                Task { await self?.readAllNotifications() }
            }
        }.store(in: &cancellables)
        
        toggleUserFollowInput
            .throttle(for: .seconds(2), scheduler: DispatchQueue.main, latest: false)
            .sink { [weak self] userId, isFollowing in
                Task { await self?.toggleUserFollow(userId: userId, isFollowing: isFollowing) }
            }
            .store(in: &cancellables)

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
            if let index = notifications.firstIndex(where: { $0.senderId == userId }) {
                notifications[index].isFollowed?.toggle()
            }
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

