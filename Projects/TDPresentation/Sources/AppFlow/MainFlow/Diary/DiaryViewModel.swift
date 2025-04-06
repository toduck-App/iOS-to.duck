import Combine
import TDDomain
import Foundation

final class DiaryViewModel: BaseViewModel {
    enum Input {
        case fetchUserNickname
    }
    
    enum Output {
        case fetchedUserNickname(String)
        case failureAPI(String)
    }
    
    private let fetchUserNicknameUseCase: FetchUserNicknameUseCase
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    private(set) var monthDiaryList = [Date: Diary]()
    var selectedDiary: Diary?
    
    init(
        fetchUserNicknameUseCase: FetchUserNicknameUseCase
    ) {
        self.fetchUserNicknameUseCase = fetchUserNicknameUseCase
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .fetchUserNickname:
                Task { await self?.fetchUserNickname() }
            }
        }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    private func fetchUserNickname() async {
        do {
            let nickname = try await fetchUserNicknameUseCase.execute()
            output.send(.fetchedUserNickname(nickname))
        } catch {
            output.send(.failureAPI(error.localizedDescription))
        }
    }
}
