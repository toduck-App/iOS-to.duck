import Combine
import TDDomain
import Foundation

final class FocusCalendarViewModel: BaseViewModel {
    enum Input {
        case selectDay(Date)
        case fetchFocusList(Int, Int)
    }
    
    enum Output {
        case selectedFocus(Focus)
        case fetchedFocusList
        case notFoundFocus
        case failureAPI(String)
    }
    
    private let fetchFocusListUseCase: FetchFocusListUseCase
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    private(set) var monthFocusList = [Date: Focus]()
    var selectedFocus: Focus?
    
    init(
        fetchFocusListUseCase: FetchFocusListUseCase
    ) {
        self.fetchFocusListUseCase = fetchFocusListUseCase
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .selectDay(let date):
                self?.selecteDay(date: date)
            case .fetchFocusList(let year, let month):
                Task { await self?.fetchFocusList(year: year, month: month) }
            }
        }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    func selecteDay(date: Date) {
        selectedFocus = monthFocusList[date.normalized]
        if let selectedFocus {
            output.send(.selectedFocus(selectedFocus))
        } else {
            output.send(.notFoundFocus)
        }
    }
    
    func fetchFocusList(year: Int, month: Int) async {
        do {
            let monthString = String(format: "%02d", month)
            let yearMonth = "\(year)-\(monthString)"
            let focusList = try await fetchFocusListUseCase.execute(yearMonth: yearMonth)
            let focusItems = focusList.map {
                Focus(
                    id: $0.id,
                    date: $0.date,
                    targetCount: $0.targetCount,
                    settingCount: $0.settingCount,
                    time: $0.time,
                    percentage: $0.percentage
                )
            }
            monthFocusList = Dictionary(uniqueKeysWithValues: focusItems.map { ($0.date, $0) })
            output.send(.fetchedFocusList)
        } catch {
            output.send(.failureAPI(error.localizedDescription))
        }
    }
}
