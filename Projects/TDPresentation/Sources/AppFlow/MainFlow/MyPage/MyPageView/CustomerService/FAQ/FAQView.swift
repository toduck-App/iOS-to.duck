import SnapKit
import TDDesign
import UIKit

final class FAQView: BaseView {

    // MARK: - UI Components

    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }

    private let contentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 0
        $0.alignment = .fill
    }

    private(set) lazy var inquiryButton = TDBaseButton(
        title: "문의하기",
        image: TDImage.addSmall.withRenderingMode(.alwaysTemplate).withTintColor(.white),
        backgroundColor: TDColor.Primary.primary500,
        foregroundColor: TDColor.baseWhite,
        radius: 25,
        font: TDFont.boldHeader4.font
    )

    // MARK: - Setup

    override func addview() {
        addSubview(scrollView)
        scrollView.addSubview(contentStackView)
        addSubview(inquiryButton)
    }

    override func configure() {
        backgroundColor = TDColor.baseWhite
        buildContent()
    }

    override func layout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        contentStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        inquiryButton.snp.makeConstraints {
            $0.width.equalTo(120)
            $0.height.equalTo(50)
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(20)
        }
    }

    // MARK: - Build

    private func buildContent() {
        contentStackView.addArrangedSubview(makeHeaderView())

        for section in FAQDataSource.sections {
            contentStackView.addArrangedSubview(makeSectionHeaderView(title: section.category.rawValue))
            contentStackView.addArrangedSubview(makeSectionCardView(items: section.items))
        }

        let bottomSpacer = UIView()
        bottomSpacer.snp.makeConstraints { $0.height.equalTo(24) }
        contentStackView.addArrangedSubview(bottomSpacer)
    }

    private func makeHeaderView() -> UIView {
        let container = UIView()
        container.backgroundColor = TDColor.baseWhite

        let iconImageView = UIImageView().then {
            $0.image = TDImage.counselMedium
            $0.contentMode = .scaleAspectFit
        }

        let titleLabel = TDLabel(
            toduckFont: .boldHeader3,
            toduckColor: TDColor.Neutral.neutral800
        ).then {
            $0.setText("무엇을 도와드릴까요?")
        }

        container.addSubview(iconImageView)
        container.addSubview(titleLabel)

        iconImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(24)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }

        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(iconImageView.snp.trailing).offset(8)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
        }

        container.snp.makeConstraints { $0.height.equalTo(40) }
        return container
    }

    private func makeSectionHeaderView(title: String) -> UIView {
        let container = UIView()

        let label = TDLabel(
            toduckFont: .boldHeader5,
            toduckColor: TDColor.Neutral.neutral800
        )
        label.setText(title)

        container.addSubview(label)
        label.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(24)
            $0.trailing.equalToSuperview().inset(16)
            $0.top.equalToSuperview().offset(24)
            $0.bottom.equalToSuperview().inset(8)
        }

        return container
    }

    private func makeSectionCardView(items: [FAQItem]) -> UIView {
        let wrapper = UIView()

        let cardView = UIView().then {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 12
            $0.clipsToBounds = true
            $0.layer.borderColor = TDColor.Neutral.neutral100.cgColor
            $0.layer.borderWidth = 1
        }

        let stackView = UIStackView().then {
            $0.axis = .vertical
            $0.spacing = 0
            $0.alignment = .fill
        }

        wrapper.addSubview(cardView)
        cardView.addSubview(stackView)

        cardView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.bottom.equalToSuperview()
        }

        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        for item in items {
            let itemView = FAQItemView()
            itemView.configure(with: item)
            itemView.onHeightChange = { [weak self] in
                self?.layoutIfNeeded()
            }
            stackView.addArrangedSubview(itemView)
        }

        return wrapper
    }
}
