import UIKit
import SnapKit
import TDDesign

final class SplashViewController: BaseViewController<BaseView> {
    private let logoImageView = UIImageView(image: TDImage.toduckPrimaryLogo)
    
    override func addView() {
        view.addSubview(logoImageView)
    }
    
    override func layout() {
        logoImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    override func configure() {
        view.backgroundColor = TDColor.Primary.primary50
    }
}

