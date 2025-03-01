import TDDesign
import TDDomain
import TDCore
import UIKit

final class ThemeItemControl: UIControl {
    // MARK: - Properties

    private var theme: TDTimerTheme

    // MARK: - UI Components

    private let checkBoxView = TDCheckbox(
        frame: .zero,
        backgroundColor: TDColor.Primary.primary500,
        foregroundColor: .white
    )

    private let themeImageView = UIImageView().then {
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
    }

    private let controlLabel = TDLabel(toduckFont: .mediumHeader5, toduckColor: TDColor.Neutral.neutral600)

    // MARK: - Initializers

    init(theme: TDTimerTheme) {
        self.theme = theme
        super.init(frame: .zero)

        configure()
        addviews()
        layout()
    }

    required init?(coder: NSCoder) {
        theme = .Bboduck
        super.init(coder: coder)
    }

    func configure() {
        checkBoxView.isUserInteractionEnabled = false
        themeImageView.isUserInteractionEnabled = false
        checkBoxView.isSelected = false
        controlLabel.setText(theme.name)
        themeImageView.image = theme.image

        themeImageView.clipsToBounds = true
        themeImageView.layer.cornerRadius = 12
        themeImageView.layer.borderColor = TDColor.Neutral.neutral300.cgColor
        themeImageView.layer.borderWidth = theme == .Simple ? 1 : 0
    }

    func layout() {
        checkBoxView.snp.makeConstraints { make in
            make.size.equalTo(ThemeItemViewLayoutConstant.checkBoxSize)
            make.top.leading.equalToSuperview().inset(ThemeItemViewLayoutConstant.checkBoxInset)
        }

        themeImageView.snp.makeConstraints { make in
            make.size.equalTo(ThemeItemViewLayoutConstant.themeImageViewSize)
        }

        controlLabel.snp.makeConstraints { make in
            make.top.equalTo(themeImageView.snp.bottom).offset(ThemeItemViewLayoutConstant.itemLabelTop)
            make.leading.equalTo(themeImageView.snp.leading).inset(ThemeItemViewLayoutConstant.itemLabelLeading)
        }

        snp.makeConstraints { make in
            make.height.equalTo(
                ThemeItemViewLayoutConstant.themeImageViewSize +
                    ThemeItemViewLayoutConstant.itemLabelTop +
                    ThemeItemViewLayoutConstant.itemLabelHeight
            )
        }
    }

    func addviews() {
        addSubview(themeImageView)
        addSubview(checkBoxView)
        addSubview(controlLabel)
    }

    override var isSelected: Bool {
        didSet {
            checkBoxView.isSelected = isSelected
            controlLabel.setColor(isSelected ? TDColor.Primary.primary500 : TDColor.Neutral.neutral600)
            controlLabel.setFont(isSelected ? .boldHeader5 : .mediumHeader5)
        }
    }
}

// MARK: - Enum

extension ThemeItemControl {
    enum ThemeItemViewLayoutConstant {
        static let checkBoxSize: CGFloat = 22
        static let checkBoxInset: CGFloat = 12
        static let themeImageViewSize: CGFloat = (UIScreen.main.bounds.width - 42) / 2
        static let themeImageViewTop: CGFloat = 16
        static let itemLabelTop: CGFloat = 12
        static let itemLabelHeight: CGFloat = 19
        static let itemLabelLeading: CGFloat = 8
    }
}

private extension TDTimerTheme {
    var name: String {
        switch self {
        case .Bboduck:
            return "뽀덕이"
        case .Simple:
            return "심플"
        }
    }

    var image: UIImage {
        switch self {
        case .Bboduck:
            return TDImage.ThemePreview.BboduckPreview
        case .Simple:
            return TDImage.ThemePreview.SimplePreview
        }
    }
}
