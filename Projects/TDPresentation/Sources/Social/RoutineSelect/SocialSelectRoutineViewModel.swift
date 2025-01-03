import Combine
import TDDomain

final class SocialSelectRoutineViewModel: BaseViewModel {
    enum Input {
        case fetchRoutines
        case selectRoutine(Routine)
    }

    enum Output {
        case fetchRoutines
        case selectRoutine
        case failure(String)
    }
    
    private let routineRepository: FetchRoutineListUseCase
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    private(set) var routines: [Routine] = []
    private(set) var selectedRoutine: Routine?
    
    init(routineRepository: FetchRoutineListUseCase) {
        self.routineRepository = routineRepository
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            guard let self else { return }
            switch event {
                case .fetchRoutines:
                    Task { await self.fetchRoutines() }
                case .selectRoutine(let routine):
                    selectRoutine(routine)
            }
        }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    private func fetchRoutines() async {
        do {
            let routines = try await routineRepository.execute()
            self.routines = routines
            output.send(.fetchRoutines)
        } catch {
            output.send(.failure("루틴을 불러오는데 실패했습니다."))
        }
    }
    
    private func selectRoutine(_ routine: Routine) {
        selectedRoutine = routine
        output.send(.selectRoutine)
    }
}
