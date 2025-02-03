import UIKit
import TDDesign
import SnapKit
import Then
import Lottie

final class ToduckView: BaseView {
    private let floorView = UIView().then {
        $0.backgroundColor = .brown
    }
    private let lottieView = LottieAnimationView(
        name: "toduckPower",
        bundle: Bundle(identifier: "to.duck.toduck.design")!
    ).then {
        $0.contentMode = .scaleAspectFit
        $0.loopMode = .loop
        $0.play()
    }
    
    override func addview() {
        addSubview(floorView)
        addSubview(lottieView)
    }
    
    override func configure() {
        floorView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.6)
        }
        lottieView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
        }
    }
}
