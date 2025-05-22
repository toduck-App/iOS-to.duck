import TDCore
import TDDomain
import TDDesign
import UIKit

protocol DetailTodoViewControllerDelegate: AnyObject {
    func didTapDeleteButton(event: any TodoItem)
    func didTapTomorrowButton(event: any TodoItem)
    func didTapEditButton(event: any TodoItem)
}

final class DetailTodoViewController: TDPopupViewController<DetailTodoView> {
    // MARK: - Properties
    private let todo: any TodoItem
    private let currentDate: String
    weak var delegate: DetailTodoViewControllerDelegate?
    
    // MARK: - Initializer
    init(
        todo: any TodoItem,
        currentDate: String
    ) {
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
        if todo.eventMode == .routine {
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
        delegate?.didTapEditButton(event: todo)
    }
    
    // MARK: - UI Configuration
    /// 제목 설정
    private func configureTitle() {
        let title = todo.eventMode == .schedule ? "일정 상세보기" : "루틴 상세보기"
        popupContentView.titleLabel.setText(title)
    }
    
    /// 이벤트 정보 설정
    private func configureEventDetails() {
        configureDateAndAlarm()
        configureCategoryAndTitle()
        configureTime()
        configureRepeatDays()
        configureMemo()
    }

    private func configureDateAndAlarm() {
        popupContentView.dateLabel.setText(currentDate)
        popupContentView.alarmImageView.image = todo.alarmTime != nil
            ? TDImage.Bell.ringingMedium
            : TDImage.Bell.offMedium
    }

    private func configureCategoryAndTitle() {
        popupContentView.categoryImageView.configure(
            radius: 12,
            backgroundColor: todo.categoryColor,
            category: todo.categoryIcon ?? TDImage.Tomato.tomatoSmallEmtpy
        )
        popupContentView.eventTitleLabel.setText(todo.title)
    }

    private func configureTime() {
        let timeText = todo.isAllDay ? "종일" : (todo.time ?? "없음")
        popupContentView.timeDetailView.updateDescription(timeText)
    }

    private func configureRepeatDays() {
        let repeatString = todo.repeatDays?.map { $0.title }.joined(separator: ", ") ?? "없음"
        popupContentView.repeatDetailView.updateDescription(repeatString)
    }

    private func configureMemo() {
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
        if todo.eventMode == .routine, let routine = todo as? Routine {
            popupContentView.placeDetailView.isHidden = true
            popupContentView.lockDetailView.updateDescription(routine.isPublic ? "공개" : "비공개")
        } else if todo.eventMode == .schedule, let schedule = todo as? Schedule {
            popupContentView.lockDetailView.isHidden = true
            popupContentView.placeDetailView.updateDescription(schedule.place ?? "없음")
        }
    }
}
