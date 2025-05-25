import Combine
import TDDomain

final class NotificationViewModel: BaseViewModel {
    enum Input {
        case fetchNotificationList(page: Int, size: Int)
        case readAllNotifications
    }
    
    enum Output {
        case fetchedNotificationList
        case failure(String)
    }
    
    private let fetchNotificationListUseCase: FetchNotificationListUseCase
    private let readAllNotificationsUseCase: ReadAllNotificationsUseCase
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    private(set) var notifications: [TDNotificationDetail] = []
    
    init(
        fetchNotificationListUseCase: FetchNotificationListUseCase,
        readAllNotificationsUseCase: ReadAllNotificationsUseCase
    ) {
        self.fetchNotificationListUseCase = fetchNotificationListUseCase
        self.readAllNotificationsUseCase = readAllNotificationsUseCase
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .fetchNotificationList(let page, let size):
                Task { await self?.fetchNotificationList(page: page, size: size) }
            case .readAllNotifications:
                Task { await self?.readAllNotifications() }
            }
        }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    private func fetchNotificationList(page: Int, size: Int) async {
        do {
            let notifications = try await fetchNotificationListUseCase.execute(page: page, size: size)
            self.notifications = notifications
            output.send(.fetchedNotificationList)
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

