import UIKit
import Combine
import FSCalendar
import SnapKit
import TDCore
import TDDomain
import TDDesign

final class FocusCalendarViewController: BaseViewController<BaseView> {
    // MARK: - UI Components
    private let contentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fill
    }
    
    let calendarContainerView = UIView()
    let calendarHeader = CalendarHeaderStackView(type: .focus)
    let calendar = DiaryCalendar()
    
    private let noFocusContainerView = UIView()
    private let noFocusImageView = UIImageView().then {
        $0.image = TDImage.noEvent
        $0.contentMode = .scaleAspectFit
    }
    private let noFocusLabel = TDLabel(
        labelText: "집중 기록이 없어요",
        toduckFont: TDFont.boldBody1,
        toduckColor: TDColor.Neutral.neutral600
    )
    
    let diaryDetailContainerView = UIView()
    let focusDetailView = FocusDetailView()
    let dummyView = UIView()
    
    // MARK: - Properties
    private let viewModel: FocusCalendarViewModel
    private let input = PassthroughSubject<FocusCalendarViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    weak var coordinator: DiaryCoordinator?
    var selectedDate = Date().normalized
    
    init(viewModel: FocusCalendarViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchDiaryList(for: calendar.currentPage)
    }
    
    // MARK: - Common Methods
    override func addView() {
        view.addSubview(contentStackView)
        
        contentStackView.addArrangedSubview(calendarContainerView)
        contentStackView.addArrangedSubview(noFocusContainerView)
        contentStackView.addArrangedSubview(diaryDetailContainerView)
        
        calendarContainerView.addSubview(calendarHeader)
        calendarContainerView.addSubview(calendar)
        
        noFocusContainerView.addSubview(noFocusImageView)
        noFocusContainerView.addSubview(noFocusLabel)
        
        diaryDetailContainerView.addSubview(focusDetailView)
        diaryDetailContainerView.addSubview(dummyView)
        
        calendarHeader.pickerButton.delegate = self
        calendar.delegate = self
    }
    
    override func layout() {
        contentStackView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        calendarContainerView.snp.makeConstraints {
            $0.height.equalTo(400)
        }
        calendarHeader.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.height.equalTo(24)
        }
        calendar.snp.makeConstraints {
            $0.top.equalTo(calendarHeader.snp.bottom).offset(30)
            $0.leading.trailing.bottom.equalToSuperview().inset(20)
        }
        
        noFocusContainerView.snp.makeConstraints {
            $0.height.equalTo(250)
        }
        noFocusImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(40)
            $0.centerX.equalToSuperview()
        }
        noFocusLabel.snp.makeConstraints {
            $0.top.equalTo(noFocusImageView.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
        }
        
        diaryDetailContainerView.snp.makeConstraints {
            $0.height.equalTo(220)
        }
        focusDetailView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.height.equalTo(200)
        }
        dummyView.snp.makeConstraints {
            $0.top.equalTo(focusDetailView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(20)
        }
    }
    
    override func configure() {
        setupCalendar()
        layoutView.backgroundColor = TDColor.baseWhite
        noFocusContainerView.backgroundColor = TDColor.Neutral.neutral50
        diaryDetailContainerView.backgroundColor = TDColor.Neutral.neutral50
        focusDetailView.backgroundColor = TDColor.baseWhite
    }
    
    override func binding() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .selectedFocus(let focus):
                    self?.updateDiaryView(with: focus)
                case .fetchedFocusList:
                    self?.calendar.reloadData()
                case .notFoundFocus:
                    self?.updateDiaryView()
                case .failureAPI(let message):
                    self?.showErrorAlert(errorMessage: message)
                }
            }.store(in: &cancellables)
    }
    
    private func fetchDiaryList(for date: Date) {
        let components = Calendar.current.dateComponents([.year, .month], from: date)
        guard let year = components.year, let month = components.month else { return }
        input.send(.fetchFocusList(year, month))
    }
    
    private func updateDiaryView(with focus: Focus? = nil) {
        diaryDetailContainerView.isHidden = focus == nil
        noFocusContainerView.isHidden = focus != nil
        
        if let focus {
            let focusImage = getFocusImage(for: focus.percentage) ?? UIImage()
            let (userHour, userMinute) = calculateTime(from: focus.time)
            focusDetailView.configure(
                focusImage: focusImage,
                date: focus.date.convertToString(formatType: .yearMonth),
                percent: focus.percentage,
                userHour: userHour,
                userMinute: userMinute
            )
        }
    }
    
    private func getFocusImage(for percentage: Int?) -> UIImage? {
        guard let percentage else { return nil }
        switch percentage {
        case 0:
            return nil
        case 1...20:
            return TDImage.FocusPercent.percent1to20
        case 21...40:
            return TDImage.FocusPercent.percent21to40
        case 41...60:
            return TDImage.FocusPercent.percent41to60
        case 61...80:
            return TDImage.FocusPercent.percent61to80
        case 81...100:
            return TDImage.FocusPercent.percent81to100
        default:
            return nil
        }
    }
    
    private func calculateTime(from time: Int?) -> (Int, Int) {
        guard let time else { return (0, 0) }
        let hour = time / 60
        let minute = time % 60
        
        return (hour, minute)
    }
}

// MARK: - PickerButtonDelegate
extension FocusCalendarViewController: PickerButtonDelegate {
    func pickerButton(
        _ pickerButton: PickerButton,
        didSelect date: Date
    ) {
        calendar.setCurrentPage(date, animated: true)
        updateHeaderLabel(for: calendar.currentPage)
    }
}

// MARK: - FSCalendarDelegate
extension FocusCalendarViewController: TDCalendarConfigurable {
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
        guard let focus = viewModel.monthFocusList[normalized]?.percentage else { return cell }
        switch focus {
        case 0:
            cell.configure(with: nil)
        case 1...20:
            cell.configure(with: TDImage.FocusPercent.percent1to20)
        case 21...40:
            cell.configure(with: TDImage.FocusPercent.percent21to40)
        case 41...60:
            cell.configure(with: TDImage.FocusPercent.percent41to60)
        case 61...80:
            cell.configure(with: TDImage.FocusPercent.percent61to80)
        case 81...100:
            cell.configure(with: TDImage.FocusPercent.percent81to100)
        default:
            break
        }
        
        return cell
    }
    
    func calendar(
        _ calendar: FSCalendar,
        didSelect date: Date,
        at monthPosition: FSCalendarMonthPosition
    ) {
        selectedDate = date.normalized
        let normalizedDate = date.normalized
        
        viewModel.selectedFocus = viewModel.monthFocusList[normalizedDate]
        input.send(.selectDay(normalizedDate))
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
