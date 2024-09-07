//
//  FocusCalendarViewController.swift
//  toduck
//
//  Created by 박효준 on 9/8/24.
//

import FSCalendar
import SnapKit
import Then
import UIKit


class FocusCalendarViewController: BaseViewController<BaseView>, TDCalendarConfigurable {
    var calendarHeader = CalendarHeaderStackView(type: .diary)
    var calendar = FocusCalendar()
    
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

extension FocusCalendarViewController {
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
  
        guard let cell = calendar.dequeueReusableCell(withIdentifier: FocusCalendarSelectDateCell.identifier, for: date, at: position) as? FocusCalendarSelectDateCell else { return FSCalendarCell() }
        
        cell.backImageView.image = TDImage.cameraSmall
        
        // 현재 선택되어 있는 날짜인지 확인 후 배경 이미지의 alpha값을 조절한다
        cell.backImageView.alpha = 0.5

        return cell
    }
}
