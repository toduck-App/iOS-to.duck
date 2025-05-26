import UIKit
import TDDesign
import FSCalendar
import SnapKit
import Then

protocol SheetCalendarDelegate: AnyObject {
    func didTapSaveButton(startDate: Date, endDate: Date?)
}

final class SheetCalendarViewController: BaseViewController<BaseView>, TDCalendarConfigurable {
    // MARK: - UI Components
    private let cancelButton = UIButton(type: .system).then {
        $0.setImage(TDImage.X.x1Medium, for: .normal)
        $0.tintColor = TDColor.Neutral.neutral700
    }
    private let titleLabel = TDLabel(
        labelText: "날짜 설정",
        toduckFont: TDFont.boldHeader4,
        toduckColor: TDColor.Neutral.neutral800
    )
    
    var calendarHeader = CalendarHeaderStackView(type: .sheet)
    var calendar = SheetCalendar()
    
    private let selectDates = TDLabel(
        toduckFont: TDFont.mediumHeader5,
        toduckColor: TDColor.Neutral.neutral600
    )
    private let buttonHorizontalStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 10
    }
    private let resetButton = TDBaseButton(
        title: "재설정",
        backgroundColor: TDColor.baseWhite,
        foregroundColor: TDColor.Neutral.neutral700,
        radius: 12,
        font: TDFont.boldHeader3.font
    )
    private let saveButton = UIButton(type: .system).then {
        $0.setTitle("저장", for: .normal)
        $0.titleLabel?.font = TDFont.boldHeader3.font
        $0.backgroundColor = TDColor.baseWhite
        $0.setTitleColor(TDColor.Neutral.neutral700, for: .normal)
        $0.isEnabled = false
        $0.layer.cornerRadius = 12
    }
    
    // MARK: - Properties
    private let headerDateFormatter = DateFormatter().then { $0.dateFormat = "yyyy년 M월" }
    private let dateFormatter = DateFormatter().then { $0.dateFormat = "yyyy-MM-dd" }
    private let dayFormatter = DateFormatter().then { $0.dateFormat = "d일" }
    private var startDate: Date?
    private var endDate: Date?
    private var datesRange: [Date] = []
    weak var coordinator: SheetCalendarCoordinator?
    weak var delegate: SheetCalendarDelegate?
    
    // MARK: - Common Methods
    override func configure() {
        view.backgroundColor = TDColor.baseWhite
        resetButton.layer.borderWidth = 1
        resetButton.layer.borderColor = TDColor.Neutral.neutral300.cgColor
        
        setupCalendar()
        updateSaveButtonState()
        
        cancelButton.addAction(UIAction { [weak self] _ in
            self?.coordinator?.finish(by: .modal)
        }, for: .touchUpInside)
        
        resetButton.addAction(UIAction { [weak self] _ in
            self?.calendar.reloadData()
            self?.startDate = nil
            self?.endDate = nil
            self?.datesRange = []
            self?.updateSelectedDatesLabel()
            self?.updateSaveButtonState()
        }, for: .touchUpInside)
        
        saveButton.addAction(UIAction { [weak self] _ in
            guard let startDate = self?.startDate else { return }
            
            self?.delegate?.didTapSaveButton(startDate: startDate, endDate: self?.endDate)
            self?.coordinator?.finish(by: .modal)
        }, for: .touchUpInside)
    }
    
    override func addView() {
        view.addSubview(cancelButton)
        view.addSubview(titleLabel)
        view.addSubview(selectDates)
        view.addSubview(buttonHorizontalStackView)
        buttonHorizontalStackView.addArrangedSubview(resetButton)
        buttonHorizontalStackView.addArrangedSubview(saveButton)
    }
    
    override func layout() {
        cancelButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(24)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(16)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(24)
            $0.centerX.equalTo(view)
        }
        
        calendarHeader.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(28)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(16)
        }
        
        calendar.snp.makeConstraints {
            $0.centerX.equalTo(view)
            $0.top.equalTo(calendarHeader.snp.top).offset(44)
            $0.width.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.9)
            $0.height.equalTo(300)
        }
        
        selectDates.snp.makeConstraints {
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-20)
            $0.centerY.equalTo(calendarHeader.snp.centerY)
        }
        
        buttonHorizontalStackView.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(16)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
            $0.height.equalTo(56)
        }
    }
    
    private func updateSaveButtonState() {
        if datesRange.isEmpty {
            saveButton.isEnabled = false
            saveButton.backgroundColor = TDColor.baseWhite
            saveButton.setTitleColor(TDColor.Neutral.neutral700, for: .normal)
            saveButton.layer.borderWidth = 1
            saveButton.layer.borderColor = TDColor.Neutral.neutral300.cgColor
        } else {
            saveButton.isEnabled = true
            saveButton.backgroundColor = TDColor.Primary.primary500
            saveButton.setTitleColor(TDColor.baseWhite, for: .normal)
            saveButton.layer.borderWidth = 0
        }
    }
    
    // MARK: 선택된 날짜를 업데이트 (우측 상단 Label)
    private func updateSelectedDatesLabel() {
        guard let firstDate = startDate else {
            selectDates.text = ""
            return
        }

        // firstDate와 lastDate가 모두 존재하고, 서로 다른 날짜일 경우
        if let lastDate = endDate, firstDate != lastDate {
            let firstMonth = Calendar.current.component(.month, from: firstDate)
            let lastMonth = Calendar.current.component(.month, from: lastDate)

            // 같은 달일 경우 "M월 d일 - d일" 형식으로 표시
            if firstMonth == lastMonth {
                let monthDayFormatter = DateFormatter()
                monthDayFormatter.dateFormat = "M월 d일"
                selectDates.text = "\(monthDayFormatter.string(from: firstDate)) - \(dayFormatter.string(from: lastDate))"
            } else {
                // 다른 달일 경우 "M월 d일 - M월 d일" 형식으로 표시
                let monthDayFormatter = DateFormatter()
                monthDayFormatter.dateFormat = "M월 d일"
                selectDates.text = "\(monthDayFormatter.string(from: firstDate)) - \(monthDayFormatter.string(from: lastDate))"
            }
        } else {
            // 단일 날짜가 선택된 경우 "d일" 형식으로 표시
            selectDates.text = "\(dayFormatter.string(from: firstDate))"
        }
    }
}

extension SheetCalendarViewController {
    // MARK: - FSCalendarDelegateAppearance
    // 기본 폰트 색
    func calendar(
        _ calendar: FSCalendar, 
        appearance: FSCalendarAppearance,
        titleDefaultColorFor date: Date
    ) -> UIColor? {
        colorForDate(date)
    }
    
    // 선택된 날짜 폰트 색 (이걸 안 하면 오늘날짜와 토,일 선택했을 때 폰트색이 바뀜)
    func calendar(
        _ calendar: FSCalendar,
        appearance: FSCalendarAppearance,
        titleSelectionColorFor date: Date
    ) -> UIColor? {
        colorForDate(date)
    }
    
    // MARK: - FSCalendarDelegate
    func calendar(
        _ calendar: FSCalendar,
        didSelect date: Date,
        at monthPosition: FSCalendarMonthPosition
    ) {
        // case 1. 달력에 아무 날짜도 선택되지 않은 경우
        if startDate == nil {
            startDate = date
            datesRange = [startDate!]
            
            updateSelectedDatesLabel()
            updateSaveButtonState()
            calendar.reloadData()
            return
        }
        
        // case 2. firstDate 단일선택 되어 있는 경우
        if startDate != nil && endDate == nil {
            // case 2-1. firstDate보다 이전 날짜 클릭 시, 단일 선택 날짜를 바꿔줌
            if date < startDate! {
                calendar.deselect(startDate!)
                startDate = date
                datesRange = [startDate!]
                
                updateSelectedDatesLabel()
                updateSaveButtonState()
                calendar.reloadData()
                return
            }
            
            // case 2-2. 종료일이 선택된 경우
            else {
                var range: [Date] = []
                var currentDate = startDate!
                
                while currentDate <= date {
                    range.append(currentDate)
                    currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
                }
                
                for day in range {
                    calendar.select(day)
                }
                
                endDate = range.last
                datesRange = range
                
                updateSelectedDatesLabel()
                updateSaveButtonState()
                calendar.reloadData()
                return
            }
        }
        
        // case 3. 시작일-종료일 선택된 상태에서 다른 날짜를 클릭하면, 해당 날짜를 firstDate로
        if startDate != nil && endDate != nil {
            for day in calendar.selectedDates {
                calendar.deselect(day)
            }
            
            endDate = nil
            startDate = date
            calendar.select(date)
            datesRange = [startDate!]
            
            updateSelectedDatesLabel()
            updateSaveButtonState()
            calendar.reloadData()
            return
        }
    }
    
    func calendar(
        _ calendar: FSCalendar,
        didDeselect date: Date,
        at monthPosition: FSCalendarMonthPosition
    ) {
        let arr = datesRange
        if !arr.isEmpty {
            for day in arr {
                calendar.deselect(day)
            }
        }
        
        startDate = nil
        endDate = nil
        datesRange = []
        
        updateSelectedDatesLabel()
        updateSaveButtonState()
        calendar.reloadData()
    }
    
    // FSCalendarDelegate 메소드, 페이지 바뀔 때마다 실행됨
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        updateHeaderLabel(for: calendar.currentPage)
    }
    
    // MARK: - FSCalendarDataSource
    func calendar(
        _ calendar: FSCalendar,
        cellFor date: Date,
        at position: FSCalendarMonthPosition
    ) -> FSCalendarCell {
        guard let cell = calendar.dequeueReusableCell(
            withIdentifier: SheetCalendarSelectDateCell.identifier,
            for: date, at: position) as? SheetCalendarSelectDateCell
        else { return FSCalendarCell() }
        
        let dateType = typeOfDate(date)
        cell.updateBackImage(dateType)
        
        let isToday = Calendar.current.isDateInToday(date)
        cell.markAsToday(isToday)
        
        return cell
    }
    
    // 날짜 유형을 계산하는 메서드
    private func typeOfDate(_ date: Date) -> SelectedDateType {
        let arr = datesRange
        
        if !arr.contains(date) { return .notSelected }
        if arr.count == 1 && date == startDate { return .singleDate }
        if date == startDate { return .firstDate }
        if date == endDate { return .lastDate }
        else { return .middleDate }
    }
}
