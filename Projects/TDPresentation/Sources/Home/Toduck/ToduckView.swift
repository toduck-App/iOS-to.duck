import UIKit
import TDDesign
import SnapKit
import Then
import Lottie

final class ToduckView: BaseView {
    private let floorView = UIView().then {
        $0.backgroundColor = #colorLiteral(red: 0.8511271477, green: 0.7997284532, blue: 0.7568077445, alpha: 1)
    }
    private let lottieView = LottieAnimationView(
        name: "toduckPower",
        bundle: Bundle(identifier: "to.duck.toduck.design")!
    ).then {
        $0.backgroundColor = .clear
        $0.contentMode = .scaleAspectFit
        $0.loopMode = .loop
        $0.play()
    }
    let scheduleSegmentedControl = ScheduleSegmentedControl(items: ["현재 일정", "남은 일정"])
    let scheduleCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10 // 셀 사이 간격
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }().then {
        $0.backgroundColor = .clear
        $0.showsHorizontalScrollIndicator = false
    }
    
    override func addview() {
        addSubview(floorView)
        addSubview(lottieView)
        addSubview(scheduleSegmentedControl)
        addSubview(scheduleCollectionView)
    }
    
    override func layout() {
        floorView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.6)
        }
        
        lottieView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(60)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(lottieView.snp.width)
        }
        
        scheduleSegmentedControl.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-160)
            make.leading.equalToSuperview().offset(36)
            make.width.equalTo(160)
            make.height.equalTo(40)
        }
        
        scheduleCollectionView.snp.makeConstraints { make in
            make.top.equalTo(scheduleSegmentedControl.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-24)
        }
    }
    
    override func configure() {
        scheduleSegmentedControl.selectedSegmentIndex = 0
        scheduleSegmentedControl.backgroundColor = .clear
    }
}
