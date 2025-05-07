import SnapKit
import TDDesign
import Then
import UIKit

final class CoachView: BaseView {
    let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.isUserInteractionEnabled = true
    }
    
    let closeButton = UIButton().then {
        $0.setImage(TDImage.X.x2Medium, for: .normal)
        $0.accessibilityLabel = "닫기"
    }
    
    override func addview() {
        super.addview()
        addSubview(imageView)
        addSubview(closeButton)
    }
    
    override func layout() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(44)
            make.width.height.equalTo(24)
        }
    }
    
    func configure(image: UIImage) {
        imageView.image = image
    }
}
