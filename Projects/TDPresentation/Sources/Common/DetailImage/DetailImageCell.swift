import UIKit
import TDDesign

final class DetailImageCell: UICollectionViewCell {
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 12
        clipsToBounds = true
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(urlString: String, isHighlight: Bool) {
        imageView.kf.setImage(with: URL(string: urlString))
        imageView.alpha = isHighlight ? 1 : 0.8
        layer.borderColor = isHighlight ? TDColor.Primary.primary500.cgColor : UIColor.clear.cgColor
        layer.borderWidth = isHighlight ? 2 : 0
    }
}
