import UIKit

public final class SpotlightOverlayView: UIControl {

    private let dimLayer = CAShapeLayer()
    private let ringLayer = CAShapeLayer()
    
    public var blocksHoleTouches: Bool = true
    private var cutoutRect: CGRect = .zero
    private var cutoutCornerRadius: CGFloat = 12

    public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        // blocksHoleTouches가 false면 전체 터치 허용
        guard blocksHoleTouches == false else { return true }
        
        // blocksHoleTouches가 true면 구멍 안 터치는 통과시킴
        let inHole = UIBezierPath(roundedRect: cutoutRect, cornerRadius: cutoutCornerRadius).contains(point)
        return !inHole
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        isOpaque = false
        accessibilityViewIsModal = true

        layer.addSublayer(dimLayer)
        layer.addSublayer(ringLayer)

        dimLayer.fillColor = TDColor.Neutral.neutral900.withAlphaComponent(0.8).cgColor
        dimLayer.fillRule = .evenOdd

        ringLayer.fillColor = UIColor.clear.cgColor
        ringLayer.strokeColor = UIColor.white.withAlphaComponent(0.9).cgColor
        ringLayer.lineWidth = 3
        ringLayer.shadowColor = UIColor.black.cgColor
        ringLayer.shadowOpacity = 0.4
        ringLayer.shadowRadius = 6
        ringLayer.shadowOffset = .zero

        ringLayer.lineCap = .round
        ringLayer.lineDashPattern = [5, 8]

        alpha = 0
    }

    public required init?(coder: NSCoder) { fatalError() }

    public func setCutout(_ rect: CGRect, cornerRadius: CGFloat = 12, animated: Bool = true) {
        cutoutRect = rect
        cutoutCornerRadius = cornerRadius
        updatePaths(animated: animated)
    }

    private func updatePaths(animated: Bool) {
        let bgPath = UIBezierPath(rect: bounds)
        let hole = UIBezierPath(roundedRect: cutoutRect, cornerRadius: cutoutCornerRadius)
        bgPath.append(hole)
        bgPath.usesEvenOddFillRule = true

        CATransaction.begin()
        CATransaction.setDisableActions(!animated)
        dimLayer.path = bgPath.cgPath

        ringLayer.path = UIBezierPath(
            roundedRect: cutoutRect.insetBy(dx: -3, dy: -3),
            cornerRadius: cutoutCornerRadius + 3
        ).cgPath
        CATransaction.commit()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        updatePaths(animated: false)
    }

    public func showAnimated() {
        alpha = 0
        UIView.animate(withDuration: 0.22) { self.alpha = 1 }
        let anim = CABasicAnimation(keyPath: "transform.scale")
        anim.fromValue = 0.98
        anim.toValue = 1
        anim.duration = 0.2
        anim.timingFunction = CAMediaTimingFunction(name: .easeOut)
        ringLayer.add(anim, forKey: "pulse")
    }

    public func hideAnimated(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.2, animations: { self.alpha = 0 }) { _ in
            completion?()
            self.removeFromSuperview()
        }
    }
}
