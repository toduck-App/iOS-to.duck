import TDDesign
import UIKit

final class SelectedDayScheduleView: BaseView {
    // MARK: - UI Components
    private let calendarImageView = UIImageView().then {
        $0.image = TDImage.Calendar.top3Medium
        $0.contentMode = .scaleAspectFill
    }
    private let dateLabel = TDLabel(
        toduckFont: .boldHeader5,
        toduckColor: TDColor.Neutral.neutral700
    )
    private let downDirectionImageView = UIImageView().then {
        $0.image = TDImage.Direction.downMedium.withTintColor(TDColor.Neutral.neutral700)
    }
    let headerView = UIView().then {
        $0.backgroundColor = TDColor.Neutral.neutral50
    }
    let scheduleTableView = UITableView().then {
        $0.backgroundColor = .white
    }
    
    func updateDateLabel(date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "M월 d일 (E)"
        dateLabel.setText(dateFormatter.string(from: date))
    }
    
    // MARK: - Setup & Configuration
    override func configure() {
        scheduleTableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: UITableViewCell.identifier
        )
    }
    
    override func addview() {
        addSubview(headerView)
        addSubview(scheduleTableView)
        headerView.addSubview(calendarImageView)
        headerView.addSubview(dateLabel)
        headerView.addSubview(downDirectionImageView)
    }
    
    override func layout() {
        headerView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(48).priority(.high)
        }
        
        calendarImageView.snp.makeConstraints {
            $0.leading.equalTo(headerView.snp.leading).offset(21)
            $0.centerY.equalTo(headerView.snp.centerY)
            $0.width.height.equalTo(24)
        }
        
        dateLabel.snp.makeConstraints {
            $0.leading.equalTo(calendarImageView.snp.trailing).offset(8)
            $0.centerY.equalTo(headerView.snp.centerY)
        }
        
        downDirectionImageView.snp.makeConstraints {
            $0.trailing.equalTo(headerView.snp.trailing).offset(-21)
            $0.centerY.equalTo(headerView.snp.centerY)
            $0.width.height.equalTo(24)
        }
        
        scheduleTableView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.leading.equalTo(22)
            $0.trailing.equalTo(-16)
            $0.bottom.equalToSuperview()
        }
    }
}
