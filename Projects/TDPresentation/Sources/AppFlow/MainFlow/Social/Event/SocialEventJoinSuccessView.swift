import Combine
import SnapKit
import TDCore
import TDDesign
import Then
import UIKit


final class SocialEventJoinSuccessView: BaseView {
    private let containerView = UIView().then {
        $0.backgroundColor = TDColor.baseWhite
    }
    
    private let giftImageView = UIImageView().then {
        $0.image = TDImage.Event.eventGfit
        $0.contentMode = .scaleAspectFit
    }
    
    private let titleLabel = TDLabel(
        labelText: "이벤트 응모가 완료되었어요!",
        toduckFont: .boldHeader4,
        alignment: .center,
        toduckColor: TDColor.Neutral.neutral600
    )
    
    private let descriptionLabel = TDLabel(
        labelText: "상품권의 주인공은 혹시..?",
        toduckFont: .boldHeader5,
        alignment: .center,
        toduckColor: TDColor.Neutral.neutral600
    )
    
    var doneButton = TDBaseButton(
        title: "확인",
        backgroundColor: TDColor.Primary.primary500,
        foregroundColor: TDColor.baseWhite,
        font: TDFont.boldHeader3.font,
        radius: 12
    )
    
    override func addview() {
        addSubview(containerView)
        containerView.addSubview(giftImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(doneButton)
    }
    
    override func layout() {
        containerView.snp.makeConstraints { make in
            make.height.equalTo(358)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        giftImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(28)
            make.centerX.equalToSuperview()
            make.size.equalTo(120)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(giftImageView.snp.bottom).inset(24)
            make.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(10)
            make.centerX.equalToSuperview()
        }
        
        doneButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(52)
        }
    }
}

final class SocialEventJoinSuccessViewController: TDPopupViewController<SocialEventJoinSuccessView> {

    override init() {
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func configure() {
        super.configure()
        popupContentView.backgroundColor = TDColor.baseWhite
        popupContentView.doneButton.addAction(UIAction { [weak self] _ in
            self?.dismissPopup()
        }, for: .touchUpInside)
    }
    
    override func layout() {
        super.layout()
    }
}
