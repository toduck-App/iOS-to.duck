import UIKit
import TDDomain
import TDDesign

final class CompleteDiaryView: BaseView {
    
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

    
    // MARK: - Common Methods
    
    override func addview() {

        addSubview(buttonStackView)
        buttonStackView.addArrangedSubview(doneButton)
    }
    
    override func layout() {
        

        buttonStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(56)
            $0.bottom.equalToSuperview().inset(28)
        }
    }
    
    override func configure() {
        backgroundColor = TDColor.baseWhite
        doneButton.isEnabled = true
    }
}
