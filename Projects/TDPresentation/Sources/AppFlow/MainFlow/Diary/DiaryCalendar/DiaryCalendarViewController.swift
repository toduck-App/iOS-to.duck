import UIKit
import Combine
import FSCalendar
import SnapKit
import TDCore
import TDDomain
import TDDesign

final class DiaryCalendarViewController: BaseViewController<BaseView> {
    // MARK: - UI Components
    private let calendarContainerView = UIView()
    private let calendarHeader = CalendarHeaderStackView(type: .diary)
    private let calendar = DiaryCalendar()
    
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
    
    private let diaryPostButtonContainerView = UIView().then {
        $0.backgroundColor = TDColor.Neutral.neutral50
        $0.layer.masksToBounds = false
    }
    private let diaryPostButton = TDBaseButton(
        title: "일기 작성",
        backgroundColor: TDColor.Primary.primary500,
        foregroundColor: TDColor.baseWhite,
        font: TDFont.boldHeader3.font,
        radius: 12
    )
    
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
        
        calendarDidSelect(date: Date())
    }
    
    override func addView() {
        view.addSubview(calendarContainerView)
        view.addSubview(noDiaryContainerView)
        view.addSubview(diaryDetailView)
        view.addSubview(diaryPostButtonContainerView)
        
        calendarContainerView.addSubview(calendarHeader)
        calendarContainerView.addSubview(calendar)

        noDiaryContainerView.addSubview(noDiaryImageView)
        noDiaryContainerView.addSubview(noDiaryLabel)

        diaryPostButtonContainerView.addSubview(diaryPostButton)

        calendarHeader.pickerButton.delegate = self
        calendar.delegate = self

        diaryPostButton.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            coordinator?.didTapCreateDiaryButton(selectedDate: selectedDate)
        }, for: .touchUpInside)
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
    
    override func configure() {
        diaryDetailView.dropDownHoverView.delegate = self
        diaryDetailView.dropDownHoverView.dataSource = DiaryEditType.allCases.map { $0.dropDownItem }
        diaryDetailView.dropdownButton.addAction(UIAction { [weak self] _ in
            self?.diaryDetailView.dropDownHoverView.showDropDown()
        }, for: .touchUpInside)
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
    
}

extension DiaryCalendarViewController: PickerButtonDelegate {
    func pickerButton(_ pickerButton: PickerButton, didSelect date: Date) {
        calendar.setCurrentPage(date, animated: true)
        // 필요하다면 헤더 갱신 로직 추가
    }
}

extension DiaryCalendarViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = date.normalized
        // 필요 시 ViewModel 업데이트
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
