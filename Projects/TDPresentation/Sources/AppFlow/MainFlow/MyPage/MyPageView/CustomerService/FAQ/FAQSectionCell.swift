import SnapKit
import TDDesign
import UIKit

final class FAQSectionCell: UITableViewCell {
    private var onToggleItem: ((Int) -> Void)?

    // MARK: - UI Components

    private let cardView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.layer.borderColor = TDColor.Neutral.neutral100.cgColor
        $0.layer.borderWidth = 1
    }

    private let itemStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 0
        $0.alignment = .fill
    }

    // MARK: - Initialize

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        contentView.addSubview(cardView)
        cardView.addSubview(itemStackView)

        cardView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        itemStackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(12)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }

    // MARK: - Configure

    func configure(with items: [FAQItem], onToggle: @escaping (Int) -> Void) {
        onToggleItem = onToggle
        itemStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for (index, item) in items.enumerated() {
            let itemView = FAQItemView()
            let capturedIndex = index
            itemView.configure(with: item)
            itemView.onTap = { [weak self] in
                self?.onToggleItem?(capturedIndex)
            }
            itemStackView.addArrangedSubview(itemView)
        }
    }

    func updateItem(at index: Int, isExpanded: Bool) {
        let subviews = itemStackView.arrangedSubviews
        guard index < subviews.count, let itemView = subviews[index] as? FAQItemView else { return }
        itemView.setExpanded(isExpanded)
    }
}
