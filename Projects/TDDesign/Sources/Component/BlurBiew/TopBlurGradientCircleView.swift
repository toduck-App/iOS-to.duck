import UIKit

public final class TopBlurGradientCircleView: UIView {
    
    private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    private let maskGradientLayer = CAGradientLayer()
    private let color: UIColor
    
    public init(color: UIColor) {
        self.color = color
        super.init(frame: .zero)
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubview(blurView)
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        blurView.backgroundColor = color.withAlphaComponent(0.5)
        maskGradientLayer.type = .radial
        maskGradientLayer.colors = [
            color.withAlphaComponent(0.5).cgColor,
            color.withAlphaComponent(0.0).cgColor
        ]
        maskGradientLayer.locations = [0.0, 1.0]
        blurView.layer.mask = maskGradientLayer
        clipsToBounds = true
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        blurView.frame = bounds
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        maskGradientLayer.frame = bounds
        maskGradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        maskGradientLayer.endPoint   = CGPoint(x: 1.0, y: 1.0)
        CATransaction.commit()
    }
}
