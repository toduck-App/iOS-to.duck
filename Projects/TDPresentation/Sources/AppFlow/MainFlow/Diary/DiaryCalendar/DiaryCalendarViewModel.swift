import Combine
import TDDomain
import Foundation

final class DiaryCalendarViewModel: BaseViewModel {
    enum Input {
        case selectDay(Date)
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
            case .selectDay(let date):
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
            Diary(id: 1, date: formatter.date(from: "2025-03-01")!, emotion: .happy, title: "봄이 온 날", memo: "햇살이 따뜻했어", diaryImageUrls: nil),
            Diary(id: 2, date: formatter.date(from: "2025-03-03")!, emotion: .angry, title: "짜증난 하루", memo: "지하철이 또 연착", diaryImageUrls: nil),
            Diary(id: 3, date: formatter.date(from: "2025-03-05")!, emotion: .sad, title: "쓸쓸한 날", memo: "비가 내렸다", diaryImageUrls: nil),
            Diary(id: 4, date: formatter.date(from: "2025-03-07")!, emotion: .tired, title: "좋은 소식", memo: "합격했다!", diaryImageUrls: nil),
            Diary(id: 5, date: formatter.date(from: "2025-03-23")!, emotion: .good, title: "평범한 하루", memo: "그냥 그런 날", diaryImageUrls: nil)
        ]
        
        let februaryDiaries: [Diary] = [
            Diary(id: 6, date: formatter.date(from: "2025-02-02")!, emotion: .sad, title: "혼자 보낸 주말", memo: "조용히 집에만 있었다", diaryImageUrls: nil),
            Diary(id: 7, date: formatter.date(from: "2025-02-14")!, emotion: .happy, title: "발렌타인데이", memo: "초콜릿을 받았다", diaryImageUrls: nil),
            Diary(id: 8, date: formatter.date(from: "2025-02-18")!, emotion: .angry, title: "짜증난 날", memo: "회사에서 실수했다", diaryImageUrls: nil),
            Diary(id: 9, date: formatter.date(from: "2025-02-21")!, emotion: .good, title: "좋은 하루", memo: "기분이 좋았다", diaryImageUrls: nil),
            Diary(id: 10, date: formatter.date(from: "2025-02-28")!, emotion: .tired, title: "지침", memo: "일이 너무 많았다", diaryImageUrls: nil)
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
