//
//  Date+.swift
//  toduck
//
//  Created by 박효준 on 6/11/24.
//

import Foundation
import Then

extension Date {
    private static let dateFormatter = DateFormatter().then {
        $0.dateFormat = "yyyy년 MM월"
    }
    
    private static let timeFormatter12Hour = DateFormatter().then {
        $0.dateFormat = "a h시 m분"
        $0.amSymbol = "오전"
        $0.pmSymbol = "오후"
    }
    
    private static let timeFormatter24Hour = DateFormatter().then {
        $0.dateFormat = "HH:mm"
    }
    
    // MARK: - Date 타입을 String으로 변환
    static func stringFromDate(_ date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    
    static func stringFromTime(_ time: Date, use24HourFormat: Bool = false) -> String {
        let formatter = use24HourFormat ? timeFormatter24Hour : timeFormatter12Hour
        
        return formatter.string(from: time)
    }
    
    // MARK: - String 타입을 Date 타입으로 변환
    static func dateFromString(_ dateString: String, format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.date(from: dateString)
    }
    
    static func timeFromString(_ timeString: String, use24HourFormat: Bool = false) -> Date? {
        let formatter = use24HourFormat ? timeFormatter24Hour : timeFormatter12Hour
        
        return formatter.date(from: timeString)
    }
}
