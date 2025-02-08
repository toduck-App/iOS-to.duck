import UIKit
import TDDesign
import SnapKit
import Then

final class TimeSlotTableViewCell: UITableViewCell {
    // MARK: - UI Components
    private let timeLabel = TDLabel(
        toduckFont: TDFont.mediumBody2,
        toduckColor: TDColor.Neutral.neutral800
    )
    private let shadowContainerView = UIView()
    private let eventDetailView = EventDetailView()
    private let buttonsContainerView = UIView()
    private let editButton = UIButton()
    private let deleteButton = UIButton()
    
    // MARK: - Properties
    private var didSetCornerRadius = false
    private var maxButtonWidth: CGFloat = 120
    var editAction: (() -> Void)?
    var deleteAction: (() -> Void)?
    
    // MARK: - Initializer
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureAddSubview()
        configureLayout()
        configureShadow()
        setupButtons()
        configureGesture()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
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
        setupCornerRadiusIfNeeded()
    }
    
    private func resetCellState() {
        timeLabel.setText("")
        eventDetailView.resetForReuse()
        shadowContainerView.transform = .identity
        timeLabel.transform = .identity
    }
    
    private func setupCornerRadiusIfNeeded() {
        guard !didSetCornerRadius, eventDetailView.bounds != .zero else { return }
        configureCornerRadius()
        didSetCornerRadius = true
    }
    
    // MARK: - Configuration
    func configure(
        timeText: String?,
        event: EventPresentable?
    ) {
        contentView.backgroundColor = TDColor.Neutral.neutral50
        setupContentVisibility(timeText: timeText, event: event)
    }
    
    func configureButtonAction(
        checkBoxAction: @escaping () -> Void
    ) {
        eventDetailView.configureButtonAction(checkBoxAction: checkBoxAction)
    }
    
    func configureSwipeActions(
        editAction: @escaping () -> Void,
        deleteAction: @escaping () -> Void
    ) {
        self.editAction = editAction
        self.deleteAction = deleteAction
    }
    
    private func setupContentVisibility(timeText: String?, event: EventPresentable?) {
        if let text = timeText, !text.isEmpty {
            timeLabel.isHidden = false
            timeLabel.setText(text)
        }
        
        guard let event = event else {
            eventDetailView.isHidden = true
            timeLabel.setColor(TDColor.Neutral.neutral500)
            timeLabel.setFont(TDFont.boldButton)
            return
        }
        
        let isNone = event.categoryIcon == TDImage.Category.none
        eventDetailView.configureCell(
            color: event.categoryColor,
            title: event.title,
            time: event.time,
            category: event.categoryIcon,
            isNone: isNone,
            isFinish: event.isFinish,
            place: nil
        )
    }
    
    private func configureCornerRadius() {
        eventDetailView.layer.cornerRadius = 8
        eventDetailView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        eventDetailView.clipsToBounds = true
        
        let maskPath = UIBezierPath(
            roundedRect: eventDetailView.bounds,
            byRoundingCorners: [.topLeft, .bottomLeft],
            cornerRadii: CGSize(width: 2, height: 2)
        )
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        eventDetailView.layer.mask = maskLayer
    }
    
    private func configureShadow() {
        shadowContainerView.layer.shadowColor = UIColor.black.cgColor
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
        shadowContainerView.addSubview(eventDetailView)
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
        
        eventDetailView.snp.makeConstraints { make in
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
            make.width.equalTo(LayoutConstants.buttonWidth)
        }
    }
    
    private func setupButtons() {
        editButton.backgroundColor = TDColor.Primary.primary300
        deleteButton.backgroundColor = .red
        editButton.setTitle("수정", for: .normal)
        deleteButton.setTitle("삭제", for: .normal)
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
            handlePanEnded(velocity: velocity)
        default:
            break
        }
    }
    
    private func handlePanChanged(translation: CGPoint) {
        let offset = calculateOffset(translationX: translation.x)
        applyTransform(offset: offset)
    }
    
    private func handlePanEnded(velocity: CGPoint) {
        let shouldOpen = shouldRevealButtons(velocityX: velocity.x)
        animateButtons(shouldOpen: shouldOpen)
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
        static let shadowOffset = CGSize(width: 4, height: 4)
        static let shadowRadius: CGFloat = 3
        static let shadowOpacity: Float = 0.1
        static let eventDetailInset: CGFloat = 4
        static let eventDetailCornerRadius: CGFloat = 8
        static let buttonContainerWidth: CGFloat = 120
        static let buttonContainerTrailing: CGFloat = -16
        static let buttonPadding: CGFloat = 4
        static let buttonWidth: CGFloat = 64
    }
    
    enum AnimationConstants {
        static let animationDuration: TimeInterval = 0.3
        static let springDamping: CGFloat = 0.8
    }
}
