import UIKit
import Combine
import TDDesign
import TDCore

final class EventMakorViewController: BaseViewController<BaseView> {
    // MARK: - Properties
    private let mode: ScheduleAndRoutineViewController.Mode
    private let viewModel: EventMakorViewModel
    private let eventMakorView: EventMakorView
    private let input = PassthroughSubject<EventMakorViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    weak var coordinator: EventMakorCoordinator?
    
    // MARK: - UI Components
    private lazy var registerButton = UIBarButtonItem(
        title: "저장",
        primaryAction: UIAction {
            [weak self] _ in
            self?.didTapRegisterButton()
        }).then {
            $0.tintColor = TDColor.Neutral.neutral700
        }
    
    // MARK: - Initializer
    init(
        mode: ScheduleAndRoutineViewController.Mode,
        viewModel: EventMakorViewModel
    ) {
        self.mode = mode
        self.viewModel = viewModel
        self.eventMakorView = EventMakorView(mode: mode)
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func loadView() {
        super.loadView()
        view = eventMakorView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        input.send(.fetchCategories)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Common Method
    override func configure() {
        navigationItem.rightBarButtonItem = registerButton
        eventMakorView.categoryTitleForm.delegate = self
        eventMakorView.categoryViewsForm.delegate = self
        eventMakorView.dateForm.delegate = self
        eventMakorView.timeForm.delegate = self
        
        let categoryColors = viewModel.categories.compactMap { $0.colorHex.convertToUIColor() }
        eventMakorView.categoryViewsForm.setupCategoryView(colors: categoryColors)
    }
    
    override func binding() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .fetchedCategories:
                    self?.eventMakorView.categoryViewsForm.setupCategoryView(
                        colors: self?.viewModel.categories.compactMap { $0.colorHex.convertToUIColor()
                        } ?? [])
                }
            }.store(in: &cancellables)
    }
    
    // MARK: Delegate Method
    func reloadCategoryView() {
        input.send(.fetchCategories)
    }
    
    func updateSelectedDate(startDate: Date, endDate: Date?) {
        let backendFormatter = DateFormatter() // ViewModel 전달용 포맷터
        backendFormatter.dateFormat = "yyyy-MM-dd"
        
        let displayFormatter = DateFormatter() // 화면 표시용 포맷터
        displayFormatter.dateFormat = "M월 d일"
        
        let startDateForBackend = backendFormatter.string(from: startDate)
        let startDateForDisplay = displayFormatter.string(from: startDate)
        
        if let endDate {
            let endDateForBackend = backendFormatter.string(from: endDate)
            let endDateForDisplay = displayFormatter.string(from: endDate)
            
            // 여러 기간 선택 시
            eventMakorView.dateForm.updateDescription("\(startDateForDisplay) - \(endDateForDisplay)")
            input.send(.selectDate(startDateForBackend, endDateForBackend))
        } else {
            // 단일 날짜 선택 시
            eventMakorView.dateForm.updateDescription(startDateForDisplay)
            input.send(.selectDate(startDateForBackend, startDateForBackend))
        }
    }
    
    func updateSelectedTime(isAllDay: Bool, isAM: Bool, hour: Int, minute: Int) {
        let backendFormatter = DateFormatter() // ViewModel 전달용 포맷터
        backendFormatter.dateFormat = "HH:mm"
        
        let displayFormatter = DateFormatter() // 화면 표시용 포맷터
        displayFormatter.locale = Locale(identifier: "ko_KR")
        displayFormatter.dateFormat = "a h:mm"
        
        if isAllDay {
            // "종일"로 표시 및 입력 이벤트 전송
            eventMakorView.timeForm.updateDescription("종일")
            input.send(.selectTime(isAllDay, nil))
        } else {
            // 선택된 Date 생성
            let selectedDate: Date = {
                var dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
                dateComponents.hour = isAM ? hour : (hour % 12) + 12 // 12시 예외 처리 포함
                dateComponents.minute = minute
                return Calendar.current.date(from: dateComponents) ?? Date()
            }()
            
            let displayTime = displayFormatter.string(from: selectedDate)
            eventMakorView.timeForm.updateDescription(displayTime)
            input.send(.selectTime(isAllDay, selectedDate))
            print("\(selectedDate) 선택된 시간: \(displayTime)")
        }
    }
    
    private func didTapRegisterButton() {
        // TODO: - 저장 버튼 클릭
    }
}

// MARK: - EventMakorViewDelegate
extension EventMakorViewController: TDFormMoveViewDelegate {
    func didTapMoveView(_ view: TDFormMoveView, type: TDFormMoveViewType) {
        coordinator?.didTapMoveView(view, type: type)
    }
}

// MARK: - TDCategoryCellDelegate
extension EventMakorViewController: TDCategoryCellDelegate {
    func didTapCategoryCell(_ color: UIColor, _ image: UIImage, _ index: Int) {
        input.send(.selectCategory(
            color.convertToHexString() ?? "",
            UIImage.reverseCategoryDictionary[image] ?? "none"
        ))
    }
}
