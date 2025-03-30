import Combine
import TDDomain
import Foundation

final class EditProfileViewModel: BaseViewModel {
    enum Input {
        case writeNickname(nickname: String)
        case updateNickname
    }
    
    enum Output {
        case updatedNickname
        case failureAPI(String)
    }
    
    private let updateUserNicknameUseCase: UpdateUserNicknameUseCase
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    private var nickname = ""
    
    init(
        updateUserNicknameUseCase: UpdateUserNicknameUseCase
    ) {
        self.updateUserNicknameUseCase = updateUserNicknameUseCase
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .writeNickname(let nickname):
                self?.nickname = nickname
            case .updateNickname:
                Task { await self?.updateNickname() }
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    private func updateNickname() async {
        do {
            try await updateUserNicknameUseCase.execute(nickname: nickname)
            output.send(.updatedNickname)
        } catch {
            output.send(.failureAPI(error.localizedDescription))
        }
    }
}
