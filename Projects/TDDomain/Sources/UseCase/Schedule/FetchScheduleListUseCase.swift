import TDCore
import Foundation

public protocol FetchScheduleListUseCase {
    func execute(startDate: String, endDate: String) async throws -> [Date: [Schedule]]
}

public final class FetchScheduleListUseCaseImpl: FetchScheduleListUseCase {
    private let repository: ScheduleRepository
    
    public init(repository: ScheduleRepository) {
        self.repository = repository
    }
    
    public func execute(
        startDate: String,
        endDate: String
    ) async throws -> [Date: [Schedule]] {
        let fetchedScheduleList = try await repository.fetchScheduleList(startDate: startDate, endDate: endDate)
        let filteredScheduleList = filterScheduleList(with: fetchedScheduleList, startDate: startDate, endDate: endDate)
        let buildScheduleDictionary = buildScheduleDictionary(with: filteredScheduleList, queryStartDate: startDate, queryEndDate: endDate)
        
        return buildScheduleDictionary
    }
    
    func filterScheduleList(
        with scheduleList: [Schedule],
        startDate: String,
        endDate: String
    ) -> [Schedule] {
        guard let start = Date.convertFromString(startDate, format: .yearMonthDay),
              let end = Date.convertFromString(endDate, format: .yearMonthDay) else {
            return []
        }
        
        let calendar = Calendar.current
        let allDates = calendar.generateDates(from: start, to: end)
        var filteredSchedules: Set<Schedule> = []
        
        for schedule in scheduleList {
            guard
                let scheduleStart = Date.convertFromString(schedule.startDate, format: .yearMonthDay),
                let scheduleEnd = Date.convertFromString(schedule.endDate, format: .yearMonthDay)
            else { continue }
            
            let isPeriod = scheduleStart != scheduleEnd
            let isRepeat = (schedule.repeatDays?.isEmpty == false)
            
            switch (isPeriod, isRepeat) {
            case (false, false):
                // 1. 기간 X + 반복 X → 하루만 표시
                if allDates.contains(scheduleStart) {
                    filteredSchedules.insert(schedule)
                }
                
            case (false, true):
                // 2. 기간 X + 반복 O → 모든 날짜 중 반복 요일에 포함된 날만
                // scheduleStart 이후 날짜만 체크
                for date in allDates where date >= scheduleStart {
                    if schedule.repeatDays!.contains(date.weekdayEnum()) {
                        filteredSchedules.insert(schedule)
                        break
                    }
                }
                
            case (true, false):
                // 3. 기간 O + 반복 X → 기간 내 모든 날짜
                if scheduleEnd < start || scheduleStart > end {
                    continue
                }
                filteredSchedules.insert(schedule)
                
            case (true, true):
                // 4. 기간 O + 반복 O → 기간 내의 반복 요일에만 표시
                for date in allDates {
                    guard let scheduleRepeatDays = schedule.repeatDays else { continue }
                    if (scheduleStart...scheduleEnd).contains(date),
                       scheduleRepeatDays.contains(date.weekdayEnum()) {
                        filteredSchedules.insert(schedule)
                        break
                    }
                }
            }
        }
        
        return Array(filteredSchedules)
    }
    
    func buildScheduleDictionary(
        with scheduleList: [Schedule],
        queryStartDate: String,
        queryEndDate: String
    ) -> [Date: [Schedule]] {
        guard
            let queryStartDate = Date.convertFromString(queryStartDate, format: .yearMonthDay),
            let queryEndDate = Date.convertFromString(queryEndDate, format: .yearMonthDay)
        else { return [:] }
        
        var scheduleDict: [Date: [Schedule]] = [:]
        let calendar = Calendar.current
        
        for schedule in scheduleList {
            guard
                let scheduleStartDate = Date.convertFromString(schedule.startDate, format: .yearMonthDay),
                let scheduleEndDate = Date.convertFromString(schedule.endDate, format: .yearMonthDay)
            else { continue }
            
            // 단일 일정 + 반복인 경우 effectiveEnd를 쿼리의 종료일로 설정
            let effectiveStartDate = max(scheduleStartDate, queryStartDate)
            let effectiveEndDate: Date
            
            if scheduleStartDate == scheduleEndDate && !(schedule.repeatDays?.isEmpty ?? true) {
                effectiveEndDate = queryEndDate
            } else {
                effectiveEndDate = min(scheduleEndDate, queryEndDate)
            }
            
            guard effectiveStartDate <= effectiveEndDate else { continue }
            
            let allDates = calendar.generateDates(from: effectiveStartDate, to: effectiveEndDate)
            let recordMap: [Date: ScheduleRecord] = schedule.scheduleRecords?.reduce(into: [:]) { dict, record in
                if let date = Date.convertFromString(record.recordDate, format: .yearMonthDay) {
                    dict[date] = record
                }
            } ?? [:]
            
            for date in allDates {
                guard let repeatDays = schedule.repeatDays, !repeatDays.isEmpty else {
                    // 반복 없는 경우 모든 날짜 추가
                    if let cloned = createClonedSchedule(schedule, date: date, recordMap: recordMap) {
                        let key = calendar.startOfDay(for: date)
                        scheduleDict[key, default: []].append(cloned)
                    }
                    continue
                }
                
                if repeatDays.contains(date.weekdayEnum()),
                   let cloned = createClonedSchedule(schedule, date: date, recordMap: recordMap) {
                    let key = calendar.startOfDay(for: date)
                    scheduleDict[key, default: []].append(cloned)
                }
            }
        }
        
        return scheduleDict
    }
    
    private func createClonedSchedule(
        _ schedule: Schedule,
        date: Date,
        recordMap: [Date: ScheduleRecord]
    ) -> Schedule? {
        if recordMap[date]?.deletedAt != nil {
            return nil
        }
        
        let isFinished = recordMap[date]?.isComplete ?? false
        return Schedule(
            id: schedule.id,
            title: schedule.title,
            category: schedule.category,
            startDate: schedule.startDate,
            endDate: schedule.endDate,
            isAllDay: schedule.isAllDay,
            time: schedule.time,
            repeatDays: schedule.repeatDays,
            alarmTime: schedule.alarmTime,
            place: schedule.place,
            memo: schedule.memo,
            isFinished: isFinished,
            scheduleRecords: schedule.scheduleRecords
        )
    }
}

extension Date {
    func weekdayEnum() -> TDWeekDay {
        let weekday = Calendar.current.component(.weekday, from: self)
        switch weekday {
        case 1: return .sunday
        case 2: return .monday
        case 3: return .tuesday
        case 4: return .wednesday
        case 5: return .thursday
        case 6: return .friday
        case 7: return .saturday
        default: return .monday
        }
    }
}
