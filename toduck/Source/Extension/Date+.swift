import Foundation
import Then

extension Date {
    enum DateFormatType {
        case yearMonth
        case time12Hour
        case time12HourEnglish
        case time24Hour
        
        var formatter: DateFormatter {
            switch self {
            case .yearMonth:
                return DateFormatter().then {
                    $0.dateFormat = "yyyy년 MM월"
                }
            case .time12Hour:
                return DateFormatter().then {
                    $0.dateFormat = "a h시 m분"
                    $0.amSymbol = "오전"
                    $0.pmSymbol = "오후"
                }
            case .time12HourEnglish:
                return DateFormatter().then {
                    $0.dateFormat = "a h:mm"
                    $0.amSymbol = "AM"
                    $0.pmSymbol = "PM"
                }
            case .time24Hour:
                return DateFormatter().then {
                    $0.dateFormat = "HH:mm"
                }
            }
        }
    }
    
    // MARK: - Date 타입을 String으로 변환
    static func stringFromDate(_ date: Date, formatType: DateFormatType = .yearMonth) -> String {
        return formatType.formatter.string(from: date)
    }
    
    // MARK: - String 타입을 Date 타입으로 변환
    static func dateFromString(_ dateString: String, format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: dateString)
    }
    
    static func timeFromString(_ timeString: String, use24HourFormat: Bool = false) -> Date? {
        let formatType: DateFormatType = use24HourFormat ? .time24Hour : .time12Hour
        return formatType.formatter.date(from: timeString)
    }
    
    // MARK: - N시간 전, N초 같은 상대시간을 표시해주는 함수
    static func relatveTimeFromDate(_ time: Date) -> String {
        let now = Date()
        let diff = Int(now.timeIntervalSince(time))
        
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        let month = 30 * day
        let year = 365 * day
        
        if diff < minute {
            return diff < 5 ? "방금 전" : "\(diff)초 전"
        } else if diff < hour {
            return "\(diff / minute)분 전"
        } else if diff < day {
            return "\(diff / hour)시간 전"
        } else if diff < week {
            return "\(diff / day)일 전"
        } else if diff < month {
            return "\(diff / week)주 전"
        } else if diff < year {
            return "\(diff / month)개월 전"
        } else {
            return "\(diff / year)년 전"
        }
    }
}
