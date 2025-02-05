import UIKit
import TDDesign
import SnapKit
import Then
import Lottie

final class ToduckView: BaseView {
    // MARK: - UI Components
    private let lottieView = LottieAnimationView(
        name: "toduckStudy",
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
        layout.minimumLineSpacing = LayoutConstants.collectionViewSpacing
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }().then {
        $0.backgroundColor = .clear
        $0.showsHorizontalScrollIndicator = false
    }
    
    // MARK: - Common Methods
    override func addview() {
        addSubview(lottieView)
        addSubview(scheduleSegmentedControl)
        addSubview(scheduleCollectionView)
    }
    
    override func layout() {
        lottieView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        scheduleSegmentedControl.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-LayoutConstants.segmentedControlBottomOffset)
            make.leading.equalToSuperview().offset(LayoutConstants.segmentedControlLeadingOffset)
            make.width.equalTo(LayoutConstants.segmentedControlWidth)
            make.height.equalTo(LayoutConstants.segmentedControlHeight)
        }
        
        scheduleCollectionView.snp.makeConstraints { make in
            make.top.equalTo(scheduleSegmentedControl.snp.bottom).offset(LayoutConstants.collectionViewTopOffset)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-LayoutConstants.collectionViewBottomOffset)
        }
    }
    
    override func configure() {
        scheduleSegmentedControl.selectedSegmentIndex = 0
        scheduleSegmentedControl.backgroundColor = .clear
    }
}

// MARK: - Constants
private extension ToduckView {
    enum LayoutConstants {
        static let segmentedControlBottomOffset: CGFloat = 180
        static let segmentedControlLeadingOffset: CGFloat = 36
        static let segmentedControlWidth: CGFloat = 160
        static let segmentedControlHeight: CGFloat = 40
        
        static let collectionViewTopOffset: CGFloat = 16
        static let collectionViewBottomOffset: CGFloat = 48
        static let collectionViewSpacing: CGFloat = 10
    }
}
