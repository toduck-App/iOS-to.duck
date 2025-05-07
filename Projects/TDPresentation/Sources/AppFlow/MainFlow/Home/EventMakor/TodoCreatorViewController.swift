import UIKit
import TDDomain
import FittedSheets
import Combine
import TDDesign
import TDCore

final class TodoCreatorViewController: BaseViewController<BaseView> {
    enum Mode {
        case schedule
        case routine
    }
    
    // MARK: - Properties
    private let mode: Mode
    private let isEdit: Bool
    private let viewModel: TodoCreatorViewModel
    private let eventMakorView: TodoCreatorView
    private let input = PassthroughSubject<TodoCreatorViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    private var createStartDate: Date?
    weak var coordinator: TodoCreatorCoordinator?
    weak var delegate: TodoCreatorCoordinatorDelegate?
    
    // MARK: - Initializer
    init(
        mode: Mode,
        isEdit: Bool,
        viewModel: TodoCreatorViewModel
    ) {
        self.mode = mode
        self.isEdit = isEdit
        self.viewModel = viewModel
        self.eventMakorView = TodoCreatorView(mode: mode)
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
        if isMovingFromParent {
            coordinator?.finish(by: .pop)
        }
    }
    
    // MARK: - Base Method
    override func configure() {
        navigationController?.navigationBar.isHidden = false
        eventMakorView.scrollView.delegate = self
        setupDelegate()
        setupCategory()
        eventMakorView.saveButton.addAction(UIAction { [weak self] _ in
            if self?.isEdit == true && self?.mode == .schedule {
                self?.presentSheetEditMode()
            } else if self?.isEdit == true && self?.mode == .routine {
                self?.input.send(.tapEditRoutineButton)
            } else {
                self?.input.send(.tapSaveTodoButton)
            }
            self?.delegate?.didTapSaveButton(createdDate: self?.createStartDate ?? Date())
        }, for: .touchUpInside)
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
                case .savedEvent:
                    self?.coordinator?.finish(by: .pop)
                case .failedToSaveEvent(let missingFields):
                    let missing = missingFields
                        .map {
                            switch $0 {
                            case "title": return "제목"
                            case "category": return "카테고리"
                            case "startDate": return "시작 날짜"
                            case "timeOrIsAllDay": return "시간 선택"
                            case "repeatDays": return "반복 요일"
                            default: return $0
                            }
                        }
                        .joined(separator: ", ")
                    self?.showErrorAlert(errorMessage: "\(missing)이(가) 입력되지 않았어요.")
                case .failureAPI(let message):
                    self?.showErrorAlert(errorMessage: message)
                case .canSaveEvent(let isEnabled):
                    self?.eventMakorView.saveButton.isEnabled = isEnabled
                    self?.eventMakorView.noticeSnackBarView.isHidden = isEnabled
                }
            }.store(in: &cancellables)
    }
    
    @objc
    override func keyboardWillShow(_ notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
        else { return }
        
        UIView.animate(withDuration: duration) {
            self.eventMakorView.dummyViewHeightConstraint?.update(offset: keyboardFrame.height)
        }
    }
    
    @objc
    override func keyboardWillHide(_ notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
        else { return }

        UIView.animate(withDuration: duration) {
            self.eventMakorView.dummyViewHeightConstraint?.update(offset: 112)
        }
    }
    
    private func presentSheetEditMode() {
        guard (viewModel.preEvent?.repeatDays) != nil else {
            input.send(.tapScheduleEditTodayButton)
            return
        }
        
        let editScheduleModeViewController = EditScheduleModeViewController()
        editScheduleModeViewController.delegate = self
        let sheetController = SheetViewController(
            controller: editScheduleModeViewController,
            sizes: [.fixed(340)],
            options: .init(
                pullBarHeight: 0,
                shouldExtendBackground: false,
                setIntrinsicHeightOnNavigationControllers: false,
                useFullScreenMode: false,
                shrinkPresentingViewController: false,
                isRubberBandEnabled: false
            )
        )
        sheetController.cornerRadius = 28
        present(sheetController, animated: true, completion: nil)
    }
    
    private func setupDelegate() {
        eventMakorView.titleForm.delegate = self
        eventMakorView.categoryTitleForm.delegate = self
        eventMakorView.categoryViewsForm.delegate = self
        eventMakorView.dateForm.delegate = self
        eventMakorView.timeForm.delegate = self
        eventMakorView.repeatDayForm.delegate = self
        eventMakorView.alarmForm.delegate = self
        eventMakorView.lockForm.delegate = self
        eventMakorView.locationForm.delegate = self
        eventMakorView.memoTextView.delegate = self
    }
    
    private func setupCategory() {
        let categoryColors = viewModel.categories.compactMap { $0.colorHex.convertToUIColor() }
        eventMakorView.categoryViewsForm.setupCategoryView(colors: categoryColors)
    }
    
    // MARK: Delegate Method
    func updatePreEvent(preEvent: (any TodoItem)?, selectedDate: Date?) {
        let selectedDateString = selectedDate?.convertToString(formatType: .monthDay) ?? ""
        eventMakorView.updatePreEvent(preEvent: preEvent, selectedDateString: selectedDateString)
    }
    
    func reloadCategoryView() {
        input.send(.fetchCategories)
    }
    
    func updateSelectedDate(startDate: Date, endDate: Date?) {
        createStartDate = startDate
        let startDateForBackend = startDate.convertToString(formatType: .yearMonthDay)
        let startDateForDisplay = startDate.convertToString(formatType: .monthDay)
        
        if let endDate {
            let endDateForBackend = endDate.convertToString(formatType: .yearMonthDay)
            let endDateForDisplay = endDate.convertToString(formatType: .monthDay)
            
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
        if isAllDay {
            // "종일"로 표시 및 입력 이벤트 전송
            eventMakorView.timeForm.updateDescription("종일")
            eventMakorView.alarmForm.updateAlarmContent(isAllDay: true)
            input.send(.selectTime(isAllDay, nil))
        } else {
            // 선택된 Date 생성
            let selectedDate: Date = {
                var dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
                dateComponents.hour = isAM ? hour : (hour % 12) + 12 // 12시 예외 처리 포함
                dateComponents.minute = minute
                return Calendar.current.date(from: dateComponents) ?? Date()
            }()
            
            let displayTime = selectedDate.convertToString(formatType: .time12HourEnglish)
            eventMakorView.timeForm.updateDescription(displayTime)
            eventMakorView.alarmForm.updateAlarmContent(isAllDay: false)
            let selectedTimeString = selectedDate.convertToString(formatType: .time24Hour)
            input.send(.selectTime(isAllDay, selectedTimeString))
            TDLogger.debug("\(selectedDate) 선택된 시간: \(displayTime)")
        }
    }
}

// MARK: - TDFormMoveViewDelegate
extension TodoCreatorViewController: TDFormMoveViewDelegate {
    func didTapMoveView(_ view: TDFormMoveView, type: TDFormMoveViewType) {
        coordinator?.didTapMoveView(view, type: type)
    }
}

// MARK: - TDCategoryCellDelegate
extension TodoCreatorViewController: TDCategoryCellDelegate {
    func didTapCategoryCell(_ color: UIColor, _ image: UIImage, _ index: Int) {
        input.send(.selectCategory(
            color.convertToHexString() ?? "",
            UIImage.reverseCategoryDictionary[image] ?? "None"
        ))
    }
}

// MARK: - TextFieldDelegate
extension TodoCreatorViewController: TDFormTextFieldDelegate {
    func tdTextField(_ textField: TDFormTextField, didChangeText text: String) {
        if textField == eventMakorView.titleForm {
            input.send(.updateTitleTextField(text))
        }
        
        if textField == eventMakorView.memoTextView {
            input.send(.updateMemoTextView(text))
        }
        
        if textField == eventMakorView.locationForm {
            input.send(.updateLocationTextField(text))
        }
    }
}

// MARK: - TextViewDelegate
extension TodoCreatorViewController: TDFormTextViewDelegate {
    func tdTextView(_ textView: TDFormTextView, didChangeText text: String) {
        input.send(.updateMemoTextView(text))
    }
}

// MARK: - SegmentViewDelegate
extension TodoCreatorViewController: TDFormSegmentViewDelegate {
    func segmentView(_ segmentView: TDFormSegmentView, didChangeToPublic isPublic: Bool) {
        input.send(.selectLockType(isPublic))
    }
}

extension TodoCreatorViewController: TDFormButtonsViewDelegate {
    func formButtonsView(
        _ formButtonsView: TDFormButtonsView,
        type: TDFormButtonsViewType,
        didSelectIndex selectedIndex: Int,
        isSelected: Bool
    ) {
        switch type {
        case .repeatDay:
            input.send(.selectRepeatDay(index: selectedIndex, isSelected: isSelected))
        case .alarm:
            input.send(.selectAlarm(index: selectedIndex, isSelected: isSelected))
        }
    }
}

// MARK: - UIScrollViewDelegate
extension TodoCreatorViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY + height >= contentHeight - 10 {
            showSnackBar()
        } else {
            hideSnackBar()
        }
    }
    
    private func showSnackBar() {
        guard let constraint = eventMakorView.noticeSnackBarBottomConstraint else { return }
        constraint.update(offset: 0)
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    private func hideSnackBar() {
        guard let constraint = eventMakorView.noticeSnackBarBottomConstraint else { return }
        constraint.update(offset: 50)
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - EditScheduleModeDelegate
extension TodoCreatorViewController: EditScheduleModeDelegate {
    func didTapTodayScheduleApply() {
        input.send(.tapScheduleEditTodayButton)
    }
    
    func didTapAllScheduleApply() {
        input.send(.tapScheduleEditAllButton)
    }
}
