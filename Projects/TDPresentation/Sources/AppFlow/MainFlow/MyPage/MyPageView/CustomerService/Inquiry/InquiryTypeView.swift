import SnapKit
import TDDesign
import UIKit

final class InquiryTypeView: UIView {

    // MARK: - UI Components

    private let innerStack = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 14
        $0.alignment = .fill
    }

    private let titleLabel = TDRequiredTitle().then {
        $0.setTitleLabel("문의 유형")
        $0.setTitleFont(.boldHeader5)
        $0.setRequiredLabel()
    }

    private(set) lazy var chipCollectionView = TDChipCollectionView(
        chipType: .init(
            backgroundColor: .init(
                activeColor: TDColor.Primary.primary500,
                inActiveColor: TDColor.baseWhite
            ),
            fontColor: .init(
                activeColor: TDColor.baseWhite,
                inActiveColor: TDColor.Neutral.neutral700
            ),
            cornerRadius: 8,
            height: 33
        ),
        hasAllSelectChip: false,
        isMultiSelect: false
    )

    private let errorLabel = TDLabel(
        labelText: "문의 유형을 선택해주세요",
        toduckFont: .regularCaption1,
        toduckColor: TDColor.Semantic.error
    )

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Method

    func setTypeSelected(_ selected: Bool) {
        errorLabel.isHidden = selected
    }
}

// MARK: - Layout

private extension InquiryTypeView {
    func setLayout() {
        addSubview(innerStack)
        innerStack.addArrangedSubview(titleLabel)
        innerStack.addArrangedSubview(chipCollectionView)
        innerStack.addArrangedSubview(errorLabel)
        innerStack.setCustomSpacing(14, after: chipCollectionView)

        innerStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        chipCollectionView.snp.makeConstraints { make in
            make.height.equalTo(33)
        }
    }
}
