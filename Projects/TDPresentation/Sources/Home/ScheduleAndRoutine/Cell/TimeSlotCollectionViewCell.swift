import UIKit
import TDDesign

final class TimeSlotCollectionViewCell: UICollectionViewCell {
    // MARK: - UI Components
    private let timeLabel = TDLabel(
        toduckFont: TDFont.mediumBody2,
        toduckColor: TDColor.Neutral.neutral800
    )
    private let eventDetailView = EventDetailView()
    private var didSetCornerRadius = false
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
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
            didSetCornerRadius = true
        }
    }
    
    func configure(
        timeText: String?,
        event: EventPresentable
    ) {
        if let text = timeText, !text.isEmpty {
            timeLabel.isHidden = false
            timeLabel.text = text
        } else {
            timeLabel.text = ""
        }
        
        eventDetailView.configureCell(
            color: event.categoryColor,
            title: event.title,
            time: event.time,
            category: event.categoryIcon,
            isFinish: event.isFinish,
            place: nil
        )
    }
    
    func configureButtonAction(
        checkBoxAction: @escaping () -> Void
    ) {
        eventDetailView.configureButtonAction(checkBoxAction: checkBoxAction)
    }
    
    // MARK: - Setup & Configuration
    private func configureAddSubview() {
        contentView.addSubview(timeLabel)
        contentView.addSubview(eventDetailView)
    }
    
    private func configureLayout() {
        timeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.centerY.equalToSuperview()
            make.width.equalTo(50)
        }
        
        eventDetailView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(6)
            make.leading.equalTo(timeLabel.snp.trailing).offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview()
        }
    }
    
    private func configureCornerRadius() {
        eventDetailView.layer.cornerRadius = 8
        eventDetailView.layer.maskedCorners = [
            .layerMaxXMinYCorner, // 오른쪽 위
            .layerMaxXMaxYCorner  // 오른쪽 아래
        ]
        eventDetailView.clipsToBounds = true
        
        // 왼쪽 위와 왼쪽 아래는 따로 설정
        let path = UIBezierPath(
            roundedRect: eventDetailView.bounds,
            byRoundingCorners: [.topLeft, .bottomLeft],
            cornerRadii: CGSize(width: 2, height: 2)
        )
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        eventDetailView.layer.mask = mask
    }
}
