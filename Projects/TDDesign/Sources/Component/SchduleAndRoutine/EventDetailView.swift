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
        $0.spacing = 8
    }
    private let categoryTopSpacer = UIView()
    private let categoryBottomSpacer = UIView()
    private let categoryImageContainerView = UIView().then {
        $0.layer.cornerRadius = 16
        $0.clipsToBounds = true
    }
    private let categoryImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
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
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
        setupLayout()
    }
    
    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
        setupLayout()
    }
    
    // MARK: - Public Methods
    public func resetForReuse() {
        titleLabel.text = nil
        timeLabel.text = nil
        placeLabel.text = nil
        categoryImageContainerView.backgroundColor = nil
        categoryImageView.image = nil
        isFinish = false
        changeCheckBoxButtonImage(isFinish: isFinish)
    }
    
    public func configureCell(
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
        
        categoryImageContainerView.backgroundColor = color
        scheduleIdentyColorView.backgroundColor = isNone
        ? TDColor.baseWhite
        : color
        
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
    
    // MARK: - Private Methods
    private func changeCheckBoxButtonImage(isFinish: Bool) {
        let checkBoxImage = isFinish ? TDImage.CheckBox.back10 : TDImage.CheckBox.empty
        checkBoxButton.setImage(checkBoxImage, for: .normal)
    }
    
    private func setup() {
        layer.cornerRadius = 4
        clipsToBounds = true
        addSubview(scheduleIdentyColorView)
        addSubview(containerHorizontalStackView)
        categoryImageContainerView.addSubview(categoryImageView)
        
        categoryVerticalStackView.addArrangedSubview(categoryTopSpacer)
        categoryVerticalStackView.addArrangedSubview(categoryImageContainerView)
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
        categoryImageContainerView.snp.makeConstraints {
            $0.width.equalTo(32)
            $0.height.equalTo(32)
        }
        categoryImageView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(8)
        }
        
        checkBoxButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
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
