//
//  DateUtils.swift
//  toduck
//
//  Created by 박효준 on 6/5/24.
//

import Foundation

struct DateUtils {
    // MARK: Date의 날짜를 문자열로 변환
    static func stringFromDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 M월 d일"
        
        return dateFormatter.string(from: date)
    }
    
    // MARK: Date의 시간을 문자열로 변환
    static func stringFromTime(_ time: Date,
                               use24HourFormat: Bool = false) -> String {
        let dateFormatter = DateFormatter()
        if use24HourFormat {
            dateFormatter.dateFormat = "HH:mm"
        }else {
            dateFormatter.dateFormat = "a h시 m분"
            dateFormatter.amSymbol = "오전"
            dateFormatter.pmSymbol = "오후"
        }
        
        return dateFormatter.string(from: time)
    }
}

//// MARK: - 날짜를 Date 타입으로 변환
//// 날짜/시간을 저장하거나 연산할 때 유용
//static func dateFromString(_ dateString: String,
//                           format: String) -> Date? {
//    let dateFormatter = DateFormatter()
//    dateFormatter.dateFormat = format
//    
//    return dateFormatter.date(from: dateString)
//}
//
//// MARK: 시간을 Date 타입으로 변환
//static func timeFromString(_ timeString: String,
//                           use24HourFormat: Bool) -> Date? {
//    let dateFormatter = DateFormatter()
//    if use24HourFormat {
//        dateFormatter.dateFormat = "HH:mm"
//    }else {
//        dateFormatter.dateFormat = "a h시 m분"
//        dateFormatter.amSymbol = "오전"
//        dateFormatter.pmSymbol = "오후"
//    }
//    
//    return dateFormatter.date(from: timeString)
//}
