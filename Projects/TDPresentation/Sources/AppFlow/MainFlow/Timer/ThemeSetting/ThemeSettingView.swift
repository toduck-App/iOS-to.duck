import TDDesign
import TDDomain
import UIKit

final class ThemeSettingView: BaseView {
    let exitButton: TDBaseButton = TDBaseButton(image: TDImage.X.x1Medium, backgroundColor: .clear,foregroundColor: TDColor.Neutral.neutral700)

    let themeSettingTitleLabel = TDLabel(
        labelText: "테마 설정", toduckFont: .boldHeader4, alignment: .center,
        toduckColor: TDColor.Neutral.neutral800
    )

    let themeStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.distribution = .fillEqually
        $0.alignment = .fill
    }

    let themeBbouckButton = ThemeItemControl(theme: .toduck)
    let themeSimpleButton = ThemeItemControl(theme: .simple)

    let saveButton: TDButton = .init(title: "저장", size: .large)

    override func configure() {
        backgroundColor = .white
    }

    override func addview() {
        addSubview(exitButton)
        addSubview(themeSettingTitleLabel)
        addSubview(themeStackView)
        addSubview(saveButton)

        themeStackView.addArrangedSubview(themeBbouckButton)
        themeStackView.addArrangedSubview(themeSimpleButton)

    }

    override func layout() {
        exitButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(LayoutConstant.exitButtonLeading)
            make.top.equalToSuperview().inset(LayoutConstant.exitButtonTop)
            make.size.equalTo(LayoutConstant.exitButtonSize)
        }

        themeSettingTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(exitButton.snp.centerY)
        }

        themeStackView.snp.makeConstraints { make in
            make.leading.equalTo(exitButton.snp.leading)
            make.trailing.equalToSuperview().inset(LayoutConstant.themeStackViewTrailing)
            make.top.equalTo(exitButton.snp.bottom).offset(LayoutConstant.themeStackViewTop)
        }

        saveButton.snp.makeConstraints { make in
            make.leading.equalTo(themeStackView.snp.leading)
            make.trailing.equalTo(themeStackView.snp.trailing)
            make.height.equalTo(LayoutConstant.saveButtonHeight)
            make.top.equalTo(themeBbouckButton.snp.bottom).offset(LayoutConstant.saveButtonTop)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(LayoutConstant.saveButtonBottom).priority(750)
        }
    }
}

// MARK: - Enum

extension ThemeSettingView {
    enum LayoutConstant {
        static let exitButtonSize: CGFloat = 24
        static let exitButtonLeading: CGFloat = 16
        static let exitButtonTop: CGFloat = 24

        static let themeStackViewTrailing: CGFloat = 16
        static let themeStackViewTop: CGFloat = 42

        static let saveButtonHeight: CGFloat = 56
        static let saveButtonTop: CGFloat = 36
        static let saveButtonBottom: CGFloat = 16
    }
}
