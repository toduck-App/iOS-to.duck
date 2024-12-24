import UIKit
import TDDesign

final class TimeSlotCollectionViewCell: UICollectionViewCell {
    // MARK: - UI Components
    private let timeLabel = TDLabel(
        toduckFont: TDFont.boldBody2,
        toduckColor: TDColor.Neutral.neutral800
    )
    private let eventDetailView = ScheduleDetailCell()
    
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
    
    func configure(
        timeText: String?,
        event: EventPresentable
    ) {
        if let text = timeText, !text.isEmpty {
            timeLabel.isHidden = false
            timeLabel.text = text
        } else {
            // 두 번째(이후) 일정인 경우, 시간 라벨 숨김
            // timeLabel.isHidden = true
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
    
    // MARK: - Setup & Configuration
    private func configureAddSubview() {
        contentView.addSubview(timeLabel)
        contentView.addSubview(eventDetailView)
    }
    
    private func configureLayout() {
        timeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(8)
        }
        
        eventDetailView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalTo(timeLabel.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.bottom.equalToSuperview()
        }
    }
}
