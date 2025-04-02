import Combine
import TDDomain
import Foundation

final class FocusCalendarViewModel: BaseViewModel {
    enum Input {
        case selecteDay(Date)
        case fetchFocusList(Int, Int)
    }
    
    enum Output {
        case selectedFocus(Focus)
        case fetchedFocusList
        case notFoundFocus
        case failureAPI(String)
    }
    
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    private(set) var monthFoucsList = [Date: Focus]()
    var selectedFocus: Focus?
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .selecteDay(let date):
                self?.selecteDay(date: date)
            case .fetchFocusList(let year, let month):
                self?.fetchFocusList(year: year, month: month)
            }
        }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    func selecteDay(date: Date) {
        selectedFocus = monthFoucsList[date.normalized]
        if let selectedFocus {
            output.send(.selectedFocus(selectedFocus))
        } else {
            output.send(.notFoundFocus)
        }
    }
    
    func fetchFocusList(year: Int, month: Int) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let marchDiaries: [Focus] = [
            Focus(id: 1, date: formatter.date(from: "2025-03-12")!, targetCount: 3, settingCount: 5, time: 921, percentage: 30),
            Focus(id: 2, date: formatter.date(from: "2025-03-15")!, targetCount: 5, settingCount: 5, time: 123, percentage: 100),
            Focus(id: 3, date: formatter.date(from: "2025-03-20")!, targetCount: 3, settingCount: 5, time: 456, percentage: 60),
        ]
        
        let februaryDiaries: [Focus] = [
            Focus(id: 1, date: formatter.date(from: "2025-02-12")!, targetCount: 3, settingCount: 5, time: 921, percentage: 30),
            Focus(id: 2, date: formatter.date(from: "2025-02-15")!, targetCount: 5, settingCount: 5, time: 123, percentage: 100),
            Focus(id: 3, date: formatter.date(from: "2025-02-20")!, targetCount: 3, settingCount: 5, time: 456, percentage: 60),
        ]
        
        let selectedMonthDiaries: [Focus]
        
        switch month {
        case 2:
            selectedMonthDiaries = februaryDiaries
        case 3:
            selectedMonthDiaries = marchDiaries
        default:
            selectedMonthDiaries = []
        }
        
        monthFoucsList = Dictionary(uniqueKeysWithValues: selectedMonthDiaries.map { ($0.date.normalized, $0) })
    }
}
