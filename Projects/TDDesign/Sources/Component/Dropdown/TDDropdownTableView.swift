import UIKit

final class DropDownTableView: UITableView {
    private let itemHeight: CGFloat = 44

    // MARK: - Initializers

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        rowHeight = itemHeight
        layer.cornerRadius = 12
        layer.masksToBounds = true
        isScrollEnabled = false
//        separatorInset = UIEdgeInsets(top: 1, left: 0, bottom: 1, right: 0)
        separatorColor = .clear
        register(DropDownCell.self, forCellReuseIdentifier: DropDownCell.identifier)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if bounds.size != intrinsicContentSize {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return contentSize
    }
}

// MARK: - Internal Methods

extension DropDownTableView {
    func deselectAllCell() {
        visibleCells.forEach { $0.isSelected = false }
    }

    func selectRow(at indexPath: IndexPath) {
        deselectAllCell()
        (cellForRow(at: indexPath) as? DropDownCell)?.isSelected = true
    }
}
