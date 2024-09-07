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
    var calendarHeader = CalendarHeaderStackView(type: .mood)
    var calendar = FocusCalendar()
    let focusDates = [
        Calendar.current.date(from: DateComponents(year: 2024, month: 9, day: 1)),
        Calendar.current.date(from: DateComponents(year: 2024, month: 9, day: 2)),
        Calendar.current.date(from: DateComponents(year: 2024, month: 9, day: 3))
    ].compactMap { $0 }
    
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

// MARK: - DataSource

extension FocusCalendarViewController {
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
  
        guard let cell = calendar.dequeueReusableCell(withIdentifier: FocusCalendarSelectDateCell.identifier, for: date, at: position) as? FocusCalendarSelectDateCell else { return FSCalendarCell() }
        if focusDates.contains(date) {
            cell.backImageView.image = TDImage.cameraSmall
            cell.backImageView.alpha = 0.5
        }

        return cell
    }
}
