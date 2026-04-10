import SnapKit
import TDDesign
import UIKit

final class QRWebLoginPopupView: BaseView {
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 0
        $0.alignment = .center
    }

    private let buttonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
        $0.alignment = .fill
        $0.distribution = .fillEqually
    }

    let popupImageView = UIImageView().then {
        $0.image = TDImage.loginToduck
        $0.contentMode = .scaleAspectFit
    }

    let titleLabel = TDLabel(
        toduckFont: .boldHeader4,
        toduckColor: TDColor.Neutral.neutral800
    )

    let descriptionLabel = TDLabel(
        toduckFont: .mediumHeader5,
        toduckColor: TDColor.Neutral.neutral600
    )

    private(set) var loginButton = TDBaseButton(
        title: "로그인",
        backgroundColor: TDColor.Primary.primary500,
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
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(buttonStackView)
        buttonStackView.addArrangedSubview(cancelButton)
        buttonStackView.addArrangedSubview(loginButton)
    }

    override func layout() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 28, left: 20, bottom: 28, right: 20))
        }

        popupImageView.snp.makeConstraints {
            $0.width.equalTo(200)
            $0.height.equalTo(200)
        }

        stackView.setCustomSpacing(16, after: popupImageView)
        stackView.setCustomSpacing(8, after: titleLabel)
        stackView.setCustomSpacing(24, after: descriptionLabel)

        buttonStackView.snp.makeConstraints {
            $0.height.equalTo(52)
            $0.width.equalToSuperview()
        }

        cancelButton.snp.makeConstraints {
            $0.height.equalTo(52)
        }

        loginButton.snp.makeConstraints {
            $0.height.equalTo(52)
        }
    }

    override func configure() {
        layer.cornerRadius = 28
        backgroundColor = TDColor.baseWhite

        titleLabel.setText("웹 로그인 요청이 들어왔어요")
        descriptionLabel.setText("toduck 웹 페이지에 로그인할까요?")
    }
}
