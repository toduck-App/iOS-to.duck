import UIKit
import SnapKit
import Then

public final class CoachBubbleView: UIView {
    // MARK: - Fixed Size
    public static let fixedSize = CGSize(width: 320, height: 114)

    // MARK: - UI
    private let bubble = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 16
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.15
        $0.layer.shadowRadius = 8
        $0.layer.shadowOffset = .init(width: 0, height: 4)
    }
    private let arrowLayer = CAShapeLayer().then {
        $0.fillColor = UIColor.white.cgColor
        $0.lineJoin = .round
    }

    private let vStack = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 16
    }
    private let topRow = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 8
    }
    private let iconView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.setContentHuggingPriority(.required, for: .horizontal)
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    private let titleLabel = TDLabel(toduckFont: .boldHeader5, toduckColor: TDColor.Neutral.neutral800).then {
        $0.numberOfLines = 1
        $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    private let descLabel  = TDLabel(toduckFont: .regularBody2, toduckColor: TDColor.Neutral.neutral700).then {
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
        $0.setLineHeightMultiple(1.5)
        $0.setContentHuggingPriority(.required, for: .vertical)
        $0.setContentCompressionResistancePriority(.required, for: .vertical)
    }

    // MARK: - Layout Const
    private let contentInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 28)
    private let arrowSize = CGSize(width: 16, height: 10)
    private let cornerRadius: CGFloat = 16
    private let iconSize: CGFloat = 24

    private var direction: CoachArrowDirection = .down
    private var tailAnchorRatio: CGFloat = 0.5

    // MARK: - Init
    override public init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .clear
        layer.masksToBounds = false

        addSubview(bubble)
        bubble.addSubview(vStack)
        vStack.addArrangedSubview(topRow)
        topRow.addArrangedSubview(iconView)
        topRow.addArrangedSubview(titleLabel)
        vStack.addArrangedSubview(descLabel)

        bubble.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        vStack.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(contentInsets)
        }

        iconView.snp.makeConstraints {
            $0.width.height.equalTo(iconSize)
        }

        layer.addSublayer(arrowLayer)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) { fatalError() }

    override public var intrinsicContentSize: CGSize {
        Self.fixedSize
    }

    // MARK: - Public API
    public func configure(
        title: String,
        icon: UIImage?,
        iconSize: CGSize,
        description: String,
        highlightTokens: [String],
        highlightColor: UIColor,
        direction: CoachArrowDirection
    ) {
        self.direction = direction

        iconView.isHidden = (icon == nil)
        iconView.image = icon?.withRenderingMode(.alwaysOriginal).withTintColor(TDColor.Neutral.neutral800)
        iconView.snp.updateConstraints {
            $0.width.height.equalTo(icon == nil ? 0 : iconSize)
        }

        titleLabel.setText(title)

        // 본문 + 하이라이트 (라인헤이트 1.5 고정)
        descLabel.setText(description)
        descLabel.setLineHeightMultiple(1.5)
        if !highlightTokens.isEmpty {
            // 필요 시 [.wholeWord] / [.regex] 변경
            descLabel.highlight(tokens: highlightTokens,
                                color: highlightColor,
                                font: TDFont.boldBody2,
                                options: [.caseInsensitive])
        }

        setNeedsLayout()
        layoutIfNeeded()
    }

    public func setTail(direction: CoachArrowDirection, anchorRatio: CGFloat) {
        self.direction = direction
        tailAnchorRatio = max(0.0, min(1.0, anchorRatio))
        setNeedsLayout()
    }

    // MARK: - Layout & Arrow
    override public func layoutSubviews() {
        super.layoutSubviews()
        drawArrow()
    }

    private func drawArrow() {
        let path = UIBezierPath()
        let w = arrowSize.width
        let h = arrowSize.height

        let safeInset: CGFloat = max(8, w/2 + 4)
        let joinOverlap: CGFloat = 0.5

        var layerFrame = bounds
        var baseX: CGFloat = 0
        var baseY: CGFloat = 0
        var tipX: CGFloat = 0
        var tipY: CGFloat = 0

        switch direction {
        case .up:
            layerFrame = CGRect(x: 0, y: -h, width: bounds.width, height: bounds.height + h)
            let x = clamp(bounds.width * tailAnchorRatio, safeInset, bounds.width - safeInset)
            baseX = x
            baseY = h + joinOverlap
            tipX = x
            tipY = 0

            arrowLayer.frame = layerFrame
            path.move(to: CGPoint(x: baseX - w/2, y: baseY))
            path.addLine(to: CGPoint(x: tipX, y: tipY))
            path.addLine(to: CGPoint(x: baseX + w/2, y: baseY))

        case .down:
            layerFrame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height + h)
            let x = clamp(bounds.width * tailAnchorRatio, safeInset, bounds.width - safeInset)
            baseX = x
            baseY = bounds.height - joinOverlap
            tipX = x
            tipY = bounds.height + h

            arrowLayer.frame = layerFrame
            path.move(to: CGPoint(x: baseX - w/2, y: baseY))
            path.addLine(to: CGPoint(x: tipX, y: tipY))
            path.addLine(to: CGPoint(x: baseX + w/2, y: baseY))

        case .left:
            layerFrame = CGRect(x: -h, y: 0, width: bounds.width + h, height: bounds.height)
            let y = clamp(bounds.height * tailAnchorRatio, safeInset, bounds.height - safeInset)
            baseX = h + joinOverlap
            baseY = y
            tipX = 0
            tipY = y

            arrowLayer.frame = layerFrame
            path.move(to: CGPoint(x: baseX, y: baseY - w/2))
            path.addLine(to: CGPoint(x: tipX, y: tipY))
            path.addLine(to: CGPoint(x: baseX, y: baseY + w/2))

        case .right:
            layerFrame = CGRect(x: 0, y: 0, width: bounds.width + h, height: bounds.height)
            let y = clamp(bounds.height * tailAnchorRatio, safeInset, bounds.height - safeInset)
            baseX = bounds.width - joinOverlap
            baseY = y
            tipX = bounds.width + h
            tipY = y

            arrowLayer.frame = layerFrame
            path.move(to: CGPoint(x: baseX, y: baseY - w/2))
            path.addLine(to: CGPoint(x: tipX, y: tipY))
            path.addLine(to: CGPoint(x: baseX, y: baseY + w/2))
        }

        path.close()
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        arrowLayer.path = path.cgPath
        CATransaction.commit()
    }

    private func clamp(_ v: CGFloat, _ a: CGFloat, _ b: CGFloat) -> CGFloat {
        min(max(v, a), b)
    }
}
