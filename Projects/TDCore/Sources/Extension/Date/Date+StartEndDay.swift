import Foundation

extension Date {
    public func startOfMonth() -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: self)
        return calendar.date(from: components)!
    }
    
    public func endOfMonth() -> Date {
        let calendar = Calendar.current
        if let startOfNextMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth()),
           let endOfMonth = calendar.date(byAdding: .day, value: -1, to: startOfNextMonth) {
            return endOfMonth
        }
        return self
    }
    
    public func startOfWeek(using calendar: Calendar = .current) -> Date? {
        let weekday = calendar.component(.weekday, from: self)
        let daysToSubtract = weekday - 1
        return calendar.date(byAdding: .day, value: -daysToSubtract, to: self.startOfDay())
    }
    
    public func endOfWeek(using calendar: Calendar = .current) -> Date? {
        guard let start = startOfWeek(using: calendar) else { return nil }
        return calendar.date(byAdding: .day, value: 6, to: start)
    }
    
    public func startOfDay() -> Date {
        calendar.startOfDay(for: self)
    }
    
    private var calendar: Calendar {
        var calendar = Calendar.current
        calendar.firstWeekday = 1
        return calendar
    }
}
