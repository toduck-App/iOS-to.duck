import Foundation

extension Date {
    static public func timeSortKey(_ time: String?) -> Int {
        guard let time, time != "종일" else { return 0 }
        
        if let date = Date.convertFromString(time, format: .time24Hour) {
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: date)
            let minute = calendar.component(.minute, from: date)
            
            return hour * 60 + minute
        }
        
        return Int.max
    }
}
