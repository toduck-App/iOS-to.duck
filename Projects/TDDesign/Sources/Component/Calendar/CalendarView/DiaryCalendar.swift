import FSCalendar
import SnapKit
import Then
import UIKit

public final class DiaryCalendar: BaseCalendar {
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
            DiaryCalendarSelectDateCell.self,
            forCellReuseIdentifier: DiaryCalendarSelectDateCell.identifier
        )
        self.appearance.selectionColor = .clear
    }
}

