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

class HomeViewController: BaseViewController<BaseView>, TDSheetPresentation {

    let calendarHeader = CalendarHeaderStackView(type: .toduck)
    let baseCalendar = BaseCalendar()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(calendarHeader)
        view.addSubview(baseCalendar)
        
        calendarHeader.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(15)
        }
        
        baseCalendar.snp.makeConstraints {
            $0.centerX.equalTo(view)
            $0.top.equalTo(calendarHeader.snp.top).offset(100)
            $0.width.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.9)
            $0.height.equalTo(400)
        }
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
