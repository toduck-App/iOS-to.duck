import UIKit
import Combine
import FSCalendar
import SnapKit
import TDCore
import TDDomain
import TDDesign

final class DiaryCalendarViewController: BaseViewController<BaseView> {
    // MARK: - UI Components
    let calendarContainerView = UIView()
    let calendarHeader = CalendarHeaderStackView(type: .diary)
    let calendar = DiaryCalendar()
    
    private let noDiaryContainerView = UIView()
    private let noDiaryImageView = UIImageView().then {
        $0.image = TDImage.DiaryPercent.bookPercent0
        $0.contentMode = .scaleAspectFit
    }
    private let noDiaryLabel = TDLabel(
        labelText: "일기를 작성하지 않았어요",
        toduckFont: TDFont.boldBody1,
        toduckColor: TDColor.Neutral.neutral600
    )
    /// 일기 상세 뷰
    let diaryDetailView = DiaryDetailView()
    
    // MARK: Properties
    private let viewModel: DiaryCalendarViewModel
    private let input = PassthroughSubject<DiaryCalendarViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    weak var coordinator: DiaryCoordinator?
    var selectedDate = Date().normalized
    
    init(
        viewModel: DiaryCalendarViewModel
    ) {
        self.viewModel = viewModel
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let normalizedToday = Date().normalized
        viewModel.selectedDiary = viewModel.monthDiaryList[normalizedToday]
        input.send(.selecteDay(normalizedToday))
        fetchDiaryList(for: Date())
        calendarDidSelect(date: Date())
    }
    
    override func addView() {
        view.addSubview(calendarContainerView)
        view.addSubview(noDiaryContainerView)
        view.addSubview(diaryDetailView)
        
        calendarContainerView.addSubview(calendarHeader)
        calendarContainerView.addSubview(calendar)

        noDiaryContainerView.addSubview(noDiaryImageView)
        noDiaryContainerView.addSubview(noDiaryLabel)


        calendarHeader.pickerButton.delegate = self
        calendar.delegate = self

    }
    
    override func layout() {
        calendarContainerView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(456)
        }
        calendarHeader.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(24)
        }
        calendar.snp.makeConstraints {
            $0.top.equalTo(calendarHeader.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview().inset(20)
        }

        noDiaryContainerView.snp.makeConstraints {
            $0.top.equalTo(calendarContainerView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
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
        
        diaryDetailView.snp.makeConstraints {
            $0.top.equalTo(calendarContainerView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.height.equalTo(500)
        }
    }
    
    override func configure() {
        setupCalendar()
        layoutView.backgroundColor = TDColor.baseWhite
        noDiaryContainerView.backgroundColor = TDColor.Neutral.neutral50
        diaryDetailView.dropDownHoverView.delegate = self
        diaryDetailView.dropDownHoverView.dataSource = DiaryEditType.allCases.map { $0.dropDownItem }
        diaryDetailView.dropdownButton.addAction(UIAction { [weak self] _ in
            self?.diaryDetailView.dropDownHoverView.showDropDown()
        }, for: .touchUpInside)
    }
    
    override func binding() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .selectedDiary(let diary):
                    self?.updateDiaryView(with: diary)
                case .fetchedDiaryList:
                    self?.calendar.reloadData()
                case .notFoundDiary:
                    self?.updateDiaryView()
                case .failureAPI(let message):
                    self?.showErrorAlert(with: message)
                }
            }.store(in: &cancellables)
    }
    
    private func calendarDidSelect(date: Date) {
        selectedDate = date.normalized
        viewModel.selectedDiary = viewModel.monthDiaryList[date.normalized]
        input.send(.selecteDay(date.normalized))
    }
    
    private func updateDiaryView(with diary: Diary? = nil) {
        let hasDiary = diary != nil
        diaryDetailView.isHidden = !hasDiary

        if let diary {
            diaryDetailView.configure(
                emotionImage: diary.emotion.circleImage,
                date: diary.date.convertToString(formatType: .monthDayWithWeekday),
                title: diary.title,
                sentences: diary.sentenceText,
                photos: [TDImage.Mood.angry, TDImage.Mood.happy]
            )
        }
    }
    
    private func fetchDiaryList(for date: Date) {
        let components = Calendar.current.dateComponents([.year, .month], from: date)
        guard let year = components.year, let month = components.month else { return }

        input.send(.fetchDiaryList(year, month))
    }
}

extension DiaryCalendarViewController: PickerButtonDelegate {
    func pickerButton(_ pickerButton: PickerButton, didSelect date: Date) {
        calendar.setCurrentPage(date, animated: true)
        updateHeaderLabel(for: calendar.currentPage)
    }
}

// MARK: - TDDropDownDelegate

extension DiaryCalendarViewController: TDDropDownDelegate {
    func dropDown(_: TDDesign.TDDropdownHoverView, didSelectRowAt indexPath: IndexPath) {
        let item = DiaryEditType.allCases[indexPath.row]
        
        switch item {
        case .edit:
            guard let diary = viewModel.selectedDiary else { return }
            coordinator?.didTapEditDiaryButton(diary: diary)
        case .delete:
            break
        }
    }
}

extension DiaryCalendarViewController: TDCalendarConfigurable {
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        updateHeaderLabel(for: calendar.currentPage)
        fetchDiaryList(for: calendar.currentPage)
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
        
        let normalized = date.normalized
        let diary = viewModel.monthDiaryList[normalized]
        cell.configure(with: diary?.emotion.image)
        
        return cell
    }
    
    func calendar(
        _ calendar: FSCalendar,
        didSelect date: Date,
        at monthPosition: FSCalendarMonthPosition
    ) {
        selectedDate = date.normalized
        let normalizedDate = date.normalized
        
        viewModel.selectedDiary = viewModel.monthDiaryList[normalizedDate]
        input.send(.selecteDay(normalizedDate))
    }
    
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
}
