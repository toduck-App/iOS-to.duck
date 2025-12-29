import UIKit
import SnapKit
import Then
import TDDesign

final class DiaryArchiveButton: UIView {

    private let title = TDLabel(
        labelText: "전체 일기 모아보기",
        toduckFont: TDFont.mediumBody2,
        toduckColor: TDColor.Neutral.neutral600
    )

    private let calendarIcon = UIImageView().then {
        $0.image = TDImage.listMedium
        $0.contentMode = .scaleAspectFit
    }

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupUI() {
        backgroundColor = .clear

        let containerStack = UIStackView().then {
            $0.axis = .horizontal
            $0.spacing = 4
            $0.alignment = .center
            $0.isUserInteractionEnabled = false
        }

        addSubview(containerStack)
        containerStack.addArrangedSubview(title)
        containerStack.addArrangedSubview(calendarIcon)

        containerStack.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.edges.equalToSuperview().inset(16)
        }

        calendarIcon.snp.makeConstraints {
            $0.size.equalTo(24)
        }

        snp.makeConstraints {
            $0.width.greaterThanOrEqualTo(162)
            $0.height.greaterThanOrEqualTo(48)
        }

        isAccessibilityElement = true
        accessibilityLabel = "전체 일기 모아보기"
        accessibilityTraits = .button
    }
}
