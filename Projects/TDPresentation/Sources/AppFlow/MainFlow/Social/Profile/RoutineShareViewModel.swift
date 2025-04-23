import Combine
import Foundation
import TDDomain

final class RoutineShareViewModel: BaseViewModel {
    enum Input {
        case fetchRoutine
        case createRoutine
        case updateCategory(TDCategory)
        case updateMemo(String)
    }
    
    enum Output {
        case fetchRoutine(Routine)
        case success
        case failure(String)
    }

    private let existingRoutine: Routine
    // 생성할 일정 & 루틴 정보
    private var title: String
    private var selectedCategory: TDCategory
    private var isAllDay: Bool = false
    private var time: String? // hh:mm
    private var isPublic: Bool = true
    private var repeatDays: [TDWeekDay]?
    private var alarm: AlarmTime?
    private var memo: String?
    
    private let output = PassthroughSubject<Output, Never>()
    private let shareRoutineUseCase: ShareRoutineUseCase
    private var cancellables = Set<AnyCancellable>()
    
    init(
        routine: Routine,
        shareRoutineUseCase: ShareRoutineUseCase
    ) {
        self.existingRoutine = routine
        self.title = routine.title
        self.selectedCategory = routine.category
        self.isAllDay = routine.isAllDay
        self.time = routine.time
        self.isPublic = routine.isPublic
        self.repeatDays = routine.repeatDays
        self.alarm = routine.alarmTime
        self.memo = routine.memo
        self.shareRoutineUseCase = shareRoutineUseCase
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] input in
            guard let self else { return }
            switch input {
            case .fetchRoutine:
                Task { self.output.send(.fetchRoutine(self.existingRoutine)) }
            case .createRoutine:
                Task { await self.createRoutine() }
            case .updateCategory(let category):
                updateCategory(category: category)
            case .updateMemo(let memo):
                updateMemo(memo: memo)
            }
        }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    private func updateCategory(category: TDCategory) {
        selectedCategory = category
    }
    
    private func updateMemo(memo: String) {
        self.memo = memo
    }
    
    private func createRoutine() async {
        do {
            try await shareRoutineUseCase.execute(routineID: existingRoutine.id, routine: Routine(
                id: nil,
                title: title,
                category: selectedCategory,
                isAllDay: isAllDay,
                isPublic: isPublic,
                time: time,
                repeatDays: repeatDays,
                alarmTime: alarm,
                memo: memo,
                recommendedRoutines: nil,
                isFinished: false
            ))
            output.send(.success)
        }
        catch {
            output.send(.failure("루틴 공유에 실패했습니다."))
        }
    }
}
