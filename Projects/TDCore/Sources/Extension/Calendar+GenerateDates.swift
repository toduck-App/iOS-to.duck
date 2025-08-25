import Foundation

extension Calendar {
    public func generateDates(from startDate: Date, to endDate: Date) -> [Date] {
        var dates: [Date] = []
        var currentDate = startDate.stripTime()
        
        while currentDate <= endDate {
            dates.append(currentDate)
            guard let nextDate = self.date(byAdding: .day, value: 1, to: currentDate) else { break }
            currentDate = nextDate
        }
        
        return dates
    }
    
    /// 지금 기준으로 다음 "정각(00분 00초)"을 반환
    /// 예) 10:17:xx -> 11:00:00, 10:00:00 정확히면 -> 11:00:00
    public func nextHour(after now: Date) -> Date {
        var comps = self.dateComponents([.year, .month, .day, .hour], from: now)
        comps.minute = 0
        comps.second = 0
        let thisTop = self.date(from: comps)! // yyyy-MM-dd HH:00:00

        if now < thisTop {
            return thisTop
        } else {
            return self.date(byAdding: .hour, value: 1, to: thisTop)!
        }
    }
}
