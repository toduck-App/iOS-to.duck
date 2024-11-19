//
//  FocusCalendar.swift
//  toduck
//
//  Created by 박효준 on 9/8/24.
//

import FSCalendar
import SnapKit
import Then
import UIKit

public final class DiaryCalendar: BaseCalendar {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.register(DiaryCalendarSelectDateCell.self, forCellReuseIdentifier: DiaryCalendarSelectDateCell.identifier)
        self.appearance.selectionColor = .clear
    }
}

