import TDDomain
import Foundation

final class MockScheduleRepository: ScheduleRepository {
    var mockScheduleList: [Schedule] = []
    
    var didCallUpdate = false
    var updatedScheduleId: Int?

    var didCallDelete = false
    var deletedScheduleId: Int?

    var didCallMoveTomorrow = false
    var movedScheduleId: Int?

    var didCallCreate = false
    var createdSchedule: Schedule?
    
    init(_ schedules: [Schedule]) { self.mockScheduleList = schedules }

    func fetchServerScheduleList(startDate: String, endDate: String) async throws -> [Schedule] {
        return mockScheduleList
    }

    func fetchSchedule() async throws -> TDDomain.Schedule {
        return Schedule(
            id: 999,
            title: "Mock 단일 일정",
            category: TDCategory(colorHex: "#FFFFFF", imageName: "computer"),
            startDate: "2025-04-06",
            endDate: "2025-04-06",
            isAllDay: true,
            time: nil,
            repeatDays: nil,
            alarmTime: nil,
            place: nil,
            memo: nil,
            isFinished: false,
            scheduleRecords: nil
        )
    }

    func updateSchedule(scheduleId: Int) async throws {
        didCallUpdate = true
        updatedScheduleId = scheduleId
    }
    
    func deleteSchedule(scheduleId: Int, isOneDayDeleted: Bool, queryDate: String) async throws {
        didCallDelete = true
        deletedScheduleId = scheduleId
    }

    func moveTomorrowSchedule(scheduleId: Int) async throws {
        didCallMoveTomorrow = true
        movedScheduleId = scheduleId
    }

    func createSchedule(schedule: TDDomain.Schedule) async throws {
        didCallCreate = true
        createdSchedule = schedule
    }
    
    func finishSchedule(scheduleId: Int, isComplete: Bool, queryDate: String) async throws { }
    func updateSchedule(scheduleId: Int, isOneDayDeleted: Bool, queryDate: String, scheduleData: TDDomain.Schedule) async throws { }
}
