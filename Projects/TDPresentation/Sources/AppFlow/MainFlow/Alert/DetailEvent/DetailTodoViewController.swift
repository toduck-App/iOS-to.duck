import TDCore
import TDDomain
import TDDesign
import UIKit

protocol DetailTodoViewControllerDelegate: AnyObject {
    func didTapDeleteButton(event: TodoDisplayItem)
    func didTapTomorrowButton(event: TodoDisplayItem)
    func didTapEditButton(event: TodoDisplayItem, mode: TDTodoMode)
}

final class DetailTodoViewController: TDPopupViewController<DetailTodoView> {
    // MARK: - Properties
    private let mode: TDTodoMode
    private let todo: TodoDisplayItem
    private let currentDate: String
    weak var delegate: DetailTodoViewControllerDelegate?
    
    // MARK: - Initializer
    init(
        mode: TDTodoMode,
        todo: TodoDisplayItem,
        currentDate: String
    ) {
        self.mode = mode
        self.todo = todo
        self.currentDate = currentDate
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        super.configure()
        
        setupView()
        setupButtonActions()
    }
    
    // MARK: - Setup Methods
    private func setupView() {
        configureTitle()
        configureEventDetails()
        configureVisibility()
        if mode == .routine {
            popupContentView.delayToTomorrowButton.isHidden = true
        }
    }
    
    /// 버튼 액션을 설정
    private func setupButtonActions() {
        popupContentView.closeButton.addAction(UIAction { [weak self] _ in
            self?.dismissPopup()
        }, for: .touchUpInside)
        
        popupContentView.deleteButton.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            delegate?.didTapDeleteButton(event: todo)
            dismissPopup()
        }, for: .touchUpInside)
        
        popupContentView.delayToTomorrowButton.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            delegate?.didTapTomorrowButton(event: todo)
            dismissPopup()
        }, for: .touchUpInside)
        
        popupContentView.editAreaView.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(editButtonTapped)
            )
        )
    }
    
    @objc
    private func editButtonTapped() {
        dismissPopup()
        delegate?.didTapEditButton(event: todo, mode: mode)
    }
    
    // MARK: - UI Configuration
    /// 제목 설정
    private func configureTitle() {
        let title = mode == .schedule ? "일정 상세보기" : "루틴 상세보기"
        popupContentView.titleLabel.setText(title)
    }
    
    /// 이벤트 정보 설정
    private func configureEventDetails() {
        popupContentView.dateLabel.setText(currentDate)
        popupContentView.alarmImageView.image = todo.alarmTime != nil
            ? TDImage.Bell.ringingMedium
            : TDImage.Bell.offMedium
        
        popupContentView.categoryImageView.configure(
            radius: 12,
            backgroundColor: todo.categoryColor,
            category: todo.categoryIcon ?? TDImage.Tomato.tomatoSmallEmtpy
        )
        popupContentView.eventTitleLabel.setText(todo.title)
        
        popupContentView.timeDetailView.updateDescription(todo.time ?? "없음")
        let repeatString = todo.repeatDays == nil ? "없음" : todo.repeatDays!.map { $0.title }.joined(separator: ", ")
        popupContentView.repeatDetailView.updateDescription(repeatString)
        if let memo = todo.memo {
            popupContentView.memoContentLabel.setText(memo)
            popupContentView.memoContentLabel.setColor(TDColor.Neutral.neutral800)
        } else {
            popupContentView.memoContentLabel.setText("등록된 메모가 없어요")
            popupContentView.memoContentLabel.setColor(TDColor.Neutral.neutral500)
        }
    }
    
    /// 루틴과 일정에 따라 UI를 다르게 설정
    private func configureVisibility() {
        if mode == .routine {
            popupContentView.placeDetailView.isHidden = true
            popupContentView.lockDetailView.updateDescription(todo.isPublic ? "공개" : "비공개")
        } else {
            popupContentView.lockDetailView.isHidden = true
            popupContentView.placeDetailView.updateDescription(todo.place ?? "없음")
        }
    }
}
