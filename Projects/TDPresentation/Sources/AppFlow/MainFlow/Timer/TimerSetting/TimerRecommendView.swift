import TDDesign
import UIKit
import SnapKit
import Then

final class TimerRecommendView: BaseView {
    let recommandView = UIView().then {
        $0.layer.borderWidth = 1
        $0.layer.borderColor = TDColor.Neutral.neutral300.cgColor
        $0.layer.cornerRadius = 10
    }
    
    let fireImageView = UIImageView().then {
        $0.image = TDImage.fireSmall
    }
    
    let titleLabel = TDLabel(
        labelText: "추천 설정",
        toduckFont: .boldBody2,
        alignment: .center,
        toduckColor: TDColor.Neutral.neutral800
    )
    
    let recommandLabelStack = UIStackView().then {
        $0.spacing = 8
        $0.axis = .horizontal
        $0.distribution = .fillProportionally
        $0.alignment = .center
    }
    
    // MARK: Common Methods
    
    override func addview() {
        addSubview(recommandView)
        recommandView.addSubview(fireImageView)
        recommandView.addSubview(titleLabel)
        recommandView.addSubview(recommandLabelStack)

        for text in ["횟수 4회", "시간 25분", "휴식 5분"] {
            let label = TDLabel(labelText: text, toduckFont: .boldBody2, toduckColor: TDColor.Neutral.neutral600)
            let divider = TDLabel(labelText: "|", toduckFont: .mediumCaption3, toduckColor: TDColor.Neutral.neutral300)
            recommandLabelStack.addArrangedSubview(label)
            recommandLabelStack.addArrangedSubview(divider)
        }
        recommandLabelStack.arrangedSubviews.last?.removeFromSuperview()
    }
    
    override func layout() {
        recommandView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        fireImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
            make.size.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(fireImageView.snp.trailing).offset(4)
            make.centerY.equalToSuperview()
        }
        
        recommandLabelStack.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(8)
        }
    }
    
    func updateForegroundColorForSelected(isSelected: Bool) {
        if isSelected {
            backgroundColor = TDColor.Primary.primary50
            recommandView.layer.borderColor = TDColor.Primary.primary500.cgColor
            fireImageView.tintColor = TDColor.Primary.primary500
            titleLabel.textColor = TDColor.Primary.primary500
            recommandLabelStack.arrangedSubviews.forEach {
                if let label = $0 as? TDLabel {
                    label.textColor = TDColor.Primary.primary500
                }
            }
        } else {
            backgroundColor = TDColor.baseWhite
            recommandView.layer.borderColor = TDColor.Neutral.neutral300.cgColor
            fireImageView.tintColor = TDColor.Neutral.neutral600
            titleLabel.textColor = TDColor.Neutral.neutral800
            recommandLabelStack.arrangedSubviews.forEach {
                if let label = $0 as? TDLabel {
                    label.textColor = TDColor.Neutral.neutral600
                }
            }
        }
    }
}
