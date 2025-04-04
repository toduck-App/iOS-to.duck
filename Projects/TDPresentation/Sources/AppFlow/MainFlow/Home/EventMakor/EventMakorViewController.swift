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
            self?.input.send(.saveEvent)
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
                    self?.navigationController?.popViewController(animated: true)
                case .failedToSaveEvent(let missingFields):
                    let missing = missingFields
                        .map {
                            switch $0 {
                            case "title": return "제목"
                            case "category": return "카테고리"
                            case "startDate": return "시작 날짜"
                            default: return $0
                            }
                        }
                        .joined(separator: ", ")
                    self?.showErrorAlert(errorMessage: "\(missing)이(가) 입력되지 않았어요.")
                }
            }.store(in: &cancellables)
    }
    
    @objc
    override func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
              let keyboardAdjustableView else { return }
        
        UIView.animate(withDuration: duration) {
            self.eventMakorView.dummyViewHeightConstraint?.update(offset: 250)
            keyboardAdjustableView.transform = CGAffineTransform(translationX: 0, y: -keyboardFrame.height + 30)
        }
    }
    
    @objc
    override func keyboardWillHide(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
              let keyboardAdjustableView else { return }

        UIView.animate(withDuration: duration) {
            self.eventMakorView.dummyViewHeightConstraint?.update(offset: 40)
            keyboardAdjustableView.transform = .identity
        }
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
    func reloadCategoryView() {
        input.send(.fetchCategories)
    }
    
    func updateSelectedDate(startDate: Date, endDate: Date?) {
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
            input.send(.selectTime(isAllDay, selectedDate))
            TDLogger.debug("\(selectedDate) 선택된 시간: \(displayTime)")
        }
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
            UIImage.reverseCategoryDictionary[image] ?? "None"
        ))
    }
}

// MARK: - TextFieldDelegate
extension EventMakorViewController: TDFormTextFieldDelegate {
    func tdTextField(_ textField: TDFormTextField, didChangeText text: String) {
        if textField == eventMakorView.titleForm {
            input.send(.updateTitleTextField(text))
            if text.isEmpty {
                eventMakorView.saveButton.isEnabled = false
            } else {
                eventMakorView.saveButton.isEnabled = true
            }
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
extension EventMakorViewController: TDFormTextViewDelegate {
    func tdTextView(_ textView: TDFormTextView, didChangeText text: String) {
        input.send(.updateMemoTextView(text))
    }
}

// MARK: - SegmentViewDelegate
extension EventMakorViewController: TDFormSegmentViewDelegate {
    func segmentView(_ segmentView: TDFormSegmentView, didChangeToPublic isPublic: Bool) {
        input.send(.selectLockType(isPublic))
    }
}

extension EventMakorViewController: TDFormButtonsViewDelegate {
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

extension EventMakorViewController: UIScrollViewDelegate {
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
        constraint.update(offset: -20)
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }

    private func hideSnackBar() {
        guard let constraint = eventMakorView.noticeSnackBarBottomConstraint else { return }
        constraint.update(offset: 50)
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
}
