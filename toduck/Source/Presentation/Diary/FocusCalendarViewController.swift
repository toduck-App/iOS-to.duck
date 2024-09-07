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
        Calendar.current.date(from: DateComponents(year: 2024, month: 9, day: 9)),
        Calendar.current.date(from: DateComponents(year: 2024, month: 9, day: 10)),
        Calendar.current.date(from: DateComponents(year: 2024, month: 9, day: 11))
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
        
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)

        if focusDates.contains(date) {
            cell.backImageView.image = TDImage.Memo.medium
            return cell
        }
        
        switch day {
        case 1:
            cell.backImageView.image = TDImage.Mood.sad
            cell.titleLabel = nil
        case 2:
            cell.backImageView.image = TDImage.Mood.angry
            cell.titleLabel = nil
        case 3:
            cell.backImageView.image = TDImage.Mood.tired
            cell.titleLabel = nil
        case 4:
            cell.backImageView.image = TDImage.Mood.calmness
            cell.titleLabel = nil
        case 5:
            cell.backImageView.image = TDImage.Mood.happy
            cell.titleLabel = nil
        case 6:
            cell.backImageView.image = TDImage.Mood.anxiety
            cell.titleLabel = nil
        default:
            cell.backImageView.image = nil
        }

        return cell
    }
}
