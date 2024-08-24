//
//  HomeViewController.swift
//  toduck
//
//  Created by 박효준 on 7/15/24.
//

import UIKit
import FSCalendar
import SnapKit
import Then

class HomeViewController: BaseViewController<BaseView>, TDSheetPresentation, TDCalendarConfigurable {
    var calendarHeader = CalendarHeaderStackView(type: .sheet)
    var calendar = SheetCalendar()
    
    let headerDateFormatter = DateFormatter().then { $0.dateFormat = "yyyy년 M월" }
    let dateFormatter = DateFormatter().then { $0.dateFormat = "yyyy-MM-dd" }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
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


// MARK: - FSCalendarDelegate
/// 클릭됐을 때 동작
extension HomeViewController {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateString = dateFormatter.string(from: date)
        print("선택된 날짜: \(dateString)")
    }
    
    // FSCalendarDelegate 메소드, 페이지 바뀔 때마다 실행됨
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        updateHeaderLabel(for: calendar.currentPage)
    }
}

// MARK: - FSCalendarDelegateAppearance
/// 데코레이션 관리 (텍스트 색, 점 색.. 등등)
extension HomeViewController {
    // 기본 폰트 색
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        colorForDate(date)
    }
    
    // 선택된 날짜 폰트 색 (이걸 안 하면 오늘날짜와 토,일 선택했을 때 폰트색이 바뀜)
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleSelectionColorFor date: Date) -> UIColor? {
        colorForDate(date)
    }
}

//class HomeViewController: UIViewController, TDSheetPresentation {
//    let segmentedControl = TDSegmentedController(items: ["토덕", "일정", "루틴"])
//    
//    let todoViewController = ToduckViewController()
//    let scheduleViewController = ScheduleViewController()
//    let routineViewController = RoutineViewController()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        self.view.backgroundColor = .systemBackground
//        setupSegmentedControl()
//        setupViewControllers()
//    }
//    
//    private func setupSegmentedControl() {
//        view.addSubview(segmentedControl)
//        
//        segmentedControl.snp.makeConstraints { make in
//            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
//            make.leading.equalToSuperview().offset(16)
//            make.width.equalTo(180)
//            make.height.equalTo(43)
//        }
//        
//        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
//    }
//    
//    private func setupViewControllers() {
//        addChild(todoViewController)
//        addChild(scheduleViewController)
//        addChild(routineViewController)
//        
//        view.addSubview(todoViewController.view)
//        view.addSubview(scheduleViewController.view)
//        view.addSubview(routineViewController.view)
//        
//        todoViewController.didMove(toParent: self)
//        scheduleViewController.didMove(toParent: self)
//        routineViewController.didMove(toParent: self)
//        
//        todoViewController.view.snp.makeConstraints { make in
//            make.top.equalTo(segmentedControl.snp.bottom).offset(20)
//            make.leading.trailing.bottom.equalToSuperview()
//        }
//        
//        scheduleViewController.view.snp.makeConstraints { make in
//            make.top.equalTo(segmentedControl.snp.bottom).offset(20)
//            make.leading.trailing.bottom.equalToSuperview()
//        }
//        
//        routineViewController.view.snp.makeConstraints { make in
//            make.top.equalTo(segmentedControl.snp.bottom).offset(20)
//            make.leading.trailing.bottom.equalToSuperview()
//        }
//    }
//    
//    @objc private func segmentChanged() {
//        updateView()
//    }
//    
//    private func updateView() {
//        todoViewController.view.isHidden = segmentedControl.selectedSegmentIndex != 0
//        scheduleViewController.view.isHidden = segmentedControl.selectedSegmentIndex != 1
//        routineViewController.view.isHidden = segmentedControl.selectedSegmentIndex != 2
//    }
//}
