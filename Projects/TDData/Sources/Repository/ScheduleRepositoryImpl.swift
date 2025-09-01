import TDCore
import EventKit
import TDDomain
import Foundation

public final class ScheduleRepositoryImpl: ScheduleRepository {
    private let service: ScheduleService
    private let storage: ScheduleStorage
    
    public init(
        service: ScheduleService,
        storage: ScheduleStorage
    ) {
        self.service = service
        self.storage = storage
    }
    
    public func createSchedule(schedule: Schedule) async throws {
        let scheduleRequestDTO = ScheduleRequestDTO(schedule: schedule)
        try await service.createSchedule(schedule: scheduleRequestDTO)
    }
    
    public func fetchServerScheduleList(startDate: String, endDate: String) async throws -> [Schedule] {
        let responseDTO = try await service.fetchScheduleList(startDate: startDate, endDate: endDate)
        return responseDTO.scheduleHeadDtos.map { $0.convertToSchedule() }
    }
    
    public func fetchLocalCalendarScheduleList(startDate: String, endDate: String) async throws -> [Schedule] {
        let format = DateFormatType.yearMonthDay
        let calendar = Calendar.current
        
        guard let startDay = Date.convertFromString(startDate, format: format),
              let endDay = Date.convertFromString(endDate, format: format) else {
            throw TDDataError.convertDTOFailure
        }
        
        let rangeStartDate = calendar.startOfDay(for: startDay)
        
        guard let rangeEndDate = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: endDay)) else {
            throw TDDataError.convertDTOFailure
        }
        
        let events = try await storage.fetchEvents(from: rangeStartDate, to: rangeEndDate)
        
        return mapToSchedules(from: events)
    }
    
    private func mapToSchedules(from events: [EKEvent]) -> [Schedule] {
        return events.map { event in
            return Schedule(
                id: event.eventIdentifier.hashValue,
                title: event.title ?? "",
                category: TDCategory(colorHex: "#FFFFFF", imageName: "none"),
                startDate: event.startDate.convertToString(formatType: .yearMonthDay),
                endDate: event.endDate.convertToString(formatType: .yearMonthDay),
                isAllDay: event.isAllDay,
                time: event.isAllDay ? nil : event.startDate.convertToString(formatType: .time24Hour),
                repeatDays: nil,
                alarmTime: nil,
                place: event.location,
                memo: event.notes,
                isFinished: false,
                scheduleRecords: nil,
                source: .localCalendar
            )
        }
    }
    
    public func finishSchedule(scheduleId: Int, isComplete: Bool, queryDate: String) async throws {
        try await service.finishSchedule(scheduleId: scheduleId, isComplete: isComplete, queryDate: queryDate)
    }
    
    public func updateSchedule(scheduleId: Int, isOneDayDeleted: Bool, queryDate: String, scheduleData: Schedule) async throws {
        let scheduleData = ScheduleDataDTO(schedule: scheduleData)
        let scheduleUpdateRequestDTO = ScheduleUpdateRequestDTO(
            scheduleId: scheduleId,
            isOneDayDeleted: isOneDayDeleted,
            queryDate: queryDate,
            scheduleData: scheduleData
        )
        try await service.updateSchedule(schedule: scheduleUpdateRequestDTO)
    }
    
    public func deleteSchedule(scheduleId: Int, isOneDayDeleted: Bool, queryDate: String) async throws {
        try await service.deleteSchedule(
            scheduleId: scheduleId,
            isOneDayDeleted: isOneDayDeleted,
            queryDate: queryDate
        )
    }
}
