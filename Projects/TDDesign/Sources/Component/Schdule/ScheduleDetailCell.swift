import SnapKit
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
    private let locationImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = TDImage.locationMedium
    }
    private let placeLabel = TDLabel(
        toduckFont: TDFont.regularBody2,
        alignment: .left,
        toduckColor: TDColor.Neutral.neutral600
    )
    private let placeHorizontalStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .leading
        $0.spacing = 4
    }
    private let scheduleVerticalStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.spacing = 4
    }
    private let checkBoxButton = UIButton().then {
        $0.contentMode = .scaleAspectFit
        $0.setImage(TDImage.CheckBox.empty, for: .normal)
    }
    private let containerHorizontalStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.alignment = .center
    }
    
    // MARK: - Properties
    private var isFinish: Bool = false
    
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
        placeLabel.text = nil
    }
    
    // MARK: - Setup & Configuration
    // MARK: - Configuration
    public func configureCell(
        color: UIColor,
        title: String,
        time: String?,
        category: UIImage?,
        isFinish: Bool,
        place: String?
    ) {
        self.isFinish = isFinish
        contentView.backgroundColor = TDColor.baseWhite
        
        scheduleIdentyColorView.backgroundColor = color
        titleLabel.text = title
        categoryImageView.image = category
        categoryImageView.isHidden = (category == nil)
        
        timeLabel.text = time
        timeDetailHorizontalStackView.isHidden = (time == nil)
        placeLabel.text = place
        placeHorizontalStackView.isHidden = (place == nil)
        
        changeCheckBoxButtonImage(isFinish: isFinish)
    }

    public func configureButtonAction(checkBoxAction: @escaping () -> Void) {
        checkBoxButton.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            checkBoxAction()
            self.isFinish.toggle()
            self.changeCheckBoxButtonImage(isFinish: self.isFinish)
        }, for: .touchUpInside)
    }

    private func changeCheckBoxButtonImage(isFinish: Bool) {
        let checkBoxImage = isFinish ? TDImage.CheckBox.back10 : TDImage.CheckBox.empty
        checkBoxButton.setImage(checkBoxImage, for: .normal)
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
        scheduleVerticalStackView.addArrangedSubview(placeHorizontalStackView)
        
        timeDetailHorizontalStackView.addArrangedSubview(timeImageView)
        timeDetailHorizontalStackView.addArrangedSubview(timeLabel)
        contentView.addSubview(checkBoxButton)
        
        placeHorizontalStackView.addArrangedSubview(locationImageView)
        placeHorizontalStackView.addArrangedSubview(placeLabel)
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
            $0.trailing.equalTo(checkBoxButton.snp.leading).offset(-16)
        }
        
        categoryImageView.snp.makeConstraints {
            $0.width.height.equalTo(32)
        }
        
        scheduleVerticalStackView.snp.makeConstraints {
            $0.centerY.equalTo(containerHorizontalStackView.snp.centerY)
        }
        
        checkBoxButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(22)
        }
        
        timeLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
        }
        
        placeLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
        }
    }
}
