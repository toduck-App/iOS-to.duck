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
    private var selectedDayViewTopConstraint: Constraint?
    private var selectedDayViewTopExpanded: CGFloat = 0
    private var selectedDayViewTopCollapsed: CGFloat = 0
    private var selectedDayViewTopHidden: CGFloat = 0
    
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
        calendar.backgroundColor = .red
        setupUI()
        setupGesture()
        selectToday()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateConstants()
    }
    
    func updateConstants() {
        let safeAreaTop = view.safeAreaInsets.top
        let calendarHeaderTopOffset: CGFloat = 30
        let calendarHeaderHeight = calendarHeader.frame.height
        let calendarTopOffset: CGFloat = 20
        let calendarHeight = calendar.frame.height

        selectedDayViewTopExpanded = safeAreaTop + calendarHeaderTopOffset + calendarHeaderHeight
        selectedDayViewTopCollapsed = selectedDayViewTopExpanded + calendarTopOffset + calendarHeight
        selectedDayViewTopHidden = view.bounds.height
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
            self.selectedDayViewTopConstraint = $0.top.equalTo(view).offset(50).constraint
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func setupGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        panGesture.delegate = self // 제스처 인식기 delegate 설정
        view.addGestureRecognizer(panGesture)
    }
    
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view).y
        let velocity = gesture.velocity(in: view).y

        switch gesture.state {
        case .changed:
            var newTop = (selectedDayViewTopConstraint?.layoutConstraints.first?.constant ?? selectedDayViewTopCollapsed) + translation
            newTop = max(selectedDayViewTopExpanded, min(selectedDayViewTopHidden, newTop))
            selectedDayViewTopConstraint?.update(offset: newTop)
            gesture.setTranslation(.zero, in: view)
            view.layoutIfNeeded()

        case .ended, .cancelled:
            let currentTop = selectedDayViewTopConstraint?.layoutConstraints.first?.constant ?? selectedDayViewTopCollapsed
            let shouldExpand: Bool
            let shouldHide: Bool

            if abs(velocity) > 500 {
                shouldExpand = velocity < 0
                shouldHide = velocity > 0 && currentTop > selectedDayViewTopCollapsed + 100
            } else {
                let middlePosition = (selectedDayViewTopCollapsed + selectedDayViewTopExpanded) / 2
                shouldExpand = currentTop < middlePosition
                shouldHide = currentTop >= selectedDayViewTopHidden - 100
            }

            let targetTop: CGFloat
            if shouldExpand {
                targetTop = selectedDayViewTopExpanded
            } else if shouldHide {
                targetTop = selectedDayViewTopHidden
            } else {
                targetTop = selectedDayViewTopCollapsed
            }

            UIView.animate(withDuration: 0.3, animations: {
                self.selectedDayViewTopConstraint?.update(offset: targetTop)
                self.view.layoutIfNeeded()
            })

        default:
            break
        }
    }
    
    func selectToday() {
        let today = Date()
        calendar.select(today)
        selectedDayScheduleView.updateDateLabel(date: today)
    }
}

extension ToduckCalendarViewController: UIGestureRecognizerDelegate {
    // 다른 제스처 인식기와 동시에 인식할 수 있도록 설정
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true // 두 개의 제스처를 동시에 인식하게 허용
    }
    
    // 스크롤뷰 또는 내부 콘텐츠가 패닝 제스처를 차단하지 않도록 허용
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        // selectedDayScheduleView의 터치도 허용
        if touch.view?.isDescendant(of: selectedDayScheduleView) ?? false {
            return true
        }
        return true
    }
}

extension ToduckCalendarViewController: TDCalendarConfigurable {
    func calendar(
        _ calendar: FSCalendar,
        didSelect date: Date,
        at monthPosition: FSCalendarMonthPosition
    ) {
        selectedDayScheduleView.updateDateLabel(date: date)
    }
    
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
