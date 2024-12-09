import Foundation

struct MockScheduleData {
    let title: String
    let date: String
    let isFinished: Bool
    let location: String?
    
    init(title: String, date: String, isFinished: Bool, location: String? = nil) {
        self.title = title
        self.date = date
        self.isFinished = isFinished
        self.location = location
    }
}

final class ToduckCalendarViewModel {
    let dummyData = [
        MockScheduleData(title: "캐릭터 디자인 작업", date: "14:00", isFinished: false),
        MockScheduleData(title: "토익 공부", date: "16:20", isFinished: true),
        MockScheduleData(title: "운동하기", date: "18:00", isFinished: false),
        MockScheduleData(title: "책 읽기", date: "20:00", isFinished: false),
        MockScheduleData(title: "영화 보기", date: "22:00", isFinished: false, location: "경북 구미시"),
        MockScheduleData(title: "캐릭터 디자인 작업", date: "14:00", isFinished: false),
        MockScheduleData(title: "토익 공부", date: "16:20", isFinished: true),
        MockScheduleData(title: "운동하기", date: "18:00", isFinished: false),
        MockScheduleData(title: "책 읽기", date: "20:00", isFinished: false),
        MockScheduleData(title: "영화 보기", date: "22:00", isFinished: false),
        MockScheduleData(title: "캐릭터 디자인 작업", date: "14:00", isFinished: false),
        MockScheduleData(title: "캐릭터 디자인 작업", date: "14:00", isFinished: false),
        MockScheduleData(title: "토익 공부", date: "16:20", isFinished: true),
        MockScheduleData(title: "운동하기", date: "18:00", isFinished: false),
        MockScheduleData(title: "책 읽기", date: "20:00", isFinished: false),
        MockScheduleData(title: "영화 보기", date: "22:00", isFinished: false),
        MockScheduleData(title: "캐릭터 디자인 작업", date: "14:00", isFinished: false),
        MockScheduleData(title: "토익 공부", date: "16:20", isFinished: true),
        MockScheduleData(title: "운동하기", date: "18:00", isFinished: false),
        MockScheduleData(title: "책 읽기", date: "20:00", isFinished: false),
        MockScheduleData(title: "영화 보기", date: "22:00", isFinished: false),
        MockScheduleData(title: "캐릭터 디자인 작업", date: "14:00", isFinished: false),
        MockScheduleData(title: "캐릭터 디자인 작업", date: "14:00", isFinished: false),
        MockScheduleData(title: "토익 공부", date: "16:20", isFinished: true),
        MockScheduleData(title: "운동하기", date: "18:00", isFinished: false),
        MockScheduleData(title: "책 읽기", date: "20:00", isFinished: false),
        MockScheduleData(title: "영화 보기", date: "22:00", isFinished: false),
        MockScheduleData(title: "캐릭터 디자인 작업", date: "14:00", isFinished: false),
        MockScheduleData(title: "토익 공부", date: "16:20", isFinished: true),
        MockScheduleData(title: "운동하기", date: "18:00", isFinished: false),
        MockScheduleData(title: "책 읽기", date: "20:00", isFinished: false),
        MockScheduleData(title: "영화 보기", date: "22:00", isFinished: false),
        MockScheduleData(title: "캐릭터 디자인 작업", date: "14:00", isFinished: false),
    ]
}
