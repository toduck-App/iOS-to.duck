import Combine
import SnapKit
import TDCore
import TDDesign
import Then
import UIKit

final class SocialEventJoinSuccessView: BaseView {

    private let containerStack = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fill
        $0.spacing = 0
        $0.isLayoutMarginsRelativeArrangement = true
        $0.directionalLayoutMargins = .init(
            top: 28,
            leading: 16,
            bottom: 16,
            trailing: 16
        )
        $0.backgroundColor = TDColor.baseWhite
        $0.layer.cornerRadius = 16
        $0.layer.masksToBounds = true
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
        addSubview(containerStack)
        [giftImageView, titleLabel, descriptionLabel, doneButton].forEach {
            containerStack.addArrangedSubview($0)
        }
    }

    override func layout() {
        containerStack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }

        giftImageView.snp.makeConstraints { make in
            make.height.equalTo(120)
        }
        doneButton.snp.makeConstraints { make in
            make.height.equalTo(52)
        }

        containerStack.setCustomSpacing(24, after: giftImageView)
        containerStack.setCustomSpacing(10, after: titleLabel)
        containerStack.setCustomSpacing(36, after: descriptionLabel)
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
        popupContentView.doneButton.addAction(
            UIAction { [weak self] _ in
                self?.dismissPopup()
            },
            for: .touchUpInside
        )
    }

    override func layout() {
        super.layout()
    }
}
