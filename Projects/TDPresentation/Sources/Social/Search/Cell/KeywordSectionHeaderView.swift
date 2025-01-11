import SnapKit
import TDDesign
import Then
import UIKit

protocol KeywordHeaderCellDelegate: AnyObject {
    func didTapAllDeleteButton(cell: KeywordSectionHeaderView)
}

// MARK: - Header View

final class KeywordSectionHeaderView: UICollectionReusableView {
    weak var delegate: KeywordHeaderCellDelegate?
    
    private let titleLabel = TDLabel(
        toduckFont: .mediumBody2,
        toduckColor: TDColor.Neutral.neutral800
    )
    
    private let removeButton = UIButton().then {
        $0.setTitle("전체 삭제", for: .normal)
        $0.setTitleColor(TDColor.Neutral.neutral600, for: .normal)
        
        $0.titleLabel?.font = TDFont.mediumBody2.font
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
        setAction()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupUI() {
        backgroundColor = TDColor.baseWhite
    }
    
    private func setupLayout() {
        addSubview(titleLabel)
        addSubview(removeButton)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalTo(removeButton.snp.leading).offset(-8)
            make.centerY.equalToSuperview()
        }
        
        removeButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    func configure(section: KeywordSection) {
        titleLabel.setText(section.title)
        removeButton.isHidden = !section.showRemoveButton
    }
    
    func setAction() {
        removeButton.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            delegate?.didTapAllDeleteButton(cell: self)
        }, for: .touchUpInside)
    }
}
