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
    }
    
    enum Output {
        case fetchedCategories
        case savedEvent
    }
    
    private let output = PassthroughSubject<Output, Never>()
    private let createScheduleUseCase: CreateScheduleUseCase
    private let fetchCategoriesUseCase: FetchCategoriesUseCase
    private var cancellables = Set<AnyCancellable>()
    private(set) var categories: [TDCategory] = []
    
    // 생성할 일정 정보
    private var title: String?
    private var selectedCategory: TDCategory?
    private var startDate: String? // YYYY-MM-DD
    private var endDate: String? // YYYY-MM-DD
    private var isAllDay: Bool = false
    private var time: Date? // hh:mm
    private var repeatType: [TDWeekDay]?
    private var alarm: [AlarmType]?
    private var location: String?
    private var memo: String?
    
    init(
        createScheduleUseCase: CreateScheduleUseCase,
        fetchCategoriesUseCase: FetchCategoriesUseCase
    ) {
        self.createScheduleUseCase = createScheduleUseCase
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
            case .saveEvent:
                Task { await self?.saveEvent() }
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
    
    private func saveEvent() async {
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
}
