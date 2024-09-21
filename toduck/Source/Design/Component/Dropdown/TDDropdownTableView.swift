import UIKit

final class DropDownTableView: UITableView {
    private let itemHeight: CGFloat = 40
    
    // MARK: - Initializers
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        rowHeight = itemHeight
        
        layer.cornerRadius = 8
        layer.masksToBounds = true
        
        separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        register(DropDownCell.self, forCellReuseIdentifier: DropDownCell.identifier)
    }
    
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
        self.visibleCells.forEach { $0.isSelected = false }
    }
    
    func selectRow(at indexPath: IndexPath) {
        deselectAllCell()
        (self.cellForRow(at: indexPath) as? DropDownCell)?.isSelected = true
    }
}
