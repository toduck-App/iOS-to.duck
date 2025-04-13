import UIKit
import Kingfisher
import Combine
import FSCalendar
import SnapKit
import TDCore
import TDDomain
import TDDesign

protocol DiaryCalendarViewControllerDelegate: AnyObject {
    func didSelectDate(_ diaryCalendarViewController: DiaryCalendarViewController, selectedDate: Date, isWrited: Bool)
}

final class DiaryCalendarViewController: BaseViewController<BaseView> {
    // MARK: - UI Components
    private let contentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fill
    }
    
    let calendarContainerView = UIView()
    let calendarHeader = CalendarHeaderStackView(type: .diary)
    let calendar = DiaryCalendar()
    
    private let noDiaryContainerView = UIView()
    private let noDiaryImageView = UIImageView().then {
        $0.image = TDImage.noEvent
        $0.contentMode = .scaleAspectFit
    }
    private let noDiaryLabel = TDLabel(
        labelText: "일기를 작성하지 않았어요",
        toduckFont: TDFont.boldBody1,
        toduckColor: TDColor.Neutral.neutral600
    )
    
    let diaryDetailContainerView = UIView()
    let diaryDetailView = DiaryDetailView()
    let dummyView = UIView()
    
    // MARK: - Properties
    private let viewModel: DiaryCalendarViewModel
    private let input = PassthroughSubject<DiaryCalendarViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    weak var coordinator: DiaryCoordinator?
    weak var delegate: DiaryCalendarViewControllerDelegate?
    var selectedDate = Date().normalized
    
    init(viewModel: DiaryCalendarViewModel) {
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
        input.send(.selectDay(normalizedToday))
        fetchDiaryList(for: Date())
        calendarDidSelect(date: Date())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchDiaryList(for: calendar.currentPage)
    }
    
    // MARK: - Common Methods
    override func addView() {
        view.addSubview(contentStackView)
        
        contentStackView.addArrangedSubview(calendarContainerView)
        contentStackView.addArrangedSubview(noDiaryContainerView)
        contentStackView.addArrangedSubview(diaryDetailContainerView)
        
        calendarContainerView.addSubview(calendarHeader)
        calendarContainerView.addSubview(calendar)
        
        noDiaryContainerView.addSubview(noDiaryImageView)
        noDiaryContainerView.addSubview(noDiaryLabel)
        
        diaryDetailContainerView.addSubview(diaryDetailView)
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
        
        noDiaryContainerView.snp.makeConstraints {
            $0.height.equalTo(350)
        }
        noDiaryImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(40)
            $0.centerX.equalToSuperview()
        }
        noDiaryLabel.snp.makeConstraints {
            $0.top.equalTo(noDiaryImageView.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
        }
        
        diaryDetailContainerView.snp.makeConstraints {
            $0.height.equalTo(450)
        }
        diaryDetailView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.trailing.equalToSuperview().inset(10)
        }
        dummyView.snp.makeConstraints {
            $0.top.equalTo(diaryDetailView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(100)
        }
    }
    
    override func configure() {
        setupCalendar()
        layoutView.backgroundColor = TDColor.baseWhite
        noDiaryContainerView.backgroundColor = TDColor.Neutral.neutral50
        diaryDetailContainerView.backgroundColor = TDColor.Neutral.neutral50
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
                    self?.updateDiaryView(with: self?.viewModel.monthDiaryList[self?.selectedDate ?? Date()])
                case .setImage:
                    self?.fetchDiaryList(for: self?.selectedDate ?? Date())
                case .notFoundDiary:
                    self?.updateDiaryView()
                case .deletedDiary:
                    self?.updateDiaryView()
                    self?.calendar.reloadData()
                case .failureAPI(let message):
                    self?.showErrorAlert(errorMessage: message)
                }
            }.store(in: &cancellables)
    }
    
    private func calendarDidSelect(date: Date) {
        selectedDate = date.normalized
        viewModel.selectedDiary = viewModel.monthDiaryList[date.normalized]
        input.send(.selectDay(date.normalized))
    }
    
    private func fetchDiaryList(for date: Date) {
        let components = Calendar.current.dateComponents([.year, .month], from: date)
        guard let year = components.year, let month = components.month else { return }
        input.send(.fetchDiaryList(year, month))
    }
    
    // MARK: 일기 불러온 후 이미지 불러오기
    private func updateDiaryView(with diary: Diary? = nil) {
        updateContainerVisibility(for: diary)
        delegate?.didSelectDate(self, selectedDate: selectedDate, isWrited: diary != nil)
        
        guard let diary = diary else { return }
        
        if let imageURLs = diary.diaryImageUrls, !imageURLs.isEmpty {
            loadImages(from: imageURLs) { [weak self] loadedImages in
                self?.configureDiaryDetailView(diary: diary, images: loadedImages)
            }
        } else {
            configureDiaryDetailView(diary: diary, images: [])
        }
    }
    
    private func updateContainerVisibility(for diary: Diary?) {
        diaryDetailContainerView.isHidden = diary == nil
        noDiaryContainerView.isHidden = diary != nil
    }

    private func configureDiaryDetailView(diary: Diary, images: [UIImage]) {
        diaryDetailView.configure(
            emotionImage: diary.emotion.circleImage,
            date: diary.date.convertToString(formatType: .monthDayWithWeekday),
            title: diary.title,
            memo: diary.memo,
            photos: images,
            imageURLs: diary.diaryImageUrls
        )
        diaryDetailView.delegate = self
    }

    private func loadImages(from imageURLs: [String], completion: @escaping ([UIImage]) -> Void) {
        let group = DispatchGroup()
        var loadedImages: [UIImage] = Array(repeating: UIImage(), count: imageURLs.count)
        
        for (index, urlString) in imageURLs.enumerated() {
            guard let url = URL(string: urlString) else { continue }
            
            group.enter()
            KingfisherManager.shared.retrieveImage(with: url) { [weak self] result in
                switch result {
                case .success(let value):
                    loadedImages[index] = value.image
                case .failure(let error):
                    self?.showErrorAlert(errorMessage: error.localizedDescription)
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion(loadedImages.filter { $0.size != .zero })
        }
    }
}

extension DiaryCalendarViewController: PickerButtonDelegate {
    func pickerButton(
        _ pickerButton: PickerButton,
        didSelect date: Date
    ) {
        calendar.setCurrentPage(date, animated: true)
        updateHeaderLabel(for: calendar.currentPage)
    }
}

// MARK: - TDDropDownDelegate

extension DiaryCalendarViewController: TDDropDownDelegate {
    func dropDown(
        _: TDDesign.TDDropdownHoverView,
        didSelectRowAt indexPath: IndexPath
    ) {
        let item = DiaryEditType.allCases[indexPath.row]
        
        switch item {
        case .edit:
            guard let diary = viewModel.selectedDiary else { return }
            coordinator?.didTapEditDiaryButton(diary: diary)
        case .delete:
            let deleteDiaryViewController = DeleteEventViewController(
                isRepeating: false,
                isScheduleEvent: false
            )
            deleteDiaryViewController.delegate = self
            self.presentPopup(with: deleteDiaryViewController)
        }
    }
}

// MARK: - DiaryCalendarConfigurable

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

// MARK: - DeleteEventViewControllerDelegate

extension DiaryCalendarViewController: DeleteEventViewControllerDelegate {
    func didTapDeleteButton() {
        input.send(.deleteDiary(viewModel.selectedDiary?.id ?? 0))
        dismiss(animated: true)
    }
}

// MARK: - SocialAddPhotoViewDelegate
extension DiaryCalendarViewController: TDFormPhotoDelegate, TDPhotoPickerDelegate {
    func didSelectPhotos(_ picker: TDPhotoPickerController, photos: [Data]) {
        input.send(.setImages(photos))
    }

    func deniedPhotoAccess(_ picker: TDPhotoPickerController) {
        showErrorAlert(errorMessage: "사진 접근 권한이 없습니다.")
    }

    func didTapAddPhotoButton(_ view: TDFormPhotoView?) {
        var maximumSelectablePhotos = 2
        if viewModel.selectedDiary?.diaryImageUrls?.count == 1 {
            maximumSelectablePhotos = 1
        }
        
        let photoPickerController = TDPhotoPickerController(maximumSelectablePhotos: maximumSelectablePhotos)
        photoPickerController.pickerDelegate = self
        navigationController?.pushTDViewController(photoPickerController, animated: true)
    }
}
