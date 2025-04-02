import UIKit
import Then

public final class FocusDetailView: UIView {
    // MARK: - UI Components
    // 날짜 섹션
    private let dateHeaderStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.alignment = .center
    }
    private let focusContainerView = UIView().then {
        $0.layer.cornerRadius = 24
        $0.backgroundColor = TDColor.Primary.primary50
    }
    private let focusImageView = UIImageView()
    
    private let dateVerticalStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
        $0.alignment = .leading
    }
    private let dateLabel = TDLabel(toduckFont: TDFont.mediumCaption1, toduckColor: TDColor.Neutral.neutral600)
    private let percentLabel = TDLabel(toduckFont: TDFont.mediumBody2, toduckColor: TDColor.Neutral.neutral900)
    
    /// 오늘 집중 시간
    private let titleContainerView = UIView()
    private let clockIcon = UIImageView(image: TDImage.clockFill)
    private let titleLabel = TDLabel(
        labelText: "오늘 집중 시간",
        toduckFont: TDFont.boldBody2,
        toduckColor: TDColor.Neutral.neutral600
    )
    
    /// 총 시간
    private let timeContainerView = UIView().then {
        $0.layer.cornerRadius = 8
        $0.backgroundColor = TDColor.baseWhite
        $0.layer.borderColor = TDColor.Neutral.neutral300.cgColor
        $0.layer.borderWidth = 1
    }
    private let timeInfoLabel = TDLabel(
        labelText: "총 시간",
        toduckFont: TDFont.boldCaption1,
        toduckColor: TDColor.Neutral.neutral600
    )
    private let timeStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 2
        $0.alignment = .center
    }
    private let userHourLabel = TDLabel(
        toduckFont: TDFont.boldBody2,
        toduckColor: TDColor.Neutral.neutral800
    )
    private let hourLabel = TDLabel(
        labelText: "h",
        toduckFont: TDFont.regularBody2,
        toduckColor: TDColor.Neutral.neutral700
    )
    private let userMinuteLabel = TDLabel(
        toduckFont: TDFont.boldBody2,
        toduckColor: TDColor.Neutral.neutral800
    )
    private let minuteLabel = TDLabel(
        labelText: "m",
        toduckFont: TDFont.regularBody2,
        toduckColor: TDColor.Neutral.neutral700
    )
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAddView()
        setupLayout()
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupAddView() {
        addSubview(dateHeaderStackView)
        addSubview(titleContainerView)
        addSubview(timeContainerView)
        
        dateHeaderStackView.addArrangedSubview(focusContainerView)
        dateHeaderStackView.addArrangedSubview(dateVerticalStackView)
        
        focusContainerView.addSubview(focusImageView)
        
        dateVerticalStackView.addArrangedSubview(dateLabel)
        dateVerticalStackView.addArrangedSubview(percentLabel)
        
        titleContainerView.addSubview(clockIcon)
        titleContainerView.addSubview(titleLabel)
        
        timeContainerView.addSubview(timeInfoLabel)
        timeContainerView.addSubview(timeStackView)
        
        timeStackView.addArrangedSubview(userHourLabel)
        timeStackView.addArrangedSubview(hourLabel)
        timeStackView.addArrangedSubview(userMinuteLabel)
        timeStackView.addArrangedSubview(minuteLabel)
    }
    
    private func setupLayout() {
        dateHeaderStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.trailing.equalToSuperview().inset(12)
            $0.height.equalTo(48)
        }
        focusContainerView.snp.makeConstraints {
            $0.size.equalTo(48)
        }
        focusImageView.snp.makeConstraints {
            $0.size.equalToSuperview().inset(6)
            $0.center.equalToSuperview()
        }
        
        titleContainerView.snp.makeConstraints {
            $0.top.equalTo(dateHeaderStackView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(12)
            $0.height.equalTo(24)
        }
        clockIcon.snp.makeConstraints { $0.size.equalTo(16) }
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(clockIcon.snp.trailing).offset(4)
            $0.centerY.equalTo(clockIcon)
        }
        
        timeContainerView.snp.makeConstraints {
            $0.top.equalTo(titleContainerView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(12)
            $0.height.equalTo(48)
        }
        
        timeInfoLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(8)
            $0.centerY.equalToSuperview()
        }
        timeStackView.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-8)
            $0.centerY.equalToSuperview()
        }
    }
    
    private func configureUI() {
        backgroundColor = TDColor.baseWhite
        layer.cornerRadius = 12
    }
    
    // MARK: - Public Method
    
    public func configure(
        focusImage: UIImage,
        date: String,
        percent: Int,
        userHour: Int,
        userMinute: Int
    ) {
        focusImageView.image = focusImage
        dateLabel.setText(date)
        percentLabel.setText("집중도 \(percent)%")
        
        userHourLabel.setText("\(userHour)")
        userMinuteLabel.setText("\(userMinute)")
    }
}
