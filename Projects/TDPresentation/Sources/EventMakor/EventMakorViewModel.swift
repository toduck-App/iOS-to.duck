import Combine
import Foundation
import TDCore
import TDDomain

final class EventMakorViewModel: BaseViewModel {
    enum Input {
        case fetchCategories
        case selectCategory(String, String)
        case selectDate(String, String)
    }
    
    enum Output {
        case fetchedCategories
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
}
