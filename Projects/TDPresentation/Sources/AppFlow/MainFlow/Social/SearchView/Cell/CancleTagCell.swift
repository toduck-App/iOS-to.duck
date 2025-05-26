import SnapKit
import TDDesign
import UIKit

protocol CancleTagCellDelegate: AnyObject {
    func didTapCancleButton(cell: CancleTagCell)
}

final class CancleTagCell: UICollectionViewCell {
    weak var delegate: CancleTagCellDelegate?
    
    private let tagLabel = TDLabel(
        toduckFont: .mediumBody2,
        toduckColor: TDColor.Neutral.neutral700
    ).then {
        $0.numberOfLines = 1
    }
    
    private let cancleButton = UIButton().then {
        let image = TDImage.X.x2Small.withRenderingMode(.alwaysTemplate)
        $0.setImage(image, for: .normal)
        $0.tintColor = TDColor.Neutral.neutral600
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
        setAction()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        tagLabel.text = nil
    }
    
    func setupUI() {
        backgroundColor = TDColor.Neutral.neutral50
        layer.cornerRadius = 8
    }
    
    func setupLayout() {
        contentView.addSubview(tagLabel)
        contentView.addSubview(cancleButton)
        
        tagLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(12)
            make.top.bottom.equalToSuperview().inset(6)
            make.centerY.equalToSuperview()
            make.height.equalTo(21)
        }
        
        cancleButton.snp.makeConstraints { make in
            make.leading.equalTo(tagLabel.snp.trailing).offset(4)
            make.trailing.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
            make.size.equalTo(18)
        }
    }
    
    func configure(tag: String) {
        if tag.count > 10 {
            tagLabel.setText(tag.prefix(10) + "...")
        } else {
            tagLabel.setText(tag)
        }
    }
    
    private func setAction() {
        cancleButton.addAction(UIAction {
            [weak self] _ in
            guard let self = self else { return }
            self.delegate?.didTapCancleButton(cell: self)
        }, for: .touchUpInside)
    }
}
