import UIKit
import TDCore
import TDDesign
import SnapKit
import Then
import Lottie

protocol ToduckViewDelegate: AnyObject {
    func didTapNoScheduleContainerView()
}

final class ToduckView: BaseView {
    // MARK: - UI Components
    let lottiePageScrollView = LottiePageScrollView()
    let lottieTouchAreaView = UIView()
    
    let scheduleContainerView = UIView()
    let scheduleSegmentedControl = ScheduleSegmentedControl(items: ["지금 할 일", "남은 투두"])
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
    
    let noScheduleContainerView = UIView()
    let noScheduleImageView = UIImageView(image: TDImage.noEvent)
    let noScheduleStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.spacing = 6
    }
    let noScheduleLabel = TDLabel(
        labelText: "등록된 투두가 없어요..",
        toduckFont: .boldBody1,
        toduckColor: TDColor.Neutral.neutral600
    )
    let noScheduleSubLabel = TDLabel(
        labelText: "투두를 추가해 볼까요?",
        toduckFont: .mediumBody2,
        toduckColor: TDColor.Neutral.neutral500
    )
    
    weak var delegate: ToduckViewDelegate?
    
    // MARK: - Common Methods
    override func addview() {
        addSubview(lottiePageScrollView)
        addSubview(lottieTouchAreaView)
        addSubview(scheduleContainerView)
        scheduleContainerView.addSubview(scheduleSegmentedControl)
        scheduleContainerView.addSubview(scheduleCollectionView)
        scheduleContainerView.addSubview(noScheduleContainerView)
        
        noScheduleContainerView.addSubview(noScheduleImageView)
        noScheduleContainerView.addSubview(noScheduleStackView)
        
        noScheduleStackView.addArrangedSubview(noScheduleLabel)
        noScheduleStackView.addArrangedSubview(noScheduleSubLabel)
    }
    
    override func layout() {
        lottiePageScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        lottieTouchAreaView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(36)
            make.bottom.equalTo(scheduleContainerView.snp.top).offset(-36)
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
        
        noScheduleContainerView.snp.makeConstraints { make in
            make.top.equalTo(scheduleSegmentedControl.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(LayoutConstants.collectionViewHorizontalInset)
            make.bottom.equalToSuperview()
        }
        noScheduleImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.centerY.equalToSuperview().offset(-12)
            make.size.equalTo(96)
        }
        noScheduleStackView.snp.makeConstraints { make in
            make.leading.equalTo(noScheduleImageView.snp.trailing).offset(32)
            make.centerY.equalToSuperview().offset(-12)
        }
    }
    
    override func configure() {
        backgroundColor = TDColor.Neutral.neutral50
        scheduleContainerView.backgroundColor = .white
        scheduleContainerView.layer.cornerRadius = LayoutConstants.containerCornerRadius
        setupScheduleSegmentedControl()
        setupEmptyStateTapAction()
    }
    
    private func setupScheduleSegmentedControl() {
        scheduleSegmentedControl.selectedSegmentIndex = 0
        scheduleSegmentedControl.backgroundColor = .clear
        
        scheduleSegmentedControl.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        scheduleSegmentedControl.setBackgroundImage(UIImage(), for: .selected, barMetrics: .default)
        scheduleSegmentedControl.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
    }
    
    private func setupEmptyStateTapAction() {
        let tapOnLottie = UITapGestureRecognizer(target: self, action: #selector(handleEmptyStateTap))
        let tapOnContainer = UITapGestureRecognizer(target: self, action: #selector(handleEmptyStateTap))
        
        lottieTouchAreaView.addGestureRecognizer(tapOnLottie)
        noScheduleContainerView.addGestureRecognizer(tapOnContainer)
    }
    
    @objc
    private func handleEmptyStateTap() {
        delegate?.didTapNoScheduleContainerView()
    }
}

// MARK: - Constants
private extension ToduckView {
    enum LayoutConstants {
        static let containerHorizontalInset: CGFloat = 16
        static let containerBottomOffset: CGFloat = 24
        static let containerHeight: CGFloat = 200
        static let containerCornerRadius: CGFloat = 16
        
        static let segmentedControlTopOffset: CGFloat = 20
        static let segmentedControlLeadingOffset: CGFloat = 16
        static let segmentedControlWidth: CGFloat = 183
        static let segmentedControlHeight: CGFloat = 20
        
        static let collectionViewHorizontalInset: CGFloat = 8
        static let collectionViewBottomOffset: CGFloat = 8
        static let collectionViewSpacing: CGFloat = 10
    }
}
