import Combine
import TDCore
import TDDomain

final class SplashViewModel: BaseViewModel {
    enum Input {
        case validateVerison
    }
    
    enum Output {
        case validateVersion(VersionPolicy)
        case failure(String)
    }
    
    private let validateVersionUseCase: ValidateVersionUseCase
    
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    init(validateVersionUseCase: ValidateVersionUseCase) {
        self.validateVersionUseCase = validateVersionUseCase
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .validateVerison:
                Task { await self?.validateVersion() }
            }
        }
        .store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    private func validateVersion() async {
        do {
            let policy = try await validateVersionUseCase.execute(Constant.toduckAppVersion)
            output.send(.validateVersion(policy))
        } catch {
            output.send(.failure("버전 확인에 실패하였습니다."))
        }
    }
}
