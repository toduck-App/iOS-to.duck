//
//  TDCalendarConfigurable.swift
//  toduck
//
//  Created by 박효준 on 8/18/24.
//

import UIKit
import FSCalendar

// TODO: 이 프로토콜을 채택하면, Diary Sheet TD 자식 캘린더를 쓰는 뷰컨에서 문제 발생
// associatedtype으로 해결 (프로토콜 계의 제네릭)

// TODO: BaseCalendar에 넣으면 되지, 왜 TDCalendarConfigurable을 사용하나 ?
/// 모듈 느낌으로 분리하고 싶었음
/// DiaryCalendar 같은 경우, 토일은 색이 들어가지 않음 -> DiaryCalendar를 쓰는 뷰컨은 이 프로토콜을 채택 안 하게..? 하려했음
protocol TDCalendarConfigurable: FSCalendarDelegateAppearance,
                                    FSCalendarDelegate where Self: UIViewController {
    associatedtype CalendarType: BaseCalendar
    
    var calendarHeader: CalendarHeaderStackView { get }
    var calendar: CalendarType { get }
    
    func setupCalendar()
    func updateHeaderLabel(for date: Date)
}

extension TDCalendarConfigurable {
    func setupCalendar() {
        view.addSubview(calendarHeader)
        view.addSubview(calendar)
        calendar.delegate = self
        
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0 // 인접한 달 헤더 제거
        calendar.appearance.todayColor = .clear // 오늘 날짜 동그라미 색상 제거
        calendar.appearance.selectionColor = TDColor.Primary.primary100
        calendar.appearance.weekdayTextColor = TDColor.Neutral.neutral600
        updateHeaderLabel(for: calendar.currentPage)
    }
    
    func updateHeaderLabel(for date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 M월"
        
        if let headerLabel = calendarHeader.arrangedSubviews.compactMap({ $0 as? TDLabel }).first {
            headerLabel.setText(dateFormatter.string(from: date))
        }
    }
    
    // 공통된 날짜 색상 로직 처리
    func colorForDate(_ date: Date) -> UIColor? {
        let weekday = Calendar.current.component(.weekday, from: date)
        
        // 오늘 날짜 확인
        if Calendar.current.isDate(date, inSameDayAs: Date()) {
            return TDColor.Primary.primary500
        }
        
        // 요일별 색상 설정
        switch weekday {
        case 1:  // 일요일
            return TDColor.Semantic.error
        case 7:  // 토요일
            return TDColor.Schedule.text6
        default:
            return TDColor.Neutral.neutral800
        }
    }
}
