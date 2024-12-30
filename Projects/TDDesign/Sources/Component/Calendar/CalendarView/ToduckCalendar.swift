//
//  TDCalendar.swift
//  toduck
//
//  Created by 박효준 on 8/11/24.
//

import UIKit
import SnapKit
import Then
import FSCalendar

public final class ToduckCalendar: BaseCalendar {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    private func setup() {
        self.register(
            SheetCalendarSelectDateCell.self,
            forCellReuseIdentifier: SheetCalendarSelectDateCell.identifier
        )
        self.appearance.selectionColor = TDColor.Primary.primary100
        self.appearance.titleSelectionColor = .black
        self.appearance.todayColor = TDColor.Primary.primary500
    }
}
