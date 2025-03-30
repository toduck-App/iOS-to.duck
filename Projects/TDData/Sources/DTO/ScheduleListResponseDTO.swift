import Foundation
import TDDomain

public struct ScheduleListContentDTO: Decodable {
    public let queryStartDate: String
    public let queryEndDate: String
    public let scheduleHeadDtos: [ScheduleHeadDTO]
}

public struct ScheduleHeadDTO: Decodable {
    public let scheduleId: Int
    public let title: String
    public let scheduleRecordDto: [ScheduleRecordDTO]
    public let color: String
    public let category: String
    public let isAllDay: Bool
    public let startDate: String
    public let endDate: String
    public let daysOfWeek: [String]
    public let time: String
    public let location: String?
}

public struct ScheduleRecordDTO: Decodable {
    public let scheduleRecordId: Int
    public let isComplete: Bool
    public let recordDate: String
    public let deletedAt: String?
}

public extension ScheduleHeadDTO {
    func convertToSchedule() -> Schedule {
        let category = TDCategory(colorHex: color, imageName: category)
        let repeatDays = daysOfWeek.compactMap { TDWeekDay(rawValue: $0) }
        let isFinished = scheduleRecordDto.contains(where: { $0.isComplete })

        let records: [ScheduleRecord] = scheduleRecordDto.map {
            ScheduleRecord(
                id: $0.scheduleRecordId,
                isComplete: $0.isComplete,
                recordDate: $0.recordDate,
                deletedAt: $0.deletedAt
            )
        }

        return Schedule(
            id: scheduleId,
            title: title,
            category: category,
            startDate: startDate,
            endDate: endDate,
            isAllDay: isAllDay,
            time: Date.convertFromString(time, format: .time24Hour),
            repeatDays: repeatDays.isEmpty ? nil : repeatDays,
            alarmTime: nil, // 알람 응답 생기면 대응 가능
            place: location,
            memo: nil,      // 메모 응답 생기면 대응 가능
            isFinished: isFinished,
            scheduleRecords: records
        )
    }
}
