import SnapKit
import TDDesign
import UIKit

final class FAQItemView: UIView {
    var onTap: (() -> Void)?
    var onHeightChange: (() -> Void)?

    private var isExpanded = false
    private var collapsedHeightConstraint: Constraint?

    // MARK: - UI Components

    private let contentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 0
        $0.alignment = .fill
    }

    private let questionRowView = UIView()

    private let questionLabel = TDLabel(
        toduckFont: .mediumBody2,
        toduckColor: TDColor.Neutral.neutral800
    ).then {
        $0.numberOfLines = 0
    }

    private let chevronImageView = UIImageView().then {
        $0.image = TDImage.downMedium.withRenderingMode(.alwaysOriginal)
        $0.tintColor = TDColor.Neutral.neutral500
        $0.contentMode = .scaleAspectFit
    }

    private let answerContainerView = UIView().then {
        $0.backgroundColor = TDColor.Neutral.neutral50
        $0.clipsToBounds = true
    }

    private let answerLabel = TDLabel(
        toduckFont: .regularBody2,
        toduckColor: TDColor.Neutral.neutral600
    ).then {
        $0.numberOfLines = 0
    }

    // MARK: - Initialize

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        addSubview(contentStackView)
        contentStackView.addArrangedSubview(questionRowView)
        contentStackView.addArrangedSubview(answerContainerView)

        questionRowView.addSubview(questionLabel)
        questionRowView.addSubview(chevronImageView)
        answerContainerView.addSubview(answerLabel)

        contentStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        questionLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.equalTo(chevronImageView.snp.leading).offset(-8)
            $0.top.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().inset(16)
        }

        chevronImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalTo(questionLabel)
            $0.size.equalTo(18)
        }

        answerLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalToSuperview().offset(16).priority(UILayoutPriority(749))
            $0.bottom.equalToSuperview().inset(16).priority(UILayoutPriority(749))
        }

        answerContainerView.snp.makeConstraints {
            collapsedHeightConstraint = $0.height.equalTo(0).constraint
        }

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        questionRowView.addGestureRecognizer(tapGesture)
        questionRowView.isUserInteractionEnabled = true
    }

    @objc private func handleTap() {
        if let onTap {
            onTap()
            return
        }
        isExpanded.toggle()
        if isExpanded {
            collapsedHeightConstraint?.deactivate()
        } else {
            collapsedHeightConstraint?.activate()
        }
        UIView.animate(withDuration: 0.3) {
            self.chevronImageView.transform = self.isExpanded ? CGAffineTransform(rotationAngle: .pi) : .identity
            self.onHeightChange?()
        }
    }

    // MARK: - Configure

    func configure(with item: FAQItem) {
        questionLabel.setText(item.question)
        answerLabel.setText(item.answer)
    }

    func setExpanded(_ expanded: Bool) {
        isExpanded = expanded
        if expanded {
            collapsedHeightConstraint?.deactivate()
        } else {
            collapsedHeightConstraint?.activate()
        }
        chevronImageView.transform = expanded ? CGAffineTransform(rotationAngle: .pi) : .identity
    }
}
