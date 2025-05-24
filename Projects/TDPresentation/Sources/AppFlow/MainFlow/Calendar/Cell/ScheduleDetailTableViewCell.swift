import UIKit
import TDDomain
import TDDesign
import SnapKit
import Then

final class ScheduleDetailTableViewCell: UITableViewCell {
    // MARK: UI Components
    private let todoDetailView = TodoDetailView()
    private let buttonsContainerView = UIView()
    private let editButton = UIButton()
    private let deleteButton = UIButton()
    
    // MARK: Properties
    private let maxButtonWidth: CGFloat = 120
    private var initialOffset: CGFloat = 0
    private var oldTodoDetailViewBounds: CGRect = .zero
    var editAction: (() -> Void)?
    var deleteAction: (() -> Void)?
    
    // MARK: Initializer
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupButtons()
        configureGesture()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func prepareForReuse() {
        super.prepareForReuse()
        resetCellState()
    }
    
    private func resetCellState() {
        todoDetailView.resetForReuse()
        todoDetailView.transform = .identity
        oldTodoDetailViewBounds = .zero
    }
    
    // MARK: - Configuration
    func configure(
        with schedule: Schedule,
        checkAction: @escaping () -> Void,
        editAction: (() -> Void)? = nil,
        deleteAction: (() -> Void)? = nil
    ) {
        self.editAction = editAction
        self.deleteAction = deleteAction
        todoDetailView.configureCell(
            color: schedule.categoryColor,
            title: schedule.title,
            time: schedule.time,
            category: schedule.categoryIcon,
            isFinished: schedule.isFinished,
            place: schedule.place
        )
        todoDetailView.configureButtonAction {
            checkAction()
        }
    }
    
    // MARK: - View Setup
    private func setupViews() {
        selectionStyle = .none
        contentView.backgroundColor = TDColor.Neutral.neutral50
        contentView.addSubview(buttonsContainerView)
        contentView.addSubview(todoDetailView)
        buttonsContainerView.addSubview(editButton)
        buttonsContainerView.addSubview(deleteButton)
        
        todoDetailView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(6)
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
        buttonsContainerView.snp.makeConstraints { make in
            make.top.bottom.equalTo(todoDetailView)
            make.trailing.equalToSuperview()
            make.width.equalTo(maxButtonWidth)
        }
        
        editButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(6)
            make.trailing.equalTo(deleteButton.snp.leading)
            make.bottom.equalToSuperview().offset(-6)
            make.width.equalTo(64)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(6)
            make.trailing.equalToSuperview().offset(-6)
            make.bottom.equalToSuperview().offset(-6)
            make.width.equalTo(60)
        }
    }
    
    private func configureCornerRadius() {
        todoDetailView.layer.cornerRadius = 8
        todoDetailView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        todoDetailView.clipsToBounds = true
        
        let maskPath = UIBezierPath(
            roundedRect: todoDetailView.bounds,
            byRoundingCorners: [.topLeft, .bottomLeft],
            cornerRadii: CGSize(width: 2, height: 2)
        )
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        todoDetailView.layer.mask = maskLayer
    }
    
    private func setupButtons() {
        editButton.backgroundColor = TDColor.Neutral.neutral600
        deleteButton.backgroundColor = .red
        editButton.setImage(TDImage.Pen.penMedium.withTintColor(.white), for: .normal)
        deleteButton.setImage(TDImage.trashMedium.withTintColor(.white), for: .normal)
        deleteButton.layer.cornerRadius = 8
        deleteButton.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        deleteButton.clipsToBounds = true
        
        editButton.addAction(UIAction { [weak self] _ in
            self?.editAction?()
            self?.animateButtons(shouldOpen: false)
        }, for: .touchUpInside)
        
        deleteButton.addAction(UIAction { [weak self] _ in
            self?.deleteAction?()
            self?.animateButtons(shouldOpen: false)
        }, for: .touchUpInside)
    }
    
    // MARK: 커스텀 스와이프 동작
    private func configureGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        panGesture.delegate = self
        contentView.addGestureRecognizer(panGesture)
    }
    
    @objc
    private func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: contentView)
        let velocity = recognizer.velocity(in: contentView)
        
        switch recognizer.state {
        case .began:
            initialOffset = todoDetailView.transform.tx
        case .changed:
            handlePanChanged(translation: translation)
        case .ended, .cancelled:
            handlePanEnded(velocity: velocity)
        default:
            break
        }
    }
    
    private func handlePanChanged(translation: CGPoint) {
        let newOffset = initialOffset + translation.x
        let clampedOffset = min(max(newOffset, -maxButtonWidth), 0)
        todoDetailView.transform = CGAffineTransform(translationX: clampedOffset, y: 0)
    }
    
    private func handlePanEnded(velocity: CGPoint) {
        let currentOffset = todoDetailView.transform.tx
        let shouldOpen = (currentOffset < -maxButtonWidth/2) || (velocity.x < -500)
        animateButtons(shouldOpen: shouldOpen)
    }
    
    private func animateButtons(shouldOpen: Bool) {
        let targetOffset = shouldOpen ? -maxButtonWidth : 0
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0,
            options: .curveEaseOut
        ) {
            self.todoDetailView.transform = CGAffineTransform(translationX: targetOffset, y: 0)
        }
    }
}

extension ScheduleDetailTableViewCell {
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGesture = gestureRecognizer as? UIPanGestureRecognizer {
            let velocity = panGesture.velocity(in: contentView)
            return abs(velocity.x) > abs(velocity.y)
        }
        return true
    }
}
