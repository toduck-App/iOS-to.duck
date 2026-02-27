import SnapKit
import TDDesign
import UIKit

/// 문의하기 화면 전용 확인 안내 뷰
final class InquiryNoticeView: UIView {

    // MARK: - UI Components

    private let iconImageView = UIImageView().then {
        $0.image = TDImage.warningCheckMedium
        $0.contentMode = .scaleAspectFit
    }

    private let titleLabel = TDLabel(
        toduckFont: .boldBody2,
        toduckColor: TDColor.Primary.primary500
    ).then {
        $0.setText("확인해주세요")
        $0.numberOfLines = 1
    }

    private let descriptionStack = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 0
        $0.alignment = .leading
        $0.distribution = .fillProportionally
    }

    // MARK: - Init

    init() {
        super.init(frame: .zero)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Method

    func addDescription(_ description: String) {
        let label = TDLabel(
            toduckFont: .mediumCaption1,
            toduckColor: TDColor.Neutral.neutral700
        ).then {
            $0.setText(description)
            $0.numberOfLines = 0
            $0.setLineHeightMultiple(1.5)
        }
        descriptionStack.addArrangedSubview(label)
    }
}

// MARK: - Layout

private extension InquiryNoticeView {
    func setupUI() {
        backgroundColor = TDColor.Primary.primary25
        layer.cornerRadius = 10

        addSubview(iconImageView)
        addSubview(titleLabel)
        addSubview(descriptionStack)

        iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(16)
            make.size.equalTo(24)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(4)
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalTo(iconImageView)
        }

        descriptionStack.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.leading.equalTo(iconImageView)
            make.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
        }
    }
}
