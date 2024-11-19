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

public final class SheetCalendar: BaseCalendar {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.allowsMultipleSelection = true
        self.register(SheetCalendarSelectDateCell.self, forCellReuseIdentifier: SheetCalendarSelectDateCell.identifier)
        self.appearance.selectionColor = .clear
    }
}
