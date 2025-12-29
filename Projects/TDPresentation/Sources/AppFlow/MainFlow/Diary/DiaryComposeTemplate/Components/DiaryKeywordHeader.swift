import SnapKit
import TDDesign
import Then
import UIKit

// MARK: - Header View

final class DiaryKeywordHeader: UICollectionReusableView {
    
    private let titleLabel = TDLabel(
        toduckFont: .boldBody2,
        toduckColor: TDColor.Neutral.neutral600
    )
    
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupUI() {
        backgroundColor = TDColor.baseWhite
    }
    
    private func setupLayout() {
        addSubview(titleLabel)
        addSubview(imageView)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(4)
            make.centerY.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.size.equalTo(18)
        }
    }
    
    func configure(title: String, image: UIImage?) {
        titleLabel.setText(title)
        imageView.image = image
        imageView.isHidden = (image == nil)
    }
}
