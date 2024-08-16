//
//  BaseCalendarViewController.swift
//  toduck
//
//  Created by 박효준 on 8/16/24.
//

import UIKit
import FSCalendar
import SnapKit
import Then

class BaseCalendar: FSCalendar {
    let headerDateFormatter = DateFormatter().then { $0.dateFormat = "yyyy년 M월" }
    let dateFormatter = DateFormatter().then { $0.dateFormat = "yyyy-MM-dd" }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setCalendar()
        setHeader()
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setCalendar()
        setHeader()
    }
    
    private func setCalendar() {
        self.delegate = self
        
        self.backgroundColor = .white
        self.locale = Locale(identifier: "ko_KR")
        self.scrollDirection = .horizontal
        self.scope = .month
        self.placeholderType = .none // 인접한 달 첫주,마지막주 제거
        self.appearance.headerMinimumDissolvedAlpha = 0.0 // 인접한 달 헤더 제거
        self.appearance.todayColor = .clear // 오늘 날짜 동그라미 색상 제거
        self.appearance.selectionColor = TDColor.Primary.primary100
        self.appearance.weekdayTextColor = TDColor.Neutral.neutral600
    }
    
    // HeaderStackView는 각각의 Calendar에서 커스텀하게 해뒀습니다 (stackView 내용이 다 다름)
    private func setHeader() {
        self.calendarHeaderView.isHidden = true
        self.headerHeight = 0
    }
}

// MARK: - FSCalendarDelegate
/// 클릭됐을 때 동작
extension BaseCalendar: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateString = dateFormatter.string(from: date)
        print("선택된 날짜: \(dateString)")
    }
}

// MARK: - FSCalendarDelegateAppearance
/// 데코레이션 관리 (텍스트 색, 점 색.. 등등)
extension BaseCalendar: FSCalendarDelegateAppearance {
    // 기본 폰트 색상 설정
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        return colorForDate(date)
    }
    
    // 선택된 날짜에 대한 폰트 색상 설정
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleSelectionColorFor date: Date) -> UIColor? {
        return colorForDate(date)
    }
    
    // 공통된 날짜 색상 로직 처리
    private func colorForDate(_ date: Date) -> UIColor? {
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
