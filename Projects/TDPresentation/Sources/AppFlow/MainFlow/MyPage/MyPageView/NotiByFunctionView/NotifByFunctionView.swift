import TDDesign
import UIKit

final class NotifByFunctionView: BaseView {
    var toggles: [TDToggle] = []

    let settingContainer = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 12
        $0.alignment = .fill
        $0.distribution = .fill
    }
        
    override func addview() {
        addSubview(settingContainer)
        let items = [
            ("공지 사항", "어플 기능 업데이트 소식 등"),
            ("홈", "일정, 루틴 등"),
            ("집중", "타이머 알림 등"),
            ("일기", "일기 작성 권유 알림 등"),
            ("소셜", "좋아요, 댓글, 대댓글 등")
        ]
            
        for (index, item) in items.enumerated() {
            let container = makeContainerView(
                title: item.0,
                description: item.1,
                tag: index
            )
            settingContainer.addArrangedSubview(container)
        }
    }
    
    override func layout() {
        settingContainer.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(20)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
    }
}

extension NotifByFunctionView {
    func makeContainerView(title: String,
                           description: String,
                           tag: Int) -> UIView
    {
        let container = UIView()
        container.backgroundColor = TDColor.baseWhite
        container.layer.cornerRadius = 12
        
        let titleLabel = TDLabel(
            labelText: title,
            toduckFont: .mediumBody2,
            toduckColor: TDColor.Neutral.neutral800
        )
        
        let descriptionLabel = TDLabel(
            labelText: description,
            toduckFont: .regularCaption1,
            toduckColor: TDColor.Neutral.neutral600
        )
        
        let switchControl = TDToggle()
        switchControl.tag = tag
        toggles.append(switchControl)
        
        for item in [titleLabel, descriptionLabel, switchControl] {
            container.addSubview(item)
        }
        
        container.snp.makeConstraints {
            $0.height.equalTo(75)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(16)
            $0.trailing.equalTo(switchControl.snp.leading).offset(-21)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalTo(titleLabel)
            $0.bottom.equalToSuperview().offset(-16)
        }
        
        switchControl.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
        }
        
        return container
    }
}
