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
    private let contentView = UIView()
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 24
        $0.alignment = .fill
        $0.distribution = .fill
    }
    let analyzeView = DiaryAnalyzeView(diaryCount: 25, focusPercent: 55)
    let calendarContainerView = UIView()
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
        stackView.addArrangedSubview(calendarContainerView)
        calendarContainerView.addSubview(calendarHeader)
        calendarContainerView.addSubview(diarySegmentedControl)
        calendarContainerView.addSubview(calendar)
    }
    
    override func configure() {
        calendarContainerView.backgroundColor = TDColor.baseWhite
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
            $0.height.equalTo(230)
        }
        calendarContainerView.snp.makeConstraints {
            $0.height.equalTo(456)
        }
        calendarHeader.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(56)
        }
        diarySegmentedControl.snp.makeConstraints {
            $0.top.equalTo(calendarHeader.snp.bottom)
            $0.leading.equalToSuperview().offset(16)
            $0.height.equalTo(48)
        }
        calendar.snp.makeConstraints {
            $0.top.equalTo(diarySegmentedControl.snp.bottom).offset(36)
            $0.leading.trailing.bottom.equalToSuperview().inset(20)
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
