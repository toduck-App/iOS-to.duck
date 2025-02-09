import SnapKit
import Then
import UIKit

public final class EventDetailView: UIView {
    // MARK: - UI Components

    private var scheduleIdentyColorView = UIView().then {
        $0.backgroundColor = TDColor.Schedule.text3
    }
    
    /// 카테고리 이미지
    private let categoryVerticalStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
        $0.spacing = 4
    }

    private let categoryTopSpacer = UIView()
    private let categoryBottomSpacer = UIView()
    private let categoryImageView = TDCategoryCircleView()
    
    /// 일정 제목, 시간, 장소
    private let eventTopSpacer = UIView()
    private let eventBottomSpacer = UIView()
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

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
        setupLayout()
    }
    
    override public func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
        setupLayout()
    }
    
    // MARK: - Public Methods

    public func resetForReuse() {
        titleLabel.text = nil
        timeLabel.text = nil
        placeLabel.text = nil
        categoryImageView.resetForReuse()
        isFinish = false
        changeCheckBoxButtonImage(isFinish: isFinish)
    }
    
    public func configureCell(
        isHomeToduck: Bool = false,
        color: UIColor,
        title: String,
        time: String?,
        category: UIImage?,
        isNone: Bool = false,
        isFinish: Bool,
        place: String?
    ) {
        self.isFinish = isFinish
        backgroundColor = TDColor.baseWhite

        configureCategoryImageView(isNone: isNone, color: color, category: category)
        configureLayoutForMode(isHomeToduck: isHomeToduck)
        
        titleLabel.setText(title)
        timeLabel.setText(time ?? "")
        placeLabel.setText(place ?? "")

        timeDetailHorizontalStackView.isHidden = (time == nil)
        placeHorizontalStackView.isHidden = (place == nil)

        changeCheckBoxButtonImage(isFinish: isFinish)
    }

    // MARK: - Private Methods

    private func configureCategoryImageView(
        isNone: Bool,
        color: UIColor,
        category: UIImage?
    ) {
        if isNone {
            categoryImageView.configure(
                backgroundColor: TDColor.baseWhite,
                category: category ?? TDImage.Category.none
            )
            scheduleIdentyColorView.backgroundColor = TDColor.baseWhite
        } else {
            scheduleIdentyColorView.backgroundColor = TDColor.reversedPair[color] ?? color
            categoryImageView.configure(backgroundColor: color, category: category ?? TDImage.Category.none)
        }
    }

    private func configureLayoutForMode(isHomeToduck: Bool) {
        if isHomeToduck {
            titleLabel.setFont(.boldHeader5)
            timeLabel.setFont(.regularBody2)
            placeLabel.setFont(.regularBody2)

            categoryVerticalStackView.snp.remakeConstraints { $0.width.equalTo(64) }
            categoryImageView.snp.remakeConstraints { $0.width.height.equalTo(64) }
            categoryImageView.layer.cornerRadius = 32
            categoryImageView.layer.masksToBounds = true

            scheduleIdentyColorView.backgroundColor = TDColor.baseWhite
            checkBoxButton.isHidden = true
        } else {
            categoryVerticalStackView.snp.remakeConstraints { $0.width.equalTo(32) }
            categoryImageView.snp.remakeConstraints { $0.width.height.equalTo(32) }
        }
    }
    
    public func configureButtonAction(checkBoxAction: @escaping () -> Void) {
        checkBoxButton.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            checkBoxAction()
            isFinish.toggle()
            changeCheckBoxButtonImage(isFinish: isFinish)
        }, for: .touchUpInside)
    }
    
    private func changeCheckBoxButtonImage(isFinish: Bool) {
        let checkBoxImage = isFinish ? TDImage.CheckBox.back10 : TDImage.CheckBox.empty
        checkBoxButton.setImage(checkBoxImage, for: .normal)
    }
    
    private func setup() {
        layer.cornerRadius = 4
        clipsToBounds = true
        addSubview(scheduleIdentyColorView)
        addSubview(containerHorizontalStackView)
        
        categoryVerticalStackView.addArrangedSubview(categoryTopSpacer)
        categoryVerticalStackView.addArrangedSubview(categoryImageView)
        categoryVerticalStackView.addArrangedSubview(categoryBottomSpacer)
        
        containerHorizontalStackView.addArrangedSubview(categoryVerticalStackView)
        containerHorizontalStackView.addArrangedSubview(scheduleVerticalStackView)
        
        scheduleVerticalStackView.addArrangedSubview(eventTopSpacer)
        scheduleVerticalStackView.addArrangedSubview(titleLabel)
        scheduleVerticalStackView.addArrangedSubview(timeDetailHorizontalStackView)
        scheduleVerticalStackView.addArrangedSubview(placeHorizontalStackView)
        scheduleVerticalStackView.addArrangedSubview(eventBottomSpacer)
        
        timeDetailHorizontalStackView.addArrangedSubview(timeImageView)
        timeDetailHorizontalStackView.addArrangedSubview(timeLabel)
        
        addSubview(checkBoxButton)
        
        placeHorizontalStackView.addArrangedSubview(locationImageView)
        placeHorizontalStackView.addArrangedSubview(placeLabel)
    }
    
    private func setupLayout() {
        scheduleIdentyColorView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo(4)
        }
        
        containerHorizontalStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalTo(scheduleIdentyColorView.snp.trailing).offset(16)
            $0.trailing.equalTo(checkBoxButton.snp.leading).offset(-16)
        }
        
        categoryVerticalStackView.snp.makeConstraints {
            $0.width.equalTo(32)
        }
        
        categoryImageView.snp.makeConstraints {
            $0.width.height.equalTo(32)
        }
        
        checkBoxButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalTo(titleLabel)
            $0.width.height.equalTo(22)
        }
        
        eventTopSpacer.snp.makeConstraints {
            $0.height.equalTo(8)
        }
        eventBottomSpacer.snp.makeConstraints {
            $0.height.equalTo(8)
        }
        
        timeLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
        }
        placeLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
        }
    }
}
