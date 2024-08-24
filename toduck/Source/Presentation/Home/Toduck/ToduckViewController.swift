//
//  ToduckViewController.swift
//  toduck
//
//  Created by 박효준 on 7/28/24.
//

import UIKit
import SnapKit
import Then

final class ToduckViewController: UIViewController {
    
    let calendarView = UICalendarView().then {
        $0.backgroundColor = .systemBackground
        $0.tintColor = TDColor.Diary.angry
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCalendarView()
    }
}

extension ToduckViewController {
    private func setCalendarView() {
        view.addSubview(calendarView)
        
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        calendarView.snp.makeConstraints {
            $0.centerX.equalTo(view)
            $0.width.equalTo(view.snp.width).multipliedBy(0.9)
        }
    }
}
