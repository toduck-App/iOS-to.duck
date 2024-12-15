import TDDesign
import UIKit

final class SocialBlockView: BaseView {
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
    
    private let titleLabel = TDLabel(labelText: "작성자 차단", toduckFont: .boldHeader4, toduckColor: TDColor.Neutral.neutral800)
    
    private let descriptionLabel = TDLabel(labelText: "차단한 사용자의 글이 더이상 보이지 않아요.", toduckFont: .mediumBody2, toduckColor: TDColor.Neutral.neutral800)
    
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
    
    private(set) var blockButton = TDBaseButton(
        title: "차단",
        backgroundColor: TDColor.Schedule.textPH,
        foregroundColor: TDColor.baseWhite,
        radius: 12,
        font: TDFont.boldBody1.font
    )
    
    override func addview() {
        addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(buttonStackView)
        buttonStackView.addArrangedSubview(cancelButton)
        buttonStackView.addArrangedSubview(blockButton)
    }
    
    override func layout() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(66)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.height.equalTo(80)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.width.equalTo(160)
            make.height.equalTo(48)
        }
        
        blockButton.snp.makeConstraints { make in
            make.width.equalTo(160)
            make.height.equalTo(48)
        }
    }
    
    override func configure() {
        layer.cornerRadius = 28
        backgroundColor = TDColor.baseWhite
    }
}
