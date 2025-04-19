import SnapKit
import Then
import UIKit

public final class EventDetailView: UIView {
    // MARK: - UI Components

    private var scheduleIdentyColorView = UIView().then {
        $0.backgroundColor = TDColor.Schedule.text3
    }
    
    private let containerHorizontalStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.alignment = .center
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
    private let scheduleVerticalStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.spacing = 4
    }
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

    /// 시간
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

    /// 장소
    private let placeImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = TDImage.locationMedium
    }
    private let placeLabel = TDLabel(
        toduckFont: TDFont.mediumCaption1,
        alignment: .left,
        toduckColor: TDColor.Neutral.neutral600
    )
    private let placeHorizontalStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .leading
        $0.spacing = 4
    }

    private let checkBoxButton = UIButton().then {
        $0.contentMode = .scaleAspectFit
        $0.setImage(TDImage.CheckBox.empty, for: .normal)
    }
    
    // MARK: - Properties

    private var isFinished: Bool = false
    private var identifierColor: UIColor = .clear
    
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
        isFinished = false
        changeCheckBoxButtonImage(isFinished: isFinished)
    }
    
    /// 셀에 데이터를 설정합니다.
    /// - Parameters:
    ///  - isHomeToduck: 홈 탭바의 토덕 세그먼트에서 사용하는 셀인지 여부 (체크박스가 안 보여야 함)
    public func configureCell(
        isHomeToduck: Bool = false,
        color: UIColor,
        title: String,
        time: String?,
        category: UIImage?,
        isNone: Bool = false,
        isFinished: Bool,
        place: String?
    ) {
        self.isFinished = isFinished
        backgroundColor = TDColor.baseWhite

        configureCategoryImageView(isNone: isNone, color: color, category: category)
        configureLayoutForMode(isHomeToduck: isHomeToduck)
        
        titleLabel.setText(title)
        timeLabel.setText(time ?? "")
        placeLabel.setText(place ?? "")

        timeDetailHorizontalStackView.isHidden = (time == nil)
        placeHorizontalStackView.isHidden = (place == nil)

        changeCheckBoxButtonImage(isFinished: isFinished)
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
            identifierColor = TDColor.baseWhite
        } else {
            let key = ColorValue(color: color)
            let frontColor = TDColor.reversedOpacityPair[key] ?? color
            let backColor = color
            scheduleIdentyColorView.backgroundColor = frontColor
            categoryImageView.configure(backgroundColor: backColor, category: category ?? TDImage.Category.none)
            identifierColor = color
        }
    }

    private func configureLayoutForMode(isHomeToduck: Bool) {
        if isHomeToduck {
            titleLabel.setFont(.boldHeader5)
            timeLabel.setFont(.regularBody2)
            placeLabel.setFont(.regularBody2)

            categoryVerticalStackView.snp.remakeConstraints { $0.width.equalTo(64) }
            categoryImageView.snp.remakeConstraints { $0.width.height.equalTo(64) }
            categoryImageView.setCategoryImageInsets(18)
            categoryImageView.layer.cornerRadius = 32
            categoryImageView.layer.masksToBounds = true

            scheduleIdentyColorView.backgroundColor = TDColor.baseWhite
            checkBoxButton.isHidden = true
        } else {
            categoryVerticalStackView.snp.remakeConstraints { $0.width.equalTo(32) }
            categoryImageView.snp.remakeConstraints { $0.width.height.equalTo(32) }
            categoryImageView.setCategoryImageInsets(8)
        }
    }
    
    public func configureButtonAction(checkBoxAction: @escaping () -> Void) {
        checkBoxButton.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            checkBoxAction()
            isFinished.toggle()
            changeCheckBoxButtonImage(isFinished: isFinished)
        }, for: .touchUpInside)
    }
    
    private func changeCheckBoxButtonImage(isFinished: Bool) {
        let checkBoxImage: UIImage = {
            if isFinished {
                return TDImage.CheckBox.empty
            } else {
                let key = ColorValue(color: identifierColor)
                return TDColor.colorCheckBox[key] ?? TDImage.CheckBox.back15
            }
        }()
        
        checkBoxButton.setImage(checkBoxImage, for: .normal)
    }
    
    private func setup() {
        layer.cornerRadius = 4
        clipsToBounds = true
        addSubview(scheduleIdentyColorView)
        addSubview(containerHorizontalStackView)
        addSubview(checkBoxButton)
        
        containerHorizontalStackView.addArrangedSubview(categoryVerticalStackView)
        containerHorizontalStackView.addArrangedSubview(scheduleVerticalStackView)
        
        categoryVerticalStackView.addArrangedSubview(categoryTopSpacer)
        categoryVerticalStackView.addArrangedSubview(categoryImageView)
        categoryVerticalStackView.addArrangedSubview(categoryBottomSpacer)
        
        scheduleVerticalStackView.addArrangedSubview(eventTopSpacer)
        scheduleVerticalStackView.addArrangedSubview(titleLabel)
        scheduleVerticalStackView.addArrangedSubview(timeDetailHorizontalStackView)
        scheduleVerticalStackView.addArrangedSubview(placeHorizontalStackView)
        scheduleVerticalStackView.addArrangedSubview(eventBottomSpacer)
        
        timeDetailHorizontalStackView.addArrangedSubview(timeImageView)
        timeDetailHorizontalStackView.addArrangedSubview(timeLabel)
        
        
        placeHorizontalStackView.addArrangedSubview(placeImageView)
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
        
        checkBoxButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalTo(titleLabel)
            $0.width.height.equalTo(22)
        }
        
        /// 카테고리 이미지
        categoryVerticalStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
        }
        categoryTopSpacer.snp.makeConstraints {
            $0.height.equalTo(4)
        }
        categoryImageView.snp.makeConstraints {
            $0.width.height.equalTo(32)
        }
        categoryBottomSpacer.snp.makeConstraints {
            $0.height.equalTo(4)
        }
        
        /// 이벤트 제목, 시간, 장소
        scheduleVerticalStackView.snp.makeConstraints {
            $0.leading.equalTo(categoryVerticalStackView.snp.trailing).offset(10)
            $0.trailing.equalTo(checkBoxButton.snp.leading).offset(-16)
            $0.top.equalToSuperview()
        }
        
        eventTopSpacer.snp.makeConstraints {
            $0.height.equalTo(8)
        }
        eventBottomSpacer.snp.makeConstraints {
            $0.height.equalTo(8)
        }
        titleLabel.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(18)
        }
        
        timeDetailHorizontalStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
        }
        timeLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
        }
        timeImageView.snp.makeConstraints {
            $0.size.equalTo(18)
        }
        
        placeHorizontalStackView.snp.makeConstraints {
            $0.top.equalTo(timeDetailHorizontalStackView.snp.bottom).offset(4)
        }
        placeLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
        }
        placeImageView.snp.makeConstraints {
            $0.size.equalTo(18)
        }
    }
}
