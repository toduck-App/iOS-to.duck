import Combine
import TDDomain
import Foundation

final class DiaryCalendarViewModel: BaseViewModel {
    enum Input {
        case selecteDay(Date)
        case fetchDiaryList(Int, Int)
    }
    
    enum Output {
        case selectedDiary(Diary)
        case fetchedDiaryList
        case notFoundDiary
        case failureAPI(String)
    }
    
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    private(set) var monthDiaryList = [Date: Diary]()
    var selectedDiary: Diary?
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .selecteDay(let date):
                self?.selecteDay(date: date)
            case .fetchDiaryList(let year, let month):
                self?.fetchDiaryList(year: year, month: month)
            }
        }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    func selecteDay(date: Date) {
        selectedDiary = monthDiaryList[date.normalized]
        if let selectedDiary = selectedDiary {
            output.send(.selectedDiary(selectedDiary))
        } else {
            output.send(.notFoundDiary)
        }
    }
    
    func fetchDiaryList(year: Int, month: Int) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let marchDiaries: [Diary] = [
            Diary(id: 1, date: formatter.date(from: "2025-03-01")!, emotion: .happy, title: "봄이 온 날", sentenceText: "햇살이 따뜻했어", imagesURL: nil),
            Diary(id: 2, date: formatter.date(from: "2025-03-03")!, emotion: .angry, title: "짜증난 하루", sentenceText: "지하철이 또 연착", imagesURL: nil),
            Diary(id: 3, date: formatter.date(from: "2025-03-05")!, emotion: .sad, title: "쓸쓸한 날", sentenceText: "비가 내렸다", imagesURL: nil),
            Diary(id: 4, date: formatter.date(from: "2025-03-07")!, emotion: .tired, title: "좋은 소식", sentenceText: "합격했다!", imagesURL: nil),
            Diary(id: 5, date: formatter.date(from: "2025-03-23")!, emotion: .good, title: "평범한 하루", sentenceText: "그냥 그런 날", imagesURL: nil)
        ]
        
        let februaryDiaries: [Diary] = [
            Diary(id: 6, date: formatter.date(from: "2025-02-02")!, emotion: .sad, title: "혼자 보낸 주말", sentenceText: "조용히 집에만 있었다", imagesURL: nil),
            Diary(id: 7, date: formatter.date(from: "2025-02-14")!, emotion: .happy, title: "발렌타인데이", sentenceText: "초콜릿을 받았다", imagesURL: nil),
            Diary(id: 8, date: formatter.date(from: "2025-02-18")!, emotion: .angry, title: "짜증난 날", sentenceText: "회사에서 실수했다", imagesURL: nil),
            Diary(id: 9, date: formatter.date(from: "2025-02-21")!, emotion: .good, title: "좋은 하루", sentenceText: "기분이 좋았다", imagesURL: nil),
            Diary(id: 10, date: formatter.date(from: "2025-02-28")!, emotion: .tired, title: "지침", sentenceText: "일이 너무 많았다", imagesURL: nil)
        ]
        
        let selectedMonthDiaries: [Diary]
        
        switch month {
        case 2:
            selectedMonthDiaries = februaryDiaries
        case 3:
            selectedMonthDiaries = marchDiaries
        default:
            selectedMonthDiaries = []
        }
        
        monthDiaryList = Dictionary(uniqueKeysWithValues: selectedMonthDiaries.map { ($0.date.normalized, $0) })
    }
}
