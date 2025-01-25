import Combine
import Foundation
import TDCore
import TDDomain

final class EventMakorViewModel: BaseViewModel {
    enum Input {
        case fetchCategories
        case selectCategory(String, String)
        case selectDate(String, String)
        case selectTime(Bool, Date?)
        case saveEvent
        case updateTitleTextField(String)
        case updateLocationTextField(String)
        case updateTextView(String)
        case selectLockType(Bool)
    }
    
    enum Output {
        case fetchedCategories
        case savedEvent
    }
    
    private let mode: ScheduleAndRoutineViewController.Mode
    private let output = PassthroughSubject<Output, Never>()
    private let createScheduleUseCase: CreateScheduleUseCase
    private let createRoutineUseCase: CreateRoutineUseCase
    private let fetchCategoriesUseCase: FetchCategoriesUseCase
    private var cancellables = Set<AnyCancellable>()
    private(set) var categories: [TDCategory] = []
    
    // 생성할 일정 & 루틴 정보
    private var title: String?
    private var selectedCategory: TDCategory?
    private var startDate: String? // YYYY-MM-DD
    private var endDate: String? // YYYY-MM-DD
    private var isAllDay: Bool = false
    private var time: Date? // hh:mm
    private var isPublic: Bool = true
    private var repeatType: [TDWeekDay]?
    private var alarm: [AlarmType]?
    private var location: String?
    private var memo: String?
    
    init(
        mode: ScheduleAndRoutineViewController.Mode,
        createScheduleUseCase: CreateScheduleUseCase,
        createRoutineUseCase: CreateRoutineUseCase,
        fetchCategoriesUseCase: FetchCategoriesUseCase
    ) {
        self.mode = mode
        self.createScheduleUseCase = createScheduleUseCase
        self.createRoutineUseCase = createRoutineUseCase
        self.fetchCategoriesUseCase = fetchCategoriesUseCase
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .fetchCategories:
                Task { await self?.fetchCategories() }
            case .selectCategory(let colorHex, let imageName):
                self?.selectedCategory = TDCategory(colorHex: colorHex, imageName: imageName)
            case .selectDate(let startDay, let endDay):
                self?.startDate = startDay
                self?.endDate = endDay
            case .selectTime(let isAllDay, let time):
                self?.isAllDay = isAllDay
                self?.time = time
            case .selectLockType(let isPublic):
                self?.isPublic = isPublic
            case .saveEvent:
                if self?.mode == .schedule {
                    Task { await self?.saveSchedule() }
                } else {
                    Task { await self?.saveRoutine() }
                }
            case .updateTitleTextField(let title):
                self?.title = title
            case .updateLocationTextField(let location):
                self?.location = location
            case .updateTextView(let memo):
                self?.memo = memo
            }
        }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    private func fetchCategories() async {
        do {
            let categories = try await fetchCategoriesUseCase.execute()
            self.categories = categories
            output.send(.fetchedCategories)
        } catch {
            // TODO: Handle error
            TDLogger.error(error)
        }
    }
    
    private func saveSchedule() async {
        guard let title = title,
              let selectedCategory = selectedCategory,
              let startDate = startDate,
              let endDate = endDate else {
            TDLogger.error(
                """
                필수 값 누락: title: \(String(describing: title)),
                selectedCategory: \(String(describing: selectedCategory)),
                startDate: \(String(describing: startDate)),
                endDate: \(String(describing: endDate))는 필수입니다.
                """
            )
            return
        }
        
        do {
            let schedule = Schedule(
                id: nil,
                title: title,
                category: selectedCategory,
                startDate: startDate,
                endDate: endDate,
                isAllDay: isAllDay,
                time: time,
                repeatDays: repeatType,
                alarmTimes: alarm,
                place: location,
                memo: memo,
                isFinish: false
            )
            
            try await createScheduleUseCase.execute(schedule: schedule)
            TDLogger.info("일정 생성 성공: \(schedule)")
            output.send(.savedEvent)
        } catch {
            TDLogger.error("일정 생성 실패: \(error)")
        }
    }
    
    private func saveRoutine() async {
        guard let title = title,
              let selectedCategory = selectedCategory else {
            TDLogger.error(
                """
                필수 값 누락: title: \(String(describing: title)),
                selectedCategory: \(String(describing: selectedCategory))는 필수입니다.
                """
            )
            return
        }
        
        do {
            let routine = Routine(
                id: nil, // 새로 생성된 루틴이므로 ID는 nil
                title: title,
                category: selectedCategory,
                isAllDay: isAllDay,
                isPublic: isPublic,
                date: nil, // 루틴은 특정 날짜와 관계없으므로 nil
                time: time,
                repeatDays: repeatType,
                alarmTimes: alarm,
                memo: memo,
                recommendedRoutines: nil,
                isFinish: false
            )
            
            // Create 요청 실행
            try await createRoutineUseCase.execute(routine: routine)
            TDLogger.info("루틴 생성 성공: \(routine)")
            output.send(.savedEvent) // 이벤트 생성 성공 알림 전송
        } catch {
            TDLogger.error("루틴 생성 실패: \(error)")
        }
    }
}
