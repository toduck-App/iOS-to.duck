import UIKit
import TDDesign

final class TimeSlotTableViewCell: UITableViewCell {
    // MARK: - UI Components
    private let timeLabel = TDLabel(
        toduckFont: TDFont.mediumBody2,
        toduckColor: TDColor.Neutral.neutral800
    )
    private let shadowContainerView = UIView()
    private let eventDetailView = EventDetailView()
    
    // MARK: - Properties
    private var didSetCornerRadius = false
    
    // MARK: - Initializer
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureAddSubview()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureAddSubview()
        configureLayout()
    }
    
    // MARK: - Life Cycle
    override func prepareForReuse() {
        super.prepareForReuse()
        timeLabel.text = ""
        eventDetailView.resetForReuse()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // bounds가 설정된 후에만 CornerRadius 설정
        if !didSetCornerRadius && eventDetailView.bounds != .zero {
            configureCornerRadius()
            configureShadow()
            didSetCornerRadius = true
        }
    }
    
    func configure(
        timeText: String?,
        event: EventPresentable?
    ) {
        contentView.backgroundColor = TDColor.Neutral.neutral50
        
        if let text = timeText, !text.isEmpty {
            timeLabel.isHidden = false
            timeLabel.text = text
        }
        
        if let event = event {
            eventDetailView.configureCell(
                color: event.categoryColor,
                title: event.title,
                time: event.time,
                category: event.categoryIcon,
                isFinish: event.isFinish,
                place: nil
            )
        } else {
            eventDetailView.isHidden = true
            timeLabel.setColor(TDColor.Neutral.neutral500)
            timeLabel.setFont(TDFont.boldButton)
        }
    }
    
    func configureButtonAction(
        checkBoxAction: @escaping () -> Void
    ) {
        eventDetailView.configureButtonAction(checkBoxAction: checkBoxAction)
    }
    
    // MARK: - Setup & Configuration
    private func configureAddSubview() {
        contentView.addSubview(timeLabel)
        contentView.addSubview(shadowContainerView)
        shadowContainerView.addSubview(eventDetailView)
    }
    
    private func configureLayout() {
        timeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.centerY.equalToSuperview()
            make.width.equalTo(50)
        }
        
        shadowContainerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(6)
            make.leading.equalTo(timeLabel.snp.trailing).offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview()
        }
        
        eventDetailView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - CornerRadius 설정
    private func configureCornerRadius() {
        eventDetailView.layer.cornerRadius = 8
        eventDetailView.layer.maskedCorners = [
            .layerMaxXMinYCorner, // 오른쪽 위
            .layerMaxXMaxYCorner  // 오른쪽 아래
        ]
        eventDetailView.clipsToBounds = true
        
        let path = UIBezierPath(
            roundedRect: eventDetailView.bounds,
            byRoundingCorners: [.topLeft, .bottomLeft],
            cornerRadii: CGSize(width: 2, height: 2)
        )
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        eventDetailView.layer.mask = mask
    }
    
    // MARK: - Shadow 설정
    private func configureShadow() {
        shadowContainerView.layer.shadowColor = UIColor.black.cgColor
        shadowContainerView.layer.shadowOpacity = 0.1
        shadowContainerView.layer.shadowOffset = CGSize(width: 4, height: 3)
        shadowContainerView.layer.shadowRadius = 3
        shadowContainerView.layer.masksToBounds = false
    }
}
