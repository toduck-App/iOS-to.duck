import Foundation
import TDCore

public struct Schedule: TodoItem {
    public let id: Int? // 서버의 일정 PK
    public let title: String
    public let category: TDCategory
    public var startDate: String
    public var endDate: String // 단일 날짜 선택 시 startDate와 동일한 값 설정
    public let isAllDay: Bool
    public let time: String?
    public let repeatDays: [TDWeekDay]?
    public let alarmTime: AlarmTime?
    public let place: String?
    public let memo: String?
    public let isFinished: Bool
    public let scheduleRecords: [ScheduleRecord]?
    public let eventMode: TDTodoMode = .schedule

    public var isRepeating: Bool {
        repeatDays != nil || startDate != endDate
    }

    public init(
        id: Int?,
        title: String,
        category: TDCategory,
        startDate: String,
        endDate: String,
        isAllDay: Bool,
        time: String?,
        repeatDays: [TDWeekDay]?,
        alarmTime: AlarmTime?,
        place: String?,
        memo: String?,
        isFinished: Bool,
        scheduleRecords: [ScheduleRecord]?
    ) {
        self.id = id
        self.title = title
        self.category = category
        self.startDate = startDate
        self.endDate = endDate
        self.isAllDay = isAllDay
        self.time = time
        self.repeatDays = repeatDays
        self.alarmTime = alarmTime
        self.place = place
        self.memo = memo
        self.isFinished = isFinished
        self.scheduleRecords = scheduleRecords
    }
}

public struct ScheduleRecord: Hashable {
    public let id: Int
    public let isComplete: Bool
    public let recordDate: String
    public let deletedAt: String?

    public init(id: Int, isComplete: Bool, recordDate: String, deletedAt: String?) {
        self.id = id
        self.isComplete = isComplete
        self.recordDate = recordDate
        self.deletedAt = deletedAt
    }
}

public extension Schedule {
    static let dummy: Schedule = .init(
        id: nil,
        title: "디자인팀 회의",
        category: TDCategory(colorHex: "#FFD6E2", imageName: "RED_BOOK"),
        startDate: Date().convertToString(formatType: .yearMonthDay),
        endDate: Date().convertToString(formatType: .yearMonthDay),
        isAllDay: false,
        time: "10:00",
        repeatDays: nil,
        alarmTime: nil,
        place: "스타벅스 여의도 한강공원점 1층",
        memo: nil,
        isFinished: false,
        scheduleRecords: nil
    )

    static let dummyList: [Schedule] = [
        .init(
            id: 1,
            title: "디자인팀 회의",
            category: TDCategory(colorHex: "#FFE3CC", imageName: "COMPUTER"),
            startDate: Date().convertToString(formatType: .yearMonthDay),
            endDate: Date().convertToString(formatType: .yearMonthDay),
            isAllDay: false,
            time: "10:00",
            repeatDays: nil,
            alarmTime: nil,
            place: nil,
            memo: nil,
            isFinished: false,
            scheduleRecords: nil
        ),
        .init(
            id: 2,
            title: "기획 과정 검토",
            category: TDCategory(colorHex: "#DEEEFC", imageName: "PENCIL"),
            startDate: Date().convertToString(formatType: .yearMonthDay),
            endDate: Date().convertToString(formatType: .yearMonthDay),
            isAllDay: false,
            time: "10:30",
            repeatDays: nil,
            alarmTime: nil,
            place: nil,
            memo: nil,
            isFinished: false,
            scheduleRecords: nil
        ),
        .init(
            id: 3,
            title: "지현 점심 약속",
            category: TDCategory(colorHex: "", imageName: "NONE"),
            startDate: Date().convertToString(formatType: .yearMonthDay),
            endDate: Date().convertToString(formatType: .yearMonthDay),
            isAllDay: false,
            time: "13:00",
            repeatDays: nil,
            alarmTime: nil,
            place: nil,
            memo: nil,
            isFinished: false,
            scheduleRecords: nil
        ),
        .init(
            id: 4,
            title: "캐릭터 디자인 작업",
            category: TDCategory(colorHex: "#FFF7D9", imageName: "POWER"),
            startDate: Date().convertToString(formatType: .yearMonthDay),
            endDate: Date().convertToString(formatType: .yearMonthDay),
            isAllDay: false,
            time: "14:00",
            repeatDays: nil,
            alarmTime: nil,
            place: nil,
            memo: nil,
            isFinished: false,
            scheduleRecords: nil
        ),
        .init(
            id: 5,
            title: "토익 공부",
            category: TDCategory(colorHex: "#FFD6E2", imageName: "RED_BOOK"),
            startDate: Date().convertToString(formatType: .yearMonthDay),
            endDate: Date().convertToString(formatType: .yearMonthDay),
            isAllDay: false,
            time: "16:20",
            repeatDays: nil,
            alarmTime: nil,
            place: nil,
            memo: nil,
            isFinished: false,
            scheduleRecords: nil
        )
    ]
}
