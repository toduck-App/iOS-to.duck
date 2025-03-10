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
        $0.delegate = nil
    }
    private let contentView = UIView()
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 24
        $0.alignment = .fill
        $0.distribution = .fill
    }
    
    /// 분석 뷰
    let analyzeView = DiaryAnalyzeView(diaryCount: 25, focusPercent: 55)
    
    /// 캘린더 뷰
    let calendarContainerView = UIView()
    let calendarHeader = CalendarHeaderStackView(type: .toduck)
    let diarySegmentedControl = TDSegmentedControl(items: ["기분", "집중도"])
    let calendar = DiaryCalendar()
    
    /// 일기가 없는 경우 보여지는 뷰
    let noDiaryContainerView = UIView()
    let noDiaryImageView = UIImageView().then {
        $0.image = TDImage.DiaryPercent.bookPercent0
        $0.contentMode = .scaleAspectFit
    }
    let noDiaryLabel = TDLabel(
        labelText: "일기를 작성하지 않았어요",
        toduckFont: TDFont.boldBody1,
        toduckColor: TDColor.Neutral.neutral600
    )
    
    /// 버튼 컨테이너 뷰 (기본은 투명)
    let diaryPostButtonContainerView = UIView().then {
        $0.backgroundColor = TDColor.Neutral.neutral50
        $0.layer.masksToBounds = false
    }
    let diaryPostButton = TDBaseButton(
        title: "일기 작성",
        backgroundColor: TDColor.Primary.primary500,
        foregroundColor: TDColor.baseWhite,
        font: TDFont.boldHeader3.font,
        radius: 12
    )
    
    // MARK: - Properties
    weak var coordinator: DiaryCoordinator?
    
    override func addView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        contentView.addSubview(diaryPostButtonContainerView)
        
        // 스택뷰에 뷰들을 추가
        stackView.addArrangedSubview(analyzeView)
        stackView.addArrangedSubview(calendarContainerView)
        stackView.addArrangedSubview(noDiaryContainerView)
        
        calendarContainerView.addSubview(calendarHeader)
        calendarContainerView.addSubview(diarySegmentedControl)
        calendarContainerView.addSubview(calendar)
        
        noDiaryContainerView.addSubview(noDiaryImageView)
        noDiaryContainerView.addSubview(noDiaryLabel)
        
        diaryPostButtonContainerView.addSubview(diaryPostButton)
    }
    
    override func configure() {
        calendarContainerView.backgroundColor = TDColor.baseWhite
        calendarHeader.pickerButton.delegate = self
        scrollView.delegate = self
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
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(24)
        }
        diarySegmentedControl.snp.makeConstraints {
            $0.top.equalTo(calendarHeader.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(16)
            $0.height.equalTo(48)
        }
        calendar.snp.makeConstraints {
            $0.top.equalTo(diarySegmentedControl.snp.bottom).offset(36)
            $0.leading.trailing.bottom.equalToSuperview().inset(20)
        }
        noDiaryContainerView.snp.makeConstraints {
            $0.height.equalTo(300)
        }
        noDiaryImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(50)
            $0.centerX.equalToSuperview()
        }
        noDiaryLabel.snp.makeConstraints {
            $0.top.equalTo(noDiaryImageView.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
        }
        
        diaryPostButtonContainerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(112)
        }
        diaryPostButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(28)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().offset(-28)
        }
    }
}

// MARK: - PickerButtonDelegate
extension DiaryViewController: PickerButtonDelegate {
    func pickerButton(_ pickerButton: PickerButton, didSelect date: Date) {
        calendar.setCurrentPage(date, animated: true)
        updateHeaderLabel(for: calendar.currentPage)
    }
}

// MARK: - UIScrollViewDelegate
extension DiaryViewController: UIScrollViewDelegate {
    /// Scroll 감지하여 버튼 배경색 변경
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let calendarFrame = calendarContainerView.convert(calendarContainerView.bounds, to: view)
        
        if calendarFrame.maxY < diaryPostButtonContainerView.frame.minY {
            diaryPostButtonContainerView.backgroundColor = .clear
        } else {
            diaryPostButtonContainerView.backgroundColor = UIColor.white.withAlphaComponent(0.9)
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
