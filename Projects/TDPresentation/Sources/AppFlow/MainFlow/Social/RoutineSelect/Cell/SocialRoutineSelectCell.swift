import SnapKit
import TDDesign
import UIKit

final class SocialRoutineSelectCell: UITableViewCell {
    private let categoryView = TDCategoryCircleView()
    private let titleLabel = TDLabel(
        toduckFont: .boldHeader5,
        toduckColor: TDColor.Neutral.neutral800
    )
    private let memoLabel = TDLabel(
        toduckFont: .regularCaption1,
        toduckColor: TDColor.Neutral.neutral600
    )

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = TDColor.baseWhite
        configureAddSubview()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureAddSubview()
        configureLayout()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.setText("")
        memoLabel.setText("")
        categoryView.configure(
            backgroundColor: .clear,
            category: TDImage.Category.none
        )
    }

    func configure(event: any EventPresentable) {
        titleLabel.setText(event.title)
        memoLabel.setText(event.memo ?? "")
        categoryView.configure(
            backgroundColor: event.categoryColor,
            category: event.categoryIcon ?? TDImage.Category.none
        )
    }

    private func configureAddSubview() {
        contentView.addSubview(categoryView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(memoLabel)
    }

    private func configureLayout() {
        categoryView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(32)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalTo(categoryView.snp.trailing).offset(12)
            $0.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(20)
        }

        memoLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(20)
            $0.height.equalTo(18)
        }
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)

        UIView.animate(withDuration: 0.1) {
            self.transform = highlighted ? CGAffineTransform(scaleX: 1.03, y: 1.03) : .identity
            self.backgroundColor = highlighted ? TDColor.Neutral.neutral100 : TDColor.baseWhite
        }
    }
}
