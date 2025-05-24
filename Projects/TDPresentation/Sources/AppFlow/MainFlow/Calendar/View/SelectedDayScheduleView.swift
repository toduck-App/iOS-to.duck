import TDDesign
import UIKit

final class SelectedDayScheduleView: BaseView {
    // MARK: - UI Components
    let divideTopLineView = UIView.dividedLine()
    let headerView = UIView().then {
        $0.backgroundColor = .white
    }
    let divideBottomLineView = UIView.dividedLine()
    let calendarImageView = UIImageView().then {
        $0.image = TDImage.Calendar.top3Medium
        $0.contentMode = .scaleAspectFill
    }
    let dateLabel = TDLabel(
        toduckFont: .boldHeader5,
        toduckColor: TDColor.Neutral.neutral700
    )
    let addImageView = UIImageView().then {
        $0.image = TDImage.addSmall.withTintColor(TDColor.Neutral.neutral600)
    }
    let scheduleTableView = UITableView().then {
        $0.backgroundColor = TDColor.Neutral.neutral50
    }
    let noScheduleView = UIView()
    let noScheduleImageView = UIImageView(image: TDImage.noEvent)
    let noScheduleLabel = TDLabel(
        labelText: "기록한 일정이 없어요",
        toduckFont: .mediumBody3,
        toduckColor: TDColor.Neutral.neutral500
    )
    
    func updateDateLabel(date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "M월 d일 (E)"
        dateLabel.setText(dateFormatter.string(from: date))
    }
    
    // MARK: - Setup & Configuration
    override func addview() {
        addSubview(divideTopLineView)
        addSubview(headerView)
        addSubview(divideBottomLineView)
        addSubview(scheduleTableView)
        headerView.addSubview(calendarImageView)
        headerView.addSubview(dateLabel)
        headerView.addSubview(addImageView)
        addSubview(noScheduleView)
        noScheduleView.addSubview(noScheduleImageView)
        noScheduleView.addSubview(noScheduleLabel)
    }
    
    override func layout() {
        divideTopLineView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        headerView.snp.makeConstraints {
            $0.top.equalTo(divideTopLineView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(48).priority(.high)
        }
        divideBottomLineView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
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
        
        addImageView.snp.makeConstraints {
            $0.trailing.equalTo(headerView.snp.trailing).offset(-16)
            $0.centerY.equalTo(headerView.snp.centerY)
            $0.size.equalTo(24)
        }
        
        scheduleTableView.snp.makeConstraints {
            $0.top.equalTo(divideBottomLineView.snp.bottom).offset(4)
            $0.leading.equalTo(22)
            $0.trailing.equalTo(-16)
            $0.bottom.equalToSuperview()
        }
        
        noScheduleView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
        noScheduleImageView.snp.makeConstraints {
            $0.top.equalTo(noScheduleView.snp.top)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(96)
        }
        noScheduleLabel.snp.makeConstraints {
            $0.top.equalTo(noScheduleImageView.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
    }
    
    override func configure() {
        backgroundColor = TDColor.Neutral.neutral50
        divideTopLineView.backgroundColor = TDColor.Neutral.neutral300
        divideBottomLineView.backgroundColor = TDColor.Neutral.neutral300
        noScheduleView.isHidden = true
        scheduleTableView.separatorStyle = .none
        scheduleTableView.register(
            ScheduleDetailTableViewCell.self,
            forCellReuseIdentifier: ScheduleDetailTableViewCell.identifier
        )
    }
}
