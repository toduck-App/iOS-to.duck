import SnapKit
import TDDomain
import Then
import UIKit

public final class ScheduleDetailCell: UITableViewCell {
    // MARK: - UI Components
    private let scheduleIdentyColorView = UIView().then {
        $0.backgroundColor = TDColor.Schedule.text3
    }
    private let categoryImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    private let titleLabel = TDLabel(
        toduckFont: TDFont.mediumBody2,
        alignment: .left,
        toduckColor: TDColor.Neutral.neutral800
    )
    private let timeImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = TDImage.clockMedium
    }
    private let timeLabel = TDLabel(
        toduckFont: TDFont.mediumCaption1,
        alignment: .left,
        toduckColor: TDColor.Neutral.neutral600
    )
    private let timeDetailHorizontalStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .leading
        $0.spacing = 4
    }
    private let scheduleVerticalStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.spacing = 4
    }
    private let checkBoxImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = TDImage.CheckBox.empty
    }
    private let containerHorizontalStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.alignment = .center
    }
    
    // MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
        setupLayout()
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        
        categoryImageView.image = nil
        titleLabel.text = nil
        timeLabel.text = nil
        checkBoxImageView.image = nil
    }
    
    // MARK: - Setup & Configuration
    public func configure(title: String, time: String?, category: UIImage?, isFinish: Bool) {
        titleLabel.text = title
        categoryImageView.image = category != nil ? category : nil
        categoryImageView.isHidden = category == nil

        timeLabel.text = time != nil ? time : nil
        timeDetailHorizontalStackView.isHidden = time == nil
        
        checkBoxImageView.image = isFinish ? TDImage.CheckBox.back10 : TDImage.CheckBox.empty
    }
    
    private func setup() {
        contentView.layer.cornerRadius = 4
        contentView.clipsToBounds = true
        contentView.addSubview(scheduleIdentyColorView)
        contentView.addSubview(containerHorizontalStackView)
        
        containerHorizontalStackView.addArrangedSubview(categoryImageView)
        containerHorizontalStackView.addArrangedSubview(scheduleVerticalStackView)
        
        scheduleVerticalStackView.addArrangedSubview(titleLabel)
        scheduleVerticalStackView.addArrangedSubview(timeDetailHorizontalStackView)
        
        timeDetailHorizontalStackView.addArrangedSubview(timeImageView)
        timeDetailHorizontalStackView.addArrangedSubview(timeLabel)
        contentView.addSubview(checkBoxImageView)
    }
    
    private func setupLayout() {
        scheduleIdentyColorView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(8)
            $0.width.equalTo(4)
        }
        
        containerHorizontalStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(scheduleIdentyColorView.snp.trailing).offset(16)
            $0.trailing.equalTo(checkBoxImageView.snp.leading).offset(-16)
        }
        
        categoryImageView.snp.makeConstraints {
            $0.width.height.equalTo(32)
        }
        
        scheduleVerticalStackView.snp.makeConstraints {
            $0.centerY.equalTo(containerHorizontalStackView.snp.centerY)
        }
        
        checkBoxImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(22)
        }
    }
}
