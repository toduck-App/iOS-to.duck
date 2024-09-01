//
//  SheetsCalendarViewController.swift
//  toduck
//
//  Created by 박효준 on 9/1/24.
//

import FSCalendar
import SnapKit
import Then
import UIKit

// TODO: 우측 상단의 선택된 날짜에 대한 Label 처리
final class SheetCalendarViewController: BaseViewController<BaseView>, TDSheetPresentation, TDCalendarConfigurable {
    private var firstDate: Date?
    private var lastDate: Date?
    private var datesRange: [Date] = []
    var calendarHeader = CalendarHeaderStackView(type: .sheet)
    var calendar = SheetCalendar()
    var selectDates = TDLabel(toduckFont: TDFont.mediumHeader5).then {
        $0.text = ""
    }
    
    let headerDateFormatter = DateFormatter().then { $0.dateFormat = "yyyy년 M월" }
    let dateFormatter = DateFormatter().then { $0.dateFormat = "yyyy-MM-dd" }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupCalendar()
        calendarHeader.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(15)
        }
        
        calendar.snp.makeConstraints {
            $0.centerX.equalTo(view)
            $0.top.equalTo(calendarHeader.snp.top).offset(100)
            $0.width.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.9)
            $0.height.equalTo(400)
        }
    }
}

// MARK: - FSCalendarDelegateAppearance
/// 데코레이션 관리 (텍스트 색, 점 색.. 등등)
extension SheetCalendarViewController {
    // 기본 폰트 색
    func calendar(
        _ calendar: FSCalendar, appearance: FSCalendarAppearance,
        titleDefaultColorFor date: Date
    ) -> UIColor? {
        colorForDate(date)
    }
    
    // 선택된 날짜 폰트 색 (이걸 안 하면 오늘날짜와 토,일 선택했을 때 폰트색이 바뀜)
    func calendar(
        _ calendar: FSCalendar, appearance: FSCalendarAppearance,
        titleSelectionColorFor date: Date
    ) -> UIColor? {
        colorForDate(date)
    }
}

// MARK: - FSCalendarDelegate
/// 클릭됐을 때 동작
extension SheetCalendarViewController {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateString = dateFormatter.string(from: date)
        print("선택된 날짜: \(dateString)")
        
        // case 1. 달력에 아무 날짜도 선택되지 않은 경우
        if firstDate == nil {
            firstDate = date
            datesRange = [firstDate!]
            
            calendar.reloadData()
            return
        }
        
        // case 2. firstDate 단일선택 되어 있는 경우
        if firstDate != nil && lastDate == nil {
            // case 2-1. firstDate보다 이전 날짜 클릭 시, 단일 선택 날짜를 바꿔줌
            if date < firstDate! {
                calendar.deselect(firstDate!)
                firstDate = date
                datesRange = [firstDate!]
                
                calendar.reloadData()
                return
            }
            
            // case 2-2. 종료일이 선택된 경우
            else {
                var range: [Date] = []
                var currentDate = firstDate!
                
                while currentDate <= date {
                    range.append(currentDate)
                    currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
                }
                
                for day in range {
                    calendar.select(day)
                }
                
                lastDate = range.last
                datesRange = range
                
                calendar.reloadData()
                return
            }
        }
        
        // case 3. 시작일-종료일 선택된 상태에서 다른 날짜를 클릭하면, 해당 날짜를 firstDate로
        if firstDate != nil && lastDate != nil {
            for day in calendar.selectedDates {
                calendar.deselect(day)
            }
            
            lastDate = nil
            firstDate = date
            calendar.select(date)
            datesRange = [firstDate!]
            
            calendar.reloadData()
            return
        }
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let arr = datesRange
        if !arr.isEmpty {
            for day in arr {
                calendar.deselect(day)
            }
        }
        
        firstDate = nil
        lastDate = nil
        datesRange = []
        
        calendar.reloadData()
    }
    
    // FSCalendarDelegate 메소드, 페이지 바뀔 때마다 실행됨
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        updateHeaderLabel(for: calendar.currentPage)
    }
}

// MARK: - FSCalendarDataSource
/// 데코레이션 관리 (텍스트 색, 점 색.. 등등)
extension SheetCalendarViewController {
    func calendar(
        _ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition
    ) -> FSCalendarCell {
        guard let cell = calendar.dequeueReusableCell(
            withIdentifier: SheetCalendarSelectDateCell.identifier,
            for: date, at: position) as? SheetCalendarSelectDateCell
        else { return FSCalendarCell() }
        
        let dateType = typeOfDate(date)
        cell.updateBackImage(dateType) // 현재 그리는 셀의 date 타입에 의해서 셀 디자인
        
        return cell
    }
    
    // 날짜 유형을 계산하는 메서드
    private func typeOfDate(_ date: Date) -> SelectedDateType {
        let arr = datesRange
        
        if !arr.contains(date) { return .notSelected }
        if arr.count == 1 && date == firstDate { return .singleDate }
        if date == firstDate { return .firstDate }
        if date == lastDate { return .lastDate }
        else { return .middleDate }
    }
}
