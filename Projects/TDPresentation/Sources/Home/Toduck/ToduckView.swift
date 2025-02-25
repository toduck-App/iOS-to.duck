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
    
    let scheduleContainerView = UIView()
    let scheduleSegmentedControl = ScheduleSegmentedControl(items: ["현재 일정", "남은 일정"])
    let scheduleCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = LayoutConstants.collectionViewSpacing
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }().then {
        $0.backgroundColor = .clear
        $0.showsHorizontalScrollIndicator = false
        $0.decelerationRate = .fast
    }
    
    // MARK: - Common Methods
    override func addview() {
        addSubview(lottieView)
        addSubview(scheduleContainerView)
        scheduleContainerView.addSubview(scheduleSegmentedControl)
        scheduleContainerView.addSubview(scheduleCollectionView)
    }
    
    override func layout() {
        lottieView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        scheduleContainerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-24)
            make.height.equalTo(200)
        }
        
        scheduleSegmentedControl.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalToSuperview().offset(16)
            make.width.equalTo(LayoutConstants.segmentedControlWidth)
            make.height.equalTo(LayoutConstants.segmentedControlHeight)
        }
        
        scheduleCollectionView.snp.makeConstraints { make in
            make.top.equalTo(scheduleSegmentedControl.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().offset(-8)
        }
    }
    
    override func configure() {
        scheduleContainerView.backgroundColor = .white
        scheduleContainerView.layer.cornerRadius = 16
        setupscheduleSegmentedControl()
    }
    
    private func setupscheduleSegmentedControl() {
        scheduleSegmentedControl.selectedSegmentIndex = 0
        scheduleSegmentedControl.backgroundColor = .clear
        
        scheduleSegmentedControl.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        scheduleSegmentedControl.setBackgroundImage(UIImage(), for: .selected, barMetrics: .default)
        scheduleSegmentedControl.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
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
