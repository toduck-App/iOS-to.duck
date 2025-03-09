import TDDesign
import UIKit
import FSCalendar
import SnapKit
import TDCore

final class DiaryViewController: BaseViewController<BaseView> {
    // MARK: - UI Components
    let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.alwaysBounceVertical = true
    }
    
    private let contentView = UIView() // scrollView 내부 컨텐츠를 담을 뷰
    
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 20
        $0.alignment = .fill
        $0.distribution = .fill
    }
    
    let analyzeView = DiaryAnalyzeView(diaryCount: 25, focusPercent: 55)
    let calendarHeader = CalendarHeaderStackView(type: .toduck)
    let diarySegmentedControl = TDSegmentedControl(items: ["기분", "집중도"])
    let calendar = DiaryCalendar()
    
    // MARK: - Properties
    weak var coordinator: DiaryCoordinator?
    
    override func addView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        
        // 스택뷰에 뷰들을 추가
        stackView.addArrangedSubview(analyzeView)
        stackView.addArrangedSubview(calendarHeader)
        stackView.addArrangedSubview(diarySegmentedControl)
        stackView.addArrangedSubview(calendar)
    }
    
    override func configure() {
        setupCalendar()
        setupNavigationBar(style: .diary, navigationDelegate: coordinator!) { [weak self] in
            TDLogger.debug("MyPageViewController - setupNavigationBar")
            self?.coordinator?.didTapAlarmButton()
        }
    }
    
    override func layout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        analyzeView.snp.makeConstraints {
            $0.height.equalTo(220)
        }
        
        calendarHeader.snp.makeConstraints {
            $0.height.equalTo(56)
        }
        
        diarySegmentedControl.snp.makeConstraints {
            $0.height.equalTo(32)
        }
        
        calendar.snp.makeConstraints {
            $0.height.equalTo(360)
        }
    }
}

extension DiaryViewController: TDCalendarConfigurable {
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        updateHeaderLabel(for: calendar.currentPage)
    }
    
    func calendar(
        _ calendar: FSCalendar,
        cellFor date: Date,
        at position: FSCalendarMonthPosition
    ) -> FSCalendarCell {
        guard let cell = calendar.dequeueReusableCell(
            withIdentifier: DiaryCalendarSelectDateCell.identifier,
            for: date,
            at: position
        ) as? DiaryCalendarSelectDateCell else { return FSCalendarCell() }
        
        return cell
    }
}
