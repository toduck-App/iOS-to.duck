import FSCalendar
import SnapKit
import Then
import UIKit

public final class HomeCalendar: BaseCalendar {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    private func setup() {
        scope = .week
        appearance.selectionColor = TDColor.Neutral.neutral100
    }
}
