import UIKit
import TDCore
import TDDesign
import SnapKit
import Then
import Lottie

final class ToduckView: BaseView {
    // MARK: - UI Components
    let lottieView = LottieAnimationView(
        name: "toduckFood",
        bundle: Bundle(identifier: Constant.toduckDesignBundle)!
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
            make.leading.trailing.equalToSuperview().inset(LayoutConstants.containerHorizontalInset)
            make.bottom.equalToSuperview().offset(-LayoutConstants.containerBottomOffset)
            make.height.equalTo(LayoutConstants.containerHeight)
        }
        
        scheduleSegmentedControl.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(LayoutConstants.segmentedControlTopOffset)
            make.leading.equalToSuperview().offset(LayoutConstants.segmentedControlLeadingOffset)
            make.width.equalTo(LayoutConstants.segmentedControlWidth)
            make.height.equalTo(LayoutConstants.segmentedControlHeight)
        }
        
        scheduleCollectionView.snp.makeConstraints { make in
            make.top.equalTo(scheduleSegmentedControl.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(LayoutConstants.collectionViewHorizontalInset)
            make.bottom.equalToSuperview().offset(-LayoutConstants.collectionViewBottomOffset)
        }
    }
    
    override func configure() {
        backgroundColor = TDColor.Neutral.neutral50
        scheduleContainerView.backgroundColor = .white
        scheduleContainerView.layer.cornerRadius = LayoutConstants.containerCornerRadius
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
        static let containerHorizontalInset: CGFloat = 16
        static let containerBottomOffset: CGFloat = 24
        static let containerHeight: CGFloat = 200
        static let containerCornerRadius: CGFloat = 16
        
        static let segmentedControlTopOffset: CGFloat = 12
        static let segmentedControlLeadingOffset: CGFloat = 16
        static let segmentedControlWidth: CGFloat = 160
        static let segmentedControlHeight: CGFloat = 40
        
        static let collectionViewHorizontalInset: CGFloat = 8
        static let collectionViewBottomOffset: CGFloat = 8
        static let collectionViewSpacing: CGFloat = 10
    }
}
