import UIKit
import Combine
import FSCalendar
import SnapKit
import TDCore
import TDDomain
import TDDesign

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
    let diaryDetailView = DiaryDetailView()
    
    // MARK: - Properties
    weak var coordinator: DiaryCoordinator?
    private let viewModel: DiaryViewModel
    private let input = PassthroughSubject<DiaryViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    private var selectedDate = Date().normalized
    
    // MARK: - Initializer
    init(
        viewModel: DiaryViewModel
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
        
        fetchDiaryList(for: Date())
        calendar.select(Date())

        let normalizedToday = Date().normalized
        viewModel.selectedDiary = viewModel.monthDiaryList[normalizedToday]
        input.send(.selecteDay(normalizedToday))
    }
    
    // MARK: - Common Methods
    override func addView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        contentView.addSubview(diaryPostButtonContainerView)
        
        // 스택뷰에 뷰들을 추가
        stackView.addArrangedSubview(analyzeView)
        stackView.addArrangedSubview(calendarContainerView)
        stackView.addArrangedSubview(noDiaryContainerView)
        stackView.addArrangedSubview(diaryDetailView)
        
        calendarContainerView.addSubview(calendarHeader)
        calendarContainerView.addSubview(diarySegmentedControl)
        calendarContainerView.addSubview(calendar)
        
        noDiaryContainerView.addSubview(noDiaryImageView)
        noDiaryContainerView.addSubview(noDiaryLabel)
        
        diaryPostButtonContainerView.addSubview(diaryPostButton)
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
        
        /// 캘린더 뷰
        calendarContainerView.snp.makeConstraints {
            $0.height.equalTo(456)
            $0.leading.trailing.equalTo(contentView)
        }
        calendarHeader.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(24)
        }
        diarySegmentedControl.snp.makeConstraints {
            $0.top.equalTo(calendarHeader.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(16)
            $0.width.equalTo(133)
            $0.height.equalTo(48)
        }
        calendar.snp.makeConstraints {
            $0.top.equalTo(diarySegmentedControl.snp.bottom).offset(36)
            $0.leading.trailing.bottom.equalToSuperview().inset(20)
        }
        
        /// 일기 상세 뷰
        diaryDetailView.snp.makeConstraints {
            $0.top.equalTo(calendarContainerView.snp.bottom).offset(12)
            $0.leading.trailing.equalTo(contentView).inset(10)
            $0.bottom.equalTo(contentView).offset(-20)
        }
        
        /// 일기가 없는 경우
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
                }
            }.store(in: &cancellables)
    }
    
    override func configure() {
        calendarContainerView.backgroundColor = TDColor.baseWhite
        calendarHeader.pickerButton.delegate = self
        scrollView.delegate = self
        setupCalendar()
        setupNavigationBar()
        
        diaryPostButton.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            coordinator?.didTapCreateDiaryButton(selectedDate: selectedDate, isEdit: viewModel.selectedDiary != nil)
        }, for: .touchUpInside)
    }
    
    private func fetchDiaryList(for date: Date) {
        let components = Calendar.current.dateComponents([.year, .month], from: date)
        guard let year = components.year, let month = components.month else { return }

        input.send(.fetchDiaryList(year, month))
    }
    
    private func updateDiaryView(with diary: Diary? = nil) {
        let hasDiary = diary != nil

        diaryDetailView.isHidden = !hasDiary
        noDiaryContainerView.isHidden = hasDiary
        diaryPostButtonContainerView.isHidden = hasDiary

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
    
    private func setupNavigationBar() {
        // 좌측 네비게이션 바 버튼 설정 (캘린더 + 로고)
        let calendarButton = UIButton(type: .custom)
        calendarButton.setImage(TDImage.Calendar.top2Medium, for: .normal)
        calendarButton.addAction(UIAction { [weak self] _ in
            self?.coordinator?.didTapCalendarButton()
        }, for: .touchUpInside)
        
        let toduckLogoImageView = UIImageView(image: TDImage.toduckLogo)
        toduckLogoImageView.contentMode = .scaleAspectFit
        
        let leftBarButtonItems = [
            UIBarButtonItem(customView: calendarButton),
            UIBarButtonItem(customView: toduckLogoImageView)
        ]
        
        navigationItem.leftBarButtonItems = leftBarButtonItems
        
        // 우측 네비게이션 바 버튼 설정 (알람 버튼)
        let alarmButton = UIButton(type: .custom)
        alarmButton.setImage(TDImage.Bell.topOffMedium, for: .normal)
        alarmButton.addAction(UIAction { [weak self] _ in
            TDLogger.debug("DiaryViewController - 알람 버튼 클릭")
            self?.coordinator?.didTapAlarmButton()
        }, for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: alarmButton)
    }
    
    private func colorForDate(_ date: Date) -> UIColor? {
        // 오늘 날짜 확인
        if Calendar.current.isDate(date, inSameDayAs: Date()) {
            return TDColor.Primary.primary500
        }
        
        return TDColor.Neutral.neutral800
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
