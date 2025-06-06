import FSCalendar
import SnapKit
import Then
import UIKit

public class BaseCalendar: FSCalendar, FSCalendarDataSource, FSCalendarDelegate {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupHeader()
        setupCalendar()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupHeader()
        setupCalendar()
    }
    
    private func setupCalendar() {
        self.placeholderType = .none  // 인접한 달 첫주,마지막주 제거
        self.today = nil // 오늘 선택 해제
        self.backgroundColor = .white
        self.locale = Locale(identifier: "ko_KR")
        self.scrollDirection = .horizontal
        self.scope = .month
        
        self.appearance.headerMinimumDissolvedAlpha = 0.0 // 인접한 달 헤더 제거
        self.appearance.selectionColor = TDColor.Primary.primary100
        self.appearance.weekdayTextColor = TDColor.Neutral.neutral600
    }
    
    // calendarHeaderView는 CalendarHeaderStackView를 사용합니다.
    private func setupHeader() {
        self.calendarHeaderView.isHidden = true
        self.headerHeight = 0
    }
}
