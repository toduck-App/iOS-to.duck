import TDCore
import TDDomain
import Foundation

public final class ScheduleRepositoryImpl: ScheduleRepository {
    private let service: ScheduleService
    
    public init(service: ScheduleService) {
        self.service = service
    }
    
    public func createSchedule(schedule: Schedule) async throws {
        let scheduleRequestDTO = ScheduleRequestDTO(schedule: schedule)
        try await service.create(schedule: scheduleRequestDTO)
    }
    
    public func fetchScheduleList() async throws -> [Schedule] {
        return []
    }
    
    public func fetchSchedule() async throws -> Schedule {
        return
            Schedule(
                id: 0,
                title: "title",
                category: TDCategory(colorHex: "", imageName: ""),
                startDate: "",
                endDate: "",
                isAllDay: false,
                time: nil,
                repeatDays: nil,
                alarmTime: nil,
                place: nil,
                memo: nil,
                isFinished: false,
                scheduleRecords: nil
            )
    }
    
    public func updateSchedule(scheduleId: Int) async throws {
        
    }
    
    public func deleteSchedule(scheduleId: Int) async throws {
        
    }
    
    public func moveTomorrowSchedule(scheduleId: Int) async throws {
        
    }
}
