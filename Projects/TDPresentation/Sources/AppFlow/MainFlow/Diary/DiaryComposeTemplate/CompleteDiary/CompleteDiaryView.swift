import UIKit
import TDDomain
import TDDesign

final class CompleteDiaryView: BaseView {
    private var currentStreakCount: Int = 0
    private let topBlurGradientView = TopBlurGradientCircleView(color: TDColor.Primary.primary500)
    let titleLabel = TDLabel(
        labelText: "연속 일기 작성 0일째",
        toduckFont: .boldHeader4,
        alignment: .center,
        toduckColor: TDColor.Neutral.neutral800
    )
    
    let descriptionLabel = TDLabel(
        labelText: "기록 레벨이 올라가고 있어요",
        toduckFont: .boldHeader2,
        alignment: .center,
        toduckColor: TDColor.Neutral.neutral800
    )
    
    let descriptionIcon = UIImageView().then {
        $0.image = TDImage.fireSmall
        $0.contentMode = .scaleAspectFit
    }
    
    let imageView = UIImageView().then {
        $0.image = TDImage.Diary.completeThumnail
        $0.contentMode = .scaleAspectFit
    }
    
    let commentContainerView = UIView().then {
        $0.layer.cornerRadius = 16
        $0.backgroundColor = TDColor.Neutral.neutral50
    }
    
    let commentLabel = TDLabel(
        labelText: "짝짝짝 👏🏻 아주 잘했어요 !",
        toduckFont: .mediumHeader5,
        alignment: .center,
        toduckColor: TDColor.Neutral.neutral600
    )
    
    let streakStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 6
        $0.alignment = .center
        $0.distribution = .fillProportionally
    }.then {
        for _ in 0..<7 {
            let circleView = UIView().then {
                $0.backgroundColor = TDColor.Neutral.neutral100
                $0.layer.cornerRadius = 15
                $0.layer.borderColor = TDColor.Neutral.neutral400.cgColor
                $0.layer.borderWidth = 1
                $0.snp.makeConstraints { make in
                    make.size.equalTo(30)
                }
            }
            $0.addArrangedSubview(circleView)
        }
    }
    
    let buttonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.backgroundColor = TDColor.baseWhite
        $0.spacing = 10
        $0.alignment = .leading
    }
    
    let doneButton = TDBaseButton(
        title: "작성한 일기 확인",
        backgroundColor: TDColor.Primary.primary500,
        foregroundColor: TDColor.baseWhite,
        radius: 12,
        font: TDFont.boldHeader3.font
    )
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        resetStreakCircles()
        fillStreakCircles(count: currentStreakCount)
    }

    
    // MARK: - Common Methods
    
    override func addview() {
        addSubview(topBlurGradientView)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(descriptionIcon)
        addSubview(imageView)
        addSubview(streakStackView)
        addSubview(commentContainerView)
        commentContainerView.addSubview(commentLabel)
        addSubview(buttonStackView)
        buttonStackView.addArrangedSubview(doneButton)
    }
    
    override func layout() {
        topBlurGradientView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(1.2)
            $0.height.equalTo(topBlurGradientView.snp.width)
            $0.top.equalToSuperview().offset(-320)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(140)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(18)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(24)
        }
        
        descriptionIcon.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.leading.equalTo(descriptionLabel.snp.trailing).offset(2)
            $0.centerY.equalTo(descriptionLabel)
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(26)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(280)
        }
        
        streakStackView.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(28)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(30)
        }
        
        commentContainerView.snp.makeConstraints {
            $0.bottom.equalTo(buttonStackView.snp.top).offset(-28)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(48)
        }
        
        commentLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        buttonStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(56)
            $0.bottom.equalToSuperview().inset(28)
        }
    }
    
    func configure(count: Int) {
        currentStreakCount = count
        titleLabel.setText("연속 일기 작성 \(count)일째")
        titleLabel.highlight([.init(token: "\(count)일째", color: TDColor.Primary.primary500)])
        fillStreakCircles(count: count)
        setNeedsLayout()
    }

    
    override func configure() {
        backgroundColor = TDColor.baseWhite
        doneButton.isEnabled = true
    }
    
    private func resetStreakCircles() {
        for case let circleView in streakStackView.arrangedSubviews {
            circleView.backgroundColor = TDColor.Neutral.neutral100
            circleView.layer.borderColor = TDColor.Neutral.neutral400.cgColor
            circleView.layer.borderWidth = 1
            circleView.layer.shadowOpacity = 0
            circleView.layer.shadowRadius = 0
            circleView.layer.shadowOffset = .zero
            circleView.subviews.forEach { $0.removeFromSuperview() }
        }
    }
    
    private func addCheckImage(to circleView: UIView) {
        let checkImage = UIImageView().then {
            $0.image = TDImage.checkNeutral
                .withRenderingMode(.alwaysTemplate)
            $0.tintColor = TDColor.baseWhite
            $0.contentMode = .scaleAspectFit
        }
        
        circleView.addSubview(checkImage)
        checkImage.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(18)
        }
    }
    
    private func applyGradientAndShadow(to circleView: UIView) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            TDColor.Primary.primary300.cgColor,
            TDColor.Primary.primary500.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint   = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.frame = circleView.bounds
        gradientLayer.cornerRadius = circleView.bounds.width / 2
        
        circleView.backgroundColor = .clear
        circleView.layer.insertSublayer(gradientLayer, at: 0)
        
        circleView.layer.shadowColor = TDColor.Primary.primary500.cgColor
        circleView.layer.shadowOpacity = 0.4
        circleView.layer.shadowRadius = 8
        circleView.layer.shadowOffset = CGSize(width: 0, height: 0)
        circleView.layer.borderWidth = 1
        circleView.layer.borderColor = TDColor.baseWhite.cgColor
    }
    
    private func fillStreakCircles(count: Int) {
        let clamped = max(0, min(count, streakStackView.arrangedSubviews.count))
        guard clamped > 0 else { return }
        
        layoutIfNeeded()
        streakStackView.layoutIfNeeded()
        
        for (index, view) in streakStackView.arrangedSubviews.enumerated() {
            guard index < clamped else { continue }
            let circleView = view
            
            if index == clamped - 1 {
                applyGradientAndShadow(to: circleView)
                addCheckImage(to: circleView)
            } else {
                circleView.backgroundColor = TDColor.Primary.primary500
                circleView.layer.borderWidth = 0
                circleView.layer.shadowOpacity = 0
                addCheckImage(to: circleView)
            }
        }
    }
}
