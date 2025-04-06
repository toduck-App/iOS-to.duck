import TDDesign
import TDCore
import UIKit

final class SimpleTimerView: BaseTimerView {
    // MARK: - Properties
    private let animationDuration: TimeInterval = 1

    // MARK: - View

    private let progressLayer = CAShapeLayer().then {
        $0.strokeColor = TDColor.Primary.primary500.cgColor
        $0.fillColor = UIColor.clear.cgColor
        $0.lineWidth = 20
        $0.lineCap = .round
        $0.strokeEnd = 1
    }

    private let trackLayer = CAShapeLayer().then {
        $0.strokeColor = TDColor.Primary.primary100.cgColor
        $0.fillColor = UIColor.clear.cgColor
        $0.lineWidth = 20
    }

    let tomatoView = UIImageView().then {
        $0.image = TDImage.Tomato.timer
        $0.contentMode = .scaleAspectFit
    }

    let circleView = UIView().then {
        $0.backgroundColor = .clear
    }

    // MARK: - Override Methods

    override var progress: CGFloat {
        didSet {
            guard isRunning else { return }
            updateProgress()
            updateTomatoRotation()
        }
    }

    override func layout() {
        circleView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(LayoutConstant.circleViewEdgeInset)
        }

        tomatoView.snp.makeConstraints { make in
            make.size.equalTo(LayoutConstant.tomatoSize)
            make.center.equalToSuperview()
        }
    }

    override func addview() {
        circleView.layer.addSublayer(trackLayer)
        circleView.layer.addSublayer(progressLayer)

        addSubview(circleView)
        addSubview(tomatoView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let circleBounds = circleView.bounds

        let center = CGPoint(x: circleBounds.midX, y: circleBounds .midY)
        let radius = min(circleBounds.width, circleBounds.height) / 2 - progressLayer.lineWidth / 2
        let circularPath = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: -CGFloat.pi / 2,
            endAngle: 3 * CGFloat.pi / 2,
            clockwise: true
        )
        progressLayer.path = circularPath.cgPath
        trackLayer.path = circularPath.cgPath
        
        updateTomatoRotation()
    }
}

// MAKR: - Private Methods

private extension SimpleTimerView {
    func updateProgress() {
        CATransaction.begin()
        CATransaction.setDisableActions(false)
        CATransaction.setAnimationDuration(animationDuration)
        progressLayer.strokeEnd = 1 - progress
        CATransaction.commit()
    }

    func updateTomatoRotation() {
        layoutIfNeeded()
        guard bounds.width > 0, bounds.height > 0 else { return }
        
        let clampedProgress = min(max(progress, 0), 1)
        let rotationAngle = clampedProgress * 2 * -CGFloat.pi

        UIView.animate(withDuration: animationDuration) {
            self.tomatoView.transform = CGAffineTransform(rotationAngle: rotationAngle)
        }
    }
}

// MARK: - LayoutConstant

private extension SimpleTimerView {
    enum LayoutConstant {
        static let circleViewEdgeInset = 10
        static let tomatoSize: CGFloat = 54
    }
}
