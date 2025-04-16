import UIKit
import TDDesign

protocol FloatingActionMenuViewDelegate: AnyObject {
    func didTapScheduleButton()
    func didTapRoutineButton()
}

final class FloatingActionMenuView: BaseView {
    // MARK: UI Components
    private let scheduleContainerView = UIView()
    private let scheduleImageView = UIImageView()
    private let scheduleLabel = TDLabel(
        labelText: "일정 추가",
        toduckFont: .boldBody2,
        toduckColor: TDColor.Neutral.neutral800
    )
    
    private let routineContainerView = UIView()
    private let routineImageView = UIImageView()
    private let routineLabel = TDLabel(
        labelText: "루틴 추가",
        toduckFont: .boldBody2,
        toduckColor: TDColor.Neutral.neutral800
    )
    
    // MARK: Properties
    weak var delegate: FloatingActionMenuViewDelegate?
    
    // MARK: Common Methods
    override func addview() {
        addSubview(scheduleContainerView)
        addSubview(routineContainerView)
        
        scheduleContainerView.addSubview(scheduleImageView)
        scheduleContainerView.addSubview(scheduleLabel)
        
        routineContainerView.addSubview(routineImageView)
        routineContainerView.addSubview(routineLabel)
    }
    
    override func layout() {
        scheduleContainerView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(4)
            $0.leading.trailing.equalToSuperview().inset(4)
            $0.height.equalTo(40)
        }
        scheduleImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(12)
        }
        scheduleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(scheduleImageView.snp.trailing).offset(16)
        }
        
        routineContainerView.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-4)
            $0.leading.trailing.equalToSuperview().inset(4)
            $0.height.equalTo(40)
        }
        routineImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(12)
        }
        routineLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(routineImageView.snp.trailing).offset(16)
        }
    }
    
    override func configure() {
        backgroundColor = TDColor.baseWhite
        layer.cornerRadius = 12
        scheduleContainerView.layer.cornerRadius = 8
        routineContainerView.layer.cornerRadius = 8
        scheduleImageView.image = TDImage.checkNeutral.withRenderingMode(.alwaysTemplate)
        scheduleImageView.tintColor = TDColor.Neutral.neutral400
        routineImageView.image = TDImage.cycle.withRenderingMode(.alwaysTemplate)
        routineImageView.tintColor = TDColor.Neutral.neutral400
        setupGestureRecognizers()
        
    }
    
    private func setupGestureRecognizers() {
        let schedulePress = UILongPressGestureRecognizer(target: self, action: #selector(handleSchedulePress(_:)))
        schedulePress.minimumPressDuration = 0
        scheduleContainerView.addGestureRecognizer(schedulePress)
        
        let routinePress = UILongPressGestureRecognizer(target: self, action: #selector(handleRoutinePress(_:)))
        routinePress.minimumPressDuration = 0
        routineContainerView.addGestureRecognizer(routinePress)
    }
    
    @objc
    private func handleSchedulePress(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            scheduleContainerView.backgroundColor = TDColor.Primary.primary50
            scheduleImageView.tintColor = TDColor.Primary.primary400
            scheduleLabel.textColor = TDColor.Primary.primary500
        case .ended:
            scheduleContainerView.backgroundColor = .clear
            scheduleImageView.tintColor = TDColor.Neutral.neutral400
            scheduleLabel.textColor = TDColor.Neutral.neutral800
            delegate?.didTapScheduleButton()
        case .cancelled, .failed:
            scheduleContainerView.backgroundColor = .clear
        default:
            break
        }
    }

    @objc
    private func handleRoutinePress(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            routineContainerView.backgroundColor = TDColor.Primary.primary50
            routineImageView.tintColor = TDColor.Primary.primary400
            routineLabel.textColor = TDColor.Primary.primary500
        case .ended:
            routineContainerView.backgroundColor = .clear
            routineImageView.tintColor = TDColor.Neutral.neutral400
            routineLabel.textColor = TDColor.Neutral.neutral800
            delegate?.didTapRoutineButton()
        case .cancelled, .failed:
            routineContainerView.backgroundColor = .clear
        default:
            break
        }
    }
}
