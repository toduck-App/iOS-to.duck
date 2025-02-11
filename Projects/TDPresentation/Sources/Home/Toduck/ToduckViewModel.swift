import Combine
import Foundation
import TDDomain

final class ToduckViewModel: BaseViewModel {
    enum Input {
        
    }
    
    enum Output {
        
    }
    
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    private(set) var todaySchedules: [Schedule] = [Schedule(
        id: 0,
        title: "1번 일정",
        category: TDCategory(colorHex: "#648EF8", imageName: "power"),
        startDate: "2021-09-01",
        endDate: "2021-09-01",
        isAllDay: true,
        time: nil,
        repeatDays: nil,
        alarmTimes: nil,
        place: nil,
        memo: nil,
        isFinished: false
    ), Schedule(
        id: 0,
        title: "2번 일정",
        category: TDCategory(colorHex: "#FFD6E2", imageName: "sleep"),
        startDate: "2021-09-01",
        endDate: "2021-09-01",
        isAllDay: true,
        time: Date(),
        repeatDays: nil,
        alarmTimes: nil,
        place: nil,
        memo: nil,
        isFinished: false
    ), Schedule(
        id: 0,
        title: "3번 일정",
        category: TDCategory(colorHex: "#FF3872", imageName: "sleep"),
        startDate: "2021-09-01",
        endDate: "2021-09-01",
        isAllDay: true,
        time: Date(),
        repeatDays: nil,
        alarmTimes: nil,
        place: "장장소소",
        memo: nil,
        isFinished: true
    ), Schedule(
        id: 0,
        title: "4번 일정",
        category: TDCategory(colorHex: "#FF3872", imageName: "sleep"),
        startDate: "2021-09-01",
        endDate: "2021-09-01",
        isAllDay: true,
        time: Date(),
        repeatDays: nil,
        alarmTimes: nil,
        place: "장장소소",
        memo: nil,
        isFinished: true
    )]
    var categoryImages: [TDCategoryImageType] {
        todaySchedules.map { TDCategoryImageType.init(rawValue: $0.category.imageName) }
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        
        return output.eraseToAnyPublisher()
    }
}
