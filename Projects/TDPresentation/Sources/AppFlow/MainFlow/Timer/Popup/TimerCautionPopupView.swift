import TDDesign
import UIKit

final class TimerCautionPopupView: BaseView {
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 0
        $0.alignment = .center
    }
    
    private let buttonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .center
        $0.distribution = .equalSpacing
    }
    
    let popupTitleLabel = TDLabel(
        toduckFont: .boldHeader4,
        toduckColor: TDColor.Neutral.neutral800
    )
    
    let popupImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    let descriptionLabel = TDLabel(
        toduckFont: .mediumHeader5,
        toduckColor: TDColor.Neutral.neutral800
    )
    
    private(set) var actionButton = TDBaseButton(
        backgroundColor: TDColor.Schedule.textPH,
        foregroundColor: TDColor.baseWhite,
        radius: 12,
        font: TDFont.boldBody1.font
    )
    
    private(set) var cancelButton = TDBaseButton(
        title: "취소",
        backgroundColor: TDColor.baseWhite,
        foregroundColor: TDColor.Neutral.neutral700,
        radius: 12,
        font: TDFont.boldBody1.font
    ).then {
        $0.layer.borderWidth = 1
        $0.layer.borderColor = TDColor.Neutral.neutral300.cgColor
    }
    
    override func addview() {
        addSubview(stackView)
        stackView.addArrangedSubview(popupImageView)
        stackView.addArrangedSubview(popupTitleLabel)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(buttonStackView)
        buttonStackView.addArrangedSubview(actionButton)
        buttonStackView.addArrangedSubview(cancelButton)
    }
    
    override func layout() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        popupImageView.snp.makeConstraints { make in
            make.width.equalTo(96)
            make.height.equalTo(126)
        }
        
        popupTitleLabel.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.height.equalTo(18)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.height.equalTo(104)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.width.equalTo(160)
            make.height.equalTo(52)
        }
        
        actionButton.snp.makeConstraints { make in
            make.width.equalTo(160)
            make.height.equalTo(52)
        }
    }
    
    override func configure() {
        layer.cornerRadius = 28
        backgroundColor = TDColor.baseWhite
    }
}
