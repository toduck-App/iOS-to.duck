import UIKit
import SnapKit
import Then

final class TDCategoryCell: UICollectionViewCell {
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    private let circleView = UIView().then {
        $0.layer.cornerRadius = 25
        $0.layer.masksToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.addSubview(circleView)
        circleView.addSubview(imageView)
        
        circleView.snp.makeConstraints { $0.edges.equalToSuperview() }
        imageView.snp.makeConstraints { $0.edges.equalToSuperview().inset(12) }
    }
    
    func configure(image: UIImage, backgroundColor: UIColor) {
        circleView.backgroundColor = backgroundColor
        imageView.image = image
    }
}
