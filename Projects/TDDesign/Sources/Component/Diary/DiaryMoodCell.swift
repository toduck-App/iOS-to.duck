import UIKit
import SnapKit
import Then

final class DiaryMoodCell: UICollectionViewCell {
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
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
        contentView.addSubview(imageView)
        
        imageView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    func configure(image: UIImage) {
        imageView.image = image
    }
}
