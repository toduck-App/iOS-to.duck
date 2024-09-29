//
//  CalendarViewController.swift
//  toduck
//
//  Created by 박효준 on 9/29/24.
//

import FSCalendar
import SnapKit
import Then
import UIKit

struct TempSchedule {
    let name: String
    let color: UIColor
}

final class ToduckCalendarViewController: BaseViewController<BaseView> {
    // MARK: - UI Components
    let calendarHeader = CalendarHeaderStackView(type: .toduck)
    let calendar = ToduckCalendar()
    private let selectedDayScheduleView = SelectedDayScheduleView()
    
    // MARK: - Properties
    let tempSchedules: [Int: [TempSchedule]] = [
        15: [
            TempSchedule(name: "테스트1", color: .red),
            TempSchedule(name: "테스트2", color: .blue),
            TempSchedule(name: "테스트2", color: .blue),
            TempSchedule(name: "테스트2", color: .blue)
        ],
        16: [
            TempSchedule(name: "테스트3", color: .green),
            TempSchedule(name: "테스트4", color: .yellow)
        ],
        17: [
            TempSchedule(name: "테스트5", color: .purple),
            TempSchedule(name: "테스트6", color: .orange)
        ],
        18: [
            TempSchedule(name: "테스트7", color: .brown),
            TempSchedule(name: "테스트8", color: .cyan)
        ],
        19: [
            TempSchedule(name: "테스트9", color: .magenta),
            TempSchedule(name: "테스트10", color: .systemPink)
        ],
        20: [
            TempSchedule(name: "테스트11", color: .systemTeal),
            TempSchedule(name: "테스트12", color: .systemIndigo)
        ],
        21: [
            TempSchedule(name: "테스트13", color: .systemGray),
            TempSchedule(name: "테스트14", color: .systemYellow)
        ]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
}

private extension ToduckCalendarViewController {
    func setupUI() {
        addSubviews()
        setupCalendar()
        setupConstraints()
    }
    
    func addSubviews() {
        view.addSubview(calendarHeader)
        view.addSubview(calendar)
        view.addSubview(selectedDayScheduleView)
    }
    
    func setupConstraints() {
        calendarHeader.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(15)
        }
        calendar.snp.makeConstraints {
            $0.centerX.equalTo(view)
            $0.top.equalTo(calendarHeader.snp.bottom).offset(20)
            $0.width.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.9)
            $0.height.equalTo(334)
        }
        selectedDayScheduleView.snp.makeConstraints {
            $0.top.equalTo(calendar.snp.bottom).offset(0)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension ToduckCalendarViewController: TDCalendarConfigurable {
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        updateHeaderLabel(for: calendar.currentPage)
    }
    
    // MARK: - 날짜 폰트 색상
    // 기본 폰트 색
    func calendar(
        _ calendar: FSCalendar,
        appearance: FSCalendarAppearance,
        titleDefaultColorFor date: Date
    ) -> UIColor? {
        colorForDate(date)
    }
    
    // 선택된 날짜 폰트 색 (이걸 안 하면 오늘날짜와 토,일 선택했을 때 폰트색이 바뀜)
    func calendar(
        _ calendar: FSCalendar,
        appearance: FSCalendarAppearance,
        titleSelectionColorFor date: Date
    ) -> UIColor? {
        colorForDate(date)
    }
    
    // MARK: - 날짜 아래의 이벤트
    // 날짜 아래 점 개수 지정
    func calendar(
        _ calendar: FSCalendar,
        numberOfEventsFor date: Date
    ) -> Int {
        let day = Calendar.current.component(.day, from: date)
        guard let schedules = tempSchedules[day] else { return 0 }
        return schedules.count
    }
    
    // 날짜 아래 점 색상 지정 (이벤트 색상)
    func calendar(
        _ calendar: FSCalendar,
        appearance: FSCalendarAppearance,
        eventDefaultColorsFor date: Date
    ) -> [UIColor]? {
        colorFromEvent(for: date)
    }
    
    // 선택된 날짜에도 동일한 이벤트 색상을 유지하도록 설정
    func calendar(
        _ calendar: FSCalendar,
        appearance: FSCalendarAppearance,
        eventSelectionColorsFor date: Date
    ) -> [UIColor]? {
        colorFromEvent(for: date)
    }
    
    // TODO: 나중에 TDCalendarConfigurable로 옮겨야 함, tempSchedules 생각하기
    // 날짜에 대한 일정 색상을 반환하는 헬퍼 메서드
    func colorFromEvent(for date: Date) -> [UIColor]? {
        let day = Calendar.current.component(.day, from: date)
        guard let schedules = tempSchedules[day] else { return nil }
        return schedules.map { $0.color }
    }
}
