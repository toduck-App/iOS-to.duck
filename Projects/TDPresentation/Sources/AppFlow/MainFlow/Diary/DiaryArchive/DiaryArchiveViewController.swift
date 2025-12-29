import UIKit
import Combine
import Kingfisher
import SnapKit
import TDCore
import TDDesign
import TDDomain
import Then

final class DiaryArchiveViewController: BaseViewController<BaseView> {

    // MARK: - UI Components

    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = true
        $0.alwaysBounceVertical = true
    }

    private let contentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 0
        $0.alignment = .fill
    }

    private let calendarHeaderContainerView = UIView().then {
        $0.backgroundColor = TDColor.baseWhite
        $0.layer.borderWidth = 1
        $0.layer.borderColor = TDColor.Neutral.neutral200.cgColor
        $0.layer.cornerRadius = 8
    }

    private let calendarHeader = CalendarHeaderStackView(type: .diary)

    private let diaryListStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 12
        $0.alignment = .fill
    }

    private let diaryPostButtonContainerView = UIView().then {
        $0.backgroundColor = TDColor.baseWhite
        $0.layer.masksToBounds = false
    }

    private let diaryPostButton = TDBaseButton(
        title: "오늘 일기 작성",
        backgroundColor: TDColor.Primary.primary500,
        foregroundColor: TDColor.baseWhite,
        font: TDFont.boldHeader3.font,
        radius: 12
    ).then {
        $0.isHidden = true
    }

    // MARK: - Properties

    private let viewModel: DiaryArchiveViewModel
    private let input = PassthroughSubject<DiaryArchiveViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    weak var coordinator: DiaryCoordinator?
    private var currentYearMonth: (year: Int, month: Int)

    // MARK: - Initializer

    init(viewModel: DiaryArchiveViewModel, initialDate: Date = Date()) {
        self.viewModel = viewModel
        let components = Calendar.current.dateComponents([.year, .month], from: initialDate)
        self.currentYearMonth = (components.year ?? 2024, components.month ?? 1)
        super.init()
        updateHeaderLabel(for: initialDate)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setupNestedNavigationBar(
            leftButtonTitle: "전체 일기 모아보기",
            leftButtonAction: UIAction { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
        )
        loadInitialData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        input.send(.fetchDiaryList(year: currentYearMonth.year, month: currentYearMonth.month))
    }

    // MARK: - Setup

    override func addView() {
        view.addSubview(calendarHeaderContainerView)
        view.addSubview(scrollView)
        view.addSubview(diaryPostButtonContainerView)
        scrollView.addSubview(contentStackView)

        contentStackView.addArrangedSubview(diaryListStackView)

        calendarHeaderContainerView.addSubview(calendarHeader)
        diaryPostButtonContainerView.addSubview(diaryPostButton)

        calendarHeader.delegate = self
    }

    override func layout() {
        calendarHeaderContainerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.height.equalTo(44)
        }

        calendarHeader.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(12)
        }

        scrollView.snp.makeConstraints {
            $0.top.equalTo(calendarHeaderContainerView.snp.bottom).offset(12)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(diaryPostButtonContainerView.snp.top)
        }

        contentStackView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }

        diaryListStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
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
        layoutView.backgroundColor = TDColor.baseWhite

        diaryPostButton.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            coordinator?.didTapCreateDiaryButton(selectedDate: Date().normalized)
        }, for: .touchUpInside)
    }

    override func binding() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())

        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .fetchedDiaryList(let diaries):
                    self?.updateDiaryList(diaries)
                case .deletedDiary:
                    self?.input.send(.fetchDiaryList(year: self?.currentYearMonth.year ?? 2024, month: self?.currentYearMonth.month ?? 1))
                case .failureAPI(let message):
                    self?.showErrorAlert(errorMessage: message)
                }
            }
            .store(in: &cancellables)
    }

    // MARK: - Private Methods

    private func loadInitialData() {
        input.send(.fetchDiaryList(year: currentYearMonth.year, month: currentYearMonth.month))
    }

    private func updateDiaryList(_ diaries: [Diary]) {
        diaryListStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        guard !diaries.isEmpty else {
            showEmptyState()
            updateTodayDiaryButtonVisibility(diaries: diaries)
            return
        }

        for (index, diary) in diaries.enumerated() {
            let cardView = createDiaryCardView(diary: diary)
            diaryListStackView.addArrangedSubview(cardView)

            if index < diaries.count - 1 {
                let divider = createDivider()
                diaryListStackView.addArrangedSubview(divider)
            }
        }

        updateTodayDiaryButtonVisibility(diaries: diaries)
    }

    private func updateTodayDiaryButtonVisibility(diaries: [Diary]) {
        let today = Date()
        let todayComponents = Calendar.current.dateComponents([.year, .month], from: today)

        // 현재 선택된 월이 오늘이 속한 월이 아니면 버튼 숨김
        guard currentYearMonth.year == todayComponents.year,
              currentYearMonth.month == todayComponents.month else {
            diaryPostButton.isHidden = true
            return
        }

        // 오늘이 속한 월이면, 오늘 일기 작성 여부에 따라 버튼 표시/숨김
        let hasTodayDiary = diaries.contains { $0.date.normalized == today.normalized }
        diaryPostButton.isHidden = hasTodayDiary
    }

    private func createDiaryCardView(diary: Diary) -> UIView {
        let cardView = DiaryDetailView()
        cardView.dropdownButton.tag = diary.id
        cardView.dropDownHoverView.delegate = self
        cardView.dropDownHoverView.dataSource = DiaryEditType.allCases.map(\.dropDownItem)
        cardView.dropdownButton.addAction(UIAction { [weak cardView] _ in
            cardView?.dropDownHoverView.showDropDown()
        }, for: .touchUpInside)

        if let imageURLs = diary.diaryImageUrls, !imageURLs.isEmpty {
            loadImages(from: imageURLs) { [weak cardView] loadedImages in
                cardView?.configure(
                    emotionImage: diary.emotion.circleImage,
                    date: diary.date.convertToString(formatType: .monthDayWithWeekday),
                    title: diary.title,
                    keywords: diary.diaryKeywords.map { $0.keywordName },
                    memo: diary.memo,
                    photos: loadedImages,
                    imageURLs: imageURLs
                )
            }
        } else {
            cardView.configure(
                emotionImage: diary.emotion.circleImage,
                date: diary.date.convertToString(formatType: .monthDayWithWeekday),
                title: diary.title,
                keywords: diary.diaryKeywords.map { $0.keywordName },
                memo: diary.memo,
                photos: [],
                imageURLs: nil
            )
        }

        return cardView
    }

    private func createDivider() -> UIView {
        let divider = UIView()
        divider.backgroundColor = TDColor.Neutral.neutral200
        divider.snp.makeConstraints {
            $0.height.equalTo(1)
        }
        return divider
    }

    private func showEmptyState() {
        let emptyLabel = TDLabel(
            labelText: "이번 달에 작성한 일기가 없어요",
            toduckFont: TDFont.mediumBody1,
            toduckColor: TDColor.Neutral.neutral600
        )
        emptyLabel.textAlignment = .center

        let emptyContainer = UIView()
        emptyContainer.addSubview(emptyLabel)

        emptyLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        emptyContainer.snp.makeConstraints {
            $0.height.equalTo(200)
        }

        diaryListStackView.addArrangedSubview(emptyContainer)
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

// MARK: - CalendarHeaderStackViewDelegate

extension DiaryArchiveViewController: CalendarHeaderStackViewDelegate {
    func calendarHeader(_ header: CalendarHeaderStackView, didSelect date: Date) {
        let components = Calendar.current.dateComponents([.year, .month], from: date)
        guard let year = components.year, let month = components.month else { return }

        currentYearMonth = (year, month)
        updateHeaderLabel(for: date)
        input.send(.fetchDiaryList(year: year, month: month))
    }
    
    func updateHeaderLabel(for date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 M월"

        if let headerLabel = calendarHeader.arrangedSubviews.compactMap({ $0 as? TDLabel }).first {
            headerLabel.setText(dateFormatter.string(from: date))
        }
    }
}

// MARK: - TDDropDownDelegate

extension DiaryArchiveViewController: TDDropDownDelegate {
    func dropDown(_ dropDown: TDDropdownHoverView, didSelectRowAt indexPath: IndexPath) {
        let diaryId = dropDown.anchorView.tag
        guard let diary = viewModel.diaryList.first(where: { $0.id == diaryId }) else { return }

        let item = DiaryEditType.allCases[indexPath.row]

        switch item {
        case .edit:
            coordinator?.didTapEditDiaryButton(diary: diary)
        case .delete:
            let deleteDiaryViewController = DeleteEventViewController(
                eventId: diary.id,
                isRepeating: false,
                eventMode: .diary
            )
            deleteDiaryViewController.delegate = self
            presentPopup(with: deleteDiaryViewController)
        }
    }
}

// MARK: - DeleteEventViewControllerDelegate

extension DiaryArchiveViewController: DeleteEventViewControllerDelegate {
    func didTapTodayDeleteButton(eventId: Int?, eventMode: DeleteEventViewController.EventMode) {
        guard let eventId else { return }
        input.send(.deleteDiary(eventId))
        dismiss(animated: true)
    }

    func didTapAllDeleteButton(eventId: Int?, eventMode: DeleteEventViewController.EventMode) {}
}


