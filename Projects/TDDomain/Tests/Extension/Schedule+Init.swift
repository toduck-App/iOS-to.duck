import TDDomain

extension Schedule {
    init(id: Int?, title: String, startDate: String, endDate: String, repeatDays: [TDWeekDay]? = nil, scheduleRecords: [ScheduleRecord]? = nil) {
        self.init(
            id: id,
            title: title,
            category: TDCategory(colorHex: "FFFFFF", imageName: "default"),
            startDate: startDate,
            endDate: endDate,
            isAllDay: true,
            time: nil,
            repeatDays: repeatDays,
            alarmTime: nil,
            place: nil,
            memo: nil,
            isFinished: false,
            scheduleRecords: scheduleRecords,
            source: .server
        )
    }
}

extension ScheduleRecord {
    init(recordDate: String, deletedAt: String? = nil) {
        self.init(
            id: Int.random(in: 1...10000),
            isComplete: false,
            recordDate: recordDate,
            deletedAt: deletedAt
        )
    }
}
