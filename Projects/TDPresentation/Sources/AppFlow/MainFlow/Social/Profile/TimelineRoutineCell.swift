import SnapKit
import TDDesign
import TDDomain
import Then
import UIKit

final class TimelineRoutineCell: UITableViewCell {
    // MARK: - UI Components
    
    private let timelineLabel = TDLabel(toduckFont: .mediumHeader5, toduckColor: TDColor.Neutral.neutral800).then {
        $0.textAlignment = .left
        $0.numberOfLines = 1
    }
    
    private let routineColorView = UIView().then {
        $0.backgroundColor = TDColor.Schedule.text3
    }
    
    private let categoryVerticalStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
        $0.spacing = 4
    }
    
    private let categoryImageView = TDCategoryCircleView()
    
    private let scheduleVerticalStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.spacing = 4
    }
    
    private let contentLabel = TDLabel(toduckFont: .mediumBody2, toduckColor: TDColor.Neutral.neutral800).then {
        $0.numberOfLines = 1
    }
    
    private let timeHorizontalStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 4
    }
    
    private let timeImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = TDImage.clockMedium
    }
    
    private let timeLabel = TDLabel(
        toduckFont: TDFont.mediumCaption1,
        alignment: .left,
        toduckColor: TDColor.Neutral.neutral600
    )
    
    private let containerHorizontalStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 8
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 8
        $0.layer.shadowColor = UIColor(red: 72/255, green: 74/255, blue: 76/255, alpha: 1).cgColor
        $0.layer.shadowOffset = CGSize(width: 1, height: 1)
        $0.layer.shadowRadius = 4
        $0.layer.shadowOpacity = 0.05
    }

    private let shareButton = UIButton(type: .system).then {
        var config = UIButton.Configuration.plain()
        config.imagePlacement = .top
        config.imagePadding = 8
        config.titleAlignment = .center
        config.baseForegroundColor = TDColor.Neutral.neutral800
        config.baseBackgroundColor = TDColor.baseWhite
        var titleAttrString = AttributedString()
        titleAttrString.font = TDFont.regularCaption1.font
        titleAttrString.foregroundColor = TDColor.Neutral.neutral600
        config.attributedTitle = titleAttrString
        $0.configuration = config
        $0.setImage(TDImage.Repeat.arrowMedium, for: .normal)
        
        $0.layer.cornerRadius = 8
        $0.layer.shadowColor = UIColor(red: 72/255, green: 74/255, blue: 76/255, alpha: 1).cgColor
        $0.layer.shadowOffset = CGSize(width: 1, height: 1)
        $0.layer.shadowRadius = 4
        $0.layer.shadowOpacity = 0.05
    }

    private let spacerView = UIView().then {
        $0.backgroundColor = .clear
        $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }

    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0))
    }

    // MARK: - Setup
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(timelineLabel)
        contentView.addSubview(containerHorizontalStackView)
        contentView.addSubview(shareButton)
        
        categoryVerticalStackView.addArrangedSubview(categoryImageView)
        
        timeHorizontalStackView.addArrangedSubview(timeImageView)
        timeHorizontalStackView.addArrangedSubview(timeLabel)
        
        scheduleVerticalStackView.addArrangedSubview(contentLabel)
        scheduleVerticalStackView.addArrangedSubview(timeHorizontalStackView)
        
        containerHorizontalStackView.addArrangedSubview(routineColorView)
        containerHorizontalStackView.addArrangedSubview(categoryVerticalStackView)
        containerHorizontalStackView.addArrangedSubview(scheduleVerticalStackView)
        containerHorizontalStackView.addArrangedSubview(spacerView)
        
        timelineLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(8)
            make.width.equalTo(54)
        }
        
        routineColorView.snp.makeConstraints { make in
            make.width.equalTo(4)
            make.height.equalTo(75)
        }
        
        containerHorizontalStackView.snp.makeConstraints { make in
            make.leading.equalTo(timelineLabel.snp.trailing).offset(8)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.trailing.equalTo(shareButton.snp.leading).offset(-8)
            make.height.equalTo(75)
        }

        shareButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(8)
            make.centerY.equalTo(containerHorizontalStackView.snp.centerY)
            make.height.equalTo(75)
            make.width.equalTo(48)
        }
        
        timeImageView.snp.makeConstraints { make in
            make.size.equalTo(12)
        }
    }
    
    // MARK: - Configure
    
    func configure(with hour: Int, routine: Routine, showTime: Bool) {
        if hour == -1 {
            // 종일인 경우: showTime이 true일 때만 "종일" 표시
            if showTime {
                timelineLabel.setText("종일")
            } else {
                timelineLabel.setText("")
            }
        } else if showTime {
            let period: String
            let displayHour: Int
            
            if hour == 0 {
                period = "AM"
                displayHour = 12
            } else if hour < 12 {
                period = "AM"
                displayHour = hour // 0은 이미 처리됨
            } else if hour == 12 {
                period = "PM"
                displayHour = hour
            } else {
                period = "PM"
                displayHour = hour - 12
            }
            
            timelineLabel.setText("\(displayHour) \(period)")
        } else {
            timelineLabel.setText("")
        }
        
        let color = routine.category.colorHex.convertToUIColor() ?? .white
        let category = TDCategoryImageType(rawValue: routine.category.imageName).image
        categoryImageView.configure(backgroundColor: color, category: category)
        
        let key = ColorValue(color: color)
        routineColorView.backgroundColor = TDColor.reversedOpacityFrontPair[key] ?? color
        contentLabel.setText(routine.title)
        
        if let time = routine.time?.convertToString(formatType: .time24Hour) {
            timeLabel.setText(time)
            timeHorizontalStackView.isHidden = false
        } else {
            timeLabel.setText("")
            timeHorizontalStackView.isHidden = true
        }
        
        var titleAttrString = AttributedString(
            "\(routine.shareCount)")
        titleAttrString.font = TDFont.regularCaption1.font
        titleAttrString.foregroundColor = TDColor.Neutral.neutral600
        shareButton.configuration?.attributedTitle = titleAttrString
    }
}
