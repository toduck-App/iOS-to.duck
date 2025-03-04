import TDDesign
import UIKit
import FSCalendar
import SnapKit
import TDCore

final class DiaryViewController: BaseViewController<BaseView> {
    weak var coordinator: DiaryCoordinator?
    let calendarHeader = CalendarHeaderStackView(type: .toduck)
    let calendar = DiaryCalendar()
    
    override func configure() {
        view.backgroundColor = TDColor.baseWhite
        setupCalendar()
        setupNavigationBar(style: .diary, navigationDelegate: coordinator!) { [weak self] in
            TDLogger.debug("MyPageViewController - setupNavigationBar")
            self?.coordinator?.didTapAlarmButton()
        }
    }
    
    override func layout() {
        calendarHeader.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(56)
        }
        
        calendar.snp.makeConstraints {
            $0.top.equalTo(calendarHeader.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(360)
        }
    }
}

extension DiaryViewController: TDCalendarConfigurable {
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        updateHeaderLabel(for: calendar.currentPage)
    }
}
