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
}

// MARK: - Date <-> String 타입변환 Extension
extension Date {
    
    /// String을 Format을 지정하여 Date?으로 변환합니다.
    ///
    /// - Date.dateFromString("2021년 1월", format: .yearMonth) -> 2021-01-01 00:00:00 +0000
    /// - Parameters:
    ///   - dateString: format과 일치하는 String형을 입력
    ///   - format: DateFormatType으로 직접 format을 지정할 수 있음
    /// - Returns: Date? 타입으로 반환
    static func dateFromString(_ dateString: String, format: DateFormatType) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.formatter.dateFormat
        return dateFormatter.date(from: dateString)
    }
    /// Date을 Format을 지정하여 String 타입으로 변환합니다.
    ///
    /// Date.stringFromDate("2021-01-01", formatType: .yearMonth) -> "2021년 1월"
    /// - Parameters:
    ///   - date: date 타입의 값을 입력
    ///   - formatType: DateFormatType으로 직접 format을 지정할 수 있음
    /// - Returns: Format에 맞는 String형 반환
    static func stringFromDate(_ date: Date, formatType: DateFormatType = .yearMonth) -> String {
        return formatType.formatter.string(from: date)
    }
}

// MARK: - Format으로 표현할 수 없는 경우의 Date Extension
extension Date {
    /// pram의 Date와 현재 시간을 비교하는 상대시간을 String으로 반환하는 함수
    /// - Parameter date: Date 타입의 값을 입력
    /// - Returns: 1시간전, 1일전, 1주전, 1개월전, 1년전과 같은 상대시간을 반환
    static func relatveTimeFromDate(_ date: Date) -> String {
        let now = Date()
        let diff = Int(now.timeIntervalSince(date))
        
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
