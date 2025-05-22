import UIKit
import TDDesign
import SnapKit
import Then

final class TimeSlotTableViewCell: UITableViewCell {
    // MARK: - UI Components
    private let timeLabel = TDLabel(
        toduckFont: TDFont.mediumBody3,
        toduckColor: TDColor.Neutral.neutral800
    )
    private let shadowContainerView = UIView()
    private let todoDetailView = TodoDetailView()
    private let buttonsContainerView = UIView()
    private let editButton = UIButton()
    private let deleteButton = UIButton()
    
    // MARK: - Properties
    private let maxButtonWidth: CGFloat = LayoutConstants.buttonContainerWidth
    private var oldTodoDetailViewBounds: CGRect = .zero
    private var didSetCornerRadius = false
    private var isSwipeOpened: Bool = false
    var segmentSwipeAction: (() -> Void)?
    var editAction: (() -> Void)?
    var deleteAction: (() -> Void)?
    
    // MARK: - Initializer
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        configureAddSubview()
        configureLayout()
        configureShadow()
        setupButtons()
        configureGesture()
    }
    
    // MARK: - Life Cycle
    override func prepareForReuse() {
        super.prepareForReuse()
        resetCellState()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let newBounds = todoDetailView.bounds
        if newBounds != .zero && newBounds != oldTodoDetailViewBounds {
            configureCornerRadius()
            oldTodoDetailViewBounds = newBounds
        }
    }
    
    private func resetCellState() {
        timeLabel.setText("")
        todoDetailView.resetForReuse()
        shadowContainerView.transform = .identity
        timeLabel.transform = .identity
        didSetCornerRadius = false
        oldTodoDetailViewBounds = .zero
        shadowContainerView.isHidden = false
        todoDetailView.isHidden = false
    }
    
    // MARK: - Configuration
    func configure(
        hour: Int,
        showTime: Bool,
        event: TodoDisplayItem?,
        checkBoxAction: (() -> Void)? = nil,
        editAction: (() -> Void)? = nil,
        deleteAction: (() -> Void)? = nil
    ) {
        contentView.backgroundColor = TDColor.Neutral.neutral50

        // 시간 표시
        if hour == Int.max && showTime {
            timeLabel.setText("종일")
        } else if showTime {
            let period = hour >= 12 ? "PM" : "AM"
            let displayHour = (hour == 0) ? 0 : (hour % 12 == 0 ? 12 : hour % 12)
            timeLabel.setText("\(displayHour) \(period)")
        } else {
            timeLabel.setText("")
        }

        // 이벤트 없을 경우
        guard let event else {
            shadowContainerView.isHidden = true
            timeLabel.setColor(TDColor.Neutral.neutral500)
            timeLabel.setFont(TDFont.boldButton)
            return
        }

        // 이벤트 있을 경우
        shadowContainerView.isHidden = false
        let isNone = event.categoryIcon == TDImage.Category.none
        todoDetailView.configureCell(
            color: event.categoryColor,
            title: event.title,
            time: event.time,
            category: event.categoryIcon,
            isNone: isNone,
            isFinished: event.isFinished,
            place: event.place
        )

        // 액션 설정
        if let checkBoxAction {
            todoDetailView.configureButtonAction(checkBoxAction: checkBoxAction)
        }

        if let editAction, let deleteAction {
            self.editAction = editAction
            self.deleteAction = deleteAction
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
    
    private func configureShadow() {
        shadowContainerView.layer.shadowColor = TDColor.baseShadow.cgColor
        shadowContainerView.layer.shadowOpacity = LayoutConstants.shadowOpacity
        shadowContainerView.layer.shadowOffset = LayoutConstants.shadowOffset
        shadowContainerView.layer.shadowRadius = LayoutConstants.shadowRadius
        shadowContainerView.layer.masksToBounds = false
    }
    
    // MARK: - Base Methods
    private func configureAddSubview() {
        contentView.addSubview(timeLabel)
        contentView.addSubview(buttonsContainerView)
        contentView.addSubview(shadowContainerView)
        shadowContainerView.addSubview(todoDetailView)
        buttonsContainerView.addSubview(editButton)
        buttonsContainerView.addSubview(deleteButton)
    }
    
    private func configureLayout() {
        timeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(LayoutConstants.timeLabelLeading)
            make.centerY.equalToSuperview()
            make.width.equalTo(LayoutConstants.timeLabelWidth)
        }
        
        shadowContainerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(LayoutConstants.cellTopPadding)
            make.leading.equalTo(timeLabel.snp.trailing).offset(LayoutConstants.shadowLeading)
            make.trailing.equalToSuperview().offset(LayoutConstants.shadowTrailing)
            make.bottom.equalToSuperview()
        }
        
        todoDetailView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(LayoutConstants.eventDetailInset)
        }
        
        buttonsContainerView.snp.makeConstraints { make in
            make.top.bottom.equalTo(shadowContainerView)
            make.trailing.equalToSuperview().offset(LayoutConstants.buttonContainerTrailing)
            make.width.equalTo(LayoutConstants.buttonContainerWidth)
        }
        
        editButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(LayoutConstants.buttonPadding)
            make.trailing.equalTo(deleteButton.snp.leading)
            make.bottom.equalToSuperview().offset(-LayoutConstants.buttonPadding)
            make.width.equalTo(LayoutConstants.buttonWidth)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(LayoutConstants.buttonPadding)
            make.trailing.equalToSuperview().offset(-LayoutConstants.buttonPadding)
            make.bottom.equalToSuperview().offset(-LayoutConstants.buttonPadding)
            make.width.equalTo(LayoutConstants.buttonWidth - 4)
        }
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
    
    private func animateButtons(shouldOpen: Bool) {
        let targetOffset = shouldOpen ? -maxButtonWidth : 0
        UIView.animate(
            withDuration: AnimationConstants.animationDuration,
            delay: 0,
            usingSpringWithDamping: AnimationConstants.springDamping,
            initialSpringVelocity: 0,
            options: .curveEaseOut
        ) {
            self.applyTransform(offset: targetOffset)
        } completion: { _ in
            self.isSwipeOpened = shouldOpen
        }
    }
    
    // MARK: - Pan Gesture
    private func configureGesture() {
        let panGesture = UIPanGestureRecognizer(
            target: self,
            action: #selector(handlePanGesture(_:))
        )
        panGesture.delegate = self
        contentView.addGestureRecognizer(panGesture)
    }
    
    @objc
    private func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: contentView)
        let velocity = recognizer.velocity(in: contentView)
        
        switch recognizer.state {
        case .changed:
            handlePanChanged(translation: translation)
        case .ended, .cancelled:
            handlePanEnded(translation: translation.x, velocity: velocity.x)
        default:
            break
        }
    }
    
    private func handlePanChanged(translation: CGPoint) {
        let offset = calculateOffset(translationX: translation.x)
        applyTransform(offset: offset)
    }
    
    private func handlePanEnded(translation: CGFloat, velocity: CGFloat) {
        let shouldOpen = shouldRevealButtons(velocityX: velocity)
        
        if !shouldOpen && !isSwipeOpened && (translation > 30 || velocity > 500) {
            animateButtons(shouldOpen: false)
            segmentSwipeAction?()
        } else {
            animateButtons(shouldOpen: shouldOpen)
        }
    }
    
    private func calculateOffset(translationX: CGFloat) -> CGFloat {
        min(max(translationX, -maxButtonWidth), 0)
    }
    
    private func applyTransform(offset: CGFloat) {
        shadowContainerView.transform = CGAffineTransform(translationX: offset, y: 0)
        timeLabel.transform = CGAffineTransform(translationX: offset, y: 0)
    }
    
    private func shouldRevealButtons(velocityX: CGFloat) -> Bool {
        let currentOffset = abs(shadowContainerView.transform.tx)
        let velocityThreshold: CGFloat = 500
        return currentOffset > maxButtonWidth/2 || velocityX < -velocityThreshold
    }
}

// MARK: - Constants
private extension TimeSlotTableViewCell {
    enum LayoutConstants {
        static let timeLabelLeading: CGFloat = 24
        static let timeLabelWidth: CGFloat = 50
        static let cellTopPadding: CGFloat = 6
        static let shadowLeading: CGFloat = 16
        static let shadowTrailing: CGFloat = -16
        static let shadowOffset = CGSize(width: 2, height: 2)
        static let shadowRadius: CGFloat = 2
        static let shadowOpacity: Float = 0.05
        static let eventDetailInset: CGFloat = 4
        static let eventDetailCornerRadius: CGFloat = 8
        static let buttonContainerWidth: CGFloat = 120
        static let buttonContainerTrailing: CGFloat = -16
        static let buttonPadding: CGFloat = 6
        static let buttonWidth: CGFloat = 64
    }
    
    enum AnimationConstants {
        static let animationDuration: TimeInterval = 0.3
        static let springDamping: CGFloat = 0.8
    }
}

// MARK: - UIGestureRecognizer Delegate
extension TimeSlotTableViewCell {
    override func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        // 수평 스와이프 제스처와 테이블뷰의 수직 스크롤 제스처가 동시에 인식되도록 허용
        return true
    }
    
    override func gestureRecognizerShouldBegin(
        _ gestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        if let panGesture = gestureRecognizer as? UIPanGestureRecognizer {
            let velocity = panGesture.velocity(in: contentView)
            // 수평 이동이 수직 이동보다 클 경우 제스처 인식 (수평 스와이프)
            return abs(velocity.x) > abs(velocity.y)
        }
        return true
    }
}
