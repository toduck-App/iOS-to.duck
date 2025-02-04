import UIKit
import TDDesign
import SnapKit
import Then
import Lottie

final class ToduckView: BaseView {
    
    // 바닥 배경: 화면 하단 60% 차지
    private let floorView = UIView().then {
        $0.backgroundColor = .brown
    }
    
    // 중앙에 위치하는 Lottie 애니메이션 뷰
    private let lottieView = LottieAnimationView(
        name: "toduckPower",
        bundle: Bundle(identifier: "to.duck.toduck.design")!
    ).then {
        $0.backgroundColor = .clear
        $0.contentMode = .scaleAspectFit
        $0.loopMode = .loop
        $0.play()
    }
    
    // 커스텀 세그먼트 컨트롤 (ScheduleSegmentedControl)
    let scheduleSegmentedControl = ScheduleSegmentedControl(items: ["현재 일정", "남은 일정"])
    
    // 가로 제스쳐를 통한 컬렉션뷰 (셀 간의 간격 10pt)
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
        // floorView: 부모 뷰의 하단 60% 차지
        floorView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.6)
        }
        
        // lottieView: 부모 뷰 중앙, 가로 80%
        lottieView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(60)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(lottieView.snp.width)
        }
        
        // scheduleSegmentedControl: floorView 바로 위, 왼쪽에 16pt 여백, 고정 사이즈
        scheduleSegmentedControl.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-160)
            make.leading.equalToSuperview().offset(16)
            make.width.equalTo(160)
            make.height.equalTo(40)
        }
        
        // scheduleCollectionView: 세그먼트 아래부터 floorView 위까지 채우도록 배치, 좌우 16pt inset
        scheduleCollectionView.snp.makeConstraints { make in
            make.top.equalTo(scheduleSegmentedControl.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-24)
        }
    }
    
    override func configure() {
        scheduleSegmentedControl.selectedSegmentIndex = 0
        scheduleSegmentedControl.backgroundColor = .clear
    }
}
