//
//  SheetCalendar.swift
//  toduck
//
//  Created by 박효준 on 8/13/24.
//

import FSCalendar
import SnapKit
import Then
import UIKit

final class SheetCalendar: BaseCalendar {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSheetCalendar()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSheetCalendar()
    }
    
    private func setupSheetCalendar() {
        self.allowsMultipleSelection = true
        self.register(SelectDatesCustomFSCalendarCell.self, forCellReuseIdentifier: SelectDatesCustomFSCalendarCell.identifier)
        self.appearance.selectionColor = .clear
    }
}
