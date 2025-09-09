import UIKit

public final class CoachBubbleView: UIView {
    // MARK: - Fixed Size
    public static let fixedSize = CGSize(width: 320, height: 124)

    // MARK: - UI
    private let bubble = UIView()
    private let arrowLayer = CAShapeLayer()

    private let vStack = UIStackView()
    private let topRow = UIStackView()
    private let iconView = UIImageView()
    private let titleLabel = TDLabel(toduckFont: .boldHeader5, toduckColor: TDColor.Neutral.neutral800)
    private let descLabel  = TDLabel(toduckFont: .regularBody2, toduckColor: TDColor.Neutral.neutral700)

    // MARK: - Layout Const
    private let contentInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16) // ★ 16
    private let arrowSize = CGSize(width: 16, height: 10)
    private let cornerRadius: CGFloat = 16
    private let iconSize: CGFloat = 24
    private let rowSpacing: CGFloat = 16
    private let colSpacing: CGFloat = 8

    private var direction: CoachArrowDirection = .down
    private var tailAnchorRatio: CGFloat = 0.5

    // MARK: - Init
    override public init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .clear
        layer.masksToBounds = false

        bubble.backgroundColor = .white
        bubble.layer.cornerRadius = cornerRadius
        bubble.layer.shadowColor = UIColor.black.cgColor
        bubble.layer.shadowOpacity = 0.15
        bubble.layer.shadowRadius = 8
        bubble.layer.shadowOffset = .init(width: 0, height: 4)
        addSubview(bubble)

        // Stacks
        vStack.axis = .vertical
        vStack.spacing = rowSpacing
        topRow.axis = .horizontal
        topRow.alignment = .center
        topRow.spacing = colSpacing

        bubble.addSubview(vStack)
        vStack.addArrangedSubview(topRow)
        topRow.addArrangedSubview(iconView)
        topRow.addArrangedSubview(titleLabel)
        vStack.addArrangedSubview(descLabel)

        // Icon
        iconView.contentMode = .scaleAspectFit
        iconView.setContentHuggingPriority(.required, for: .horizontal)
        iconView.setContentCompressionResistancePriority(.required, for: .horizontal)
        iconView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: iconSize),
            iconView.heightAnchor.constraint(equalToConstant: iconSize),
        ])

        // Title
        titleLabel.numberOfLines = 1
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

        // Description
        descLabel.numberOfLines = 0
        descLabel.lineBreakMode = .byWordWrapping
        descLabel.setLineHeightMultiple(1.5)
        descLabel.setContentHuggingPriority(.required, for: .vertical)
        descLabel.setContentCompressionResistancePriority(.required, for: .vertical)

        translatesAutoresizingMaskIntoConstraints = false
        bubble.translatesAutoresizingMaskIntoConstraints = false
        vStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: CoachBubbleView.fixedSize.width),
            heightAnchor.constraint(equalToConstant: CoachBubbleView.fixedSize.height),
        ])

        NSLayoutConstraint.activate([
            bubble.leadingAnchor.constraint(equalTo: leadingAnchor),
            bubble.trailingAnchor.constraint(equalTo: trailingAnchor),
            bubble.topAnchor.constraint(equalTo: topAnchor),
            bubble.bottomAnchor.constraint(equalTo: bottomAnchor),

            vStack.leadingAnchor.constraint(equalTo: bubble.leadingAnchor, constant: contentInsets.left),
            vStack.trailingAnchor.constraint(equalTo: bubble.trailingAnchor, constant: -contentInsets.right),
            vStack.topAnchor.constraint(equalTo: bubble.topAnchor, constant: contentInsets.top),
            vStack.bottomAnchor.constraint(equalTo: bubble.bottomAnchor, constant: -contentInsets.bottom),
        ])

        // Arrow
        layer.addSublayer(arrowLayer)
        arrowLayer.fillColor = UIColor.white.cgColor
        arrowLayer.lineJoin = .round

        // A11y
        isAccessibilityElement = true
        accessibilityTraits = .staticText
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) { fatalError() }

    override public var intrinsicContentSize: CGSize {
        Self.fixedSize
    }

    // MARK: - Public API
    public func configure(
        title: String?,
        image: UIImage?,
        description: String,
        highlightTokens: [String],
        highlightColor: UIColor,
        direction: CoachArrowDirection
    ) {
        self.direction = direction
        iconView.isHidden = (image == nil)
        iconView.image = image

        titleLabel.isHidden = (title?.isEmpty ?? true)
        titleLabel.setText(title ?? "")

        let attr = highlighted(
            fullText: description,
            tokens: highlightTokens,
            baseFont: TDFont.regularBody2.font,
            baseColor: descLabel.textColor,
            highlightColor: highlightColor
        )
        descLabel.attributedText = attr

        descLabel.setLineHeightMultiple(1.5)

        var axText = ""
        if let t = title, !t.isEmpty { axText += t + "\n" }
        axText += description
        accessibilityLabel = axText
        accessibilityHint = "화면 아무 곳이나 탭하면 다음 안내로 이동합니다."

        setNeedsLayout()
        layoutIfNeeded()
    }


    public func setTail(direction: CoachArrowDirection, anchorRatio: CGFloat) {
        self.direction = direction
        tailAnchorRatio = max(0.0, min(1.0, anchorRatio))
        setNeedsLayout()
    }

    // MARK: - Highlight helper
    private func highlighted(
        fullText: String,
        tokens: [String],
        baseFont: UIFont,
        baseColor: UIColor,
        highlightColor: UIColor
    ) -> NSAttributedString {
        let attr = NSMutableAttributedString(
            string: fullText,
            attributes: [
                .font: baseFont,
                .foregroundColor: baseColor
            ]
        )
        for token in tokens where !token.isEmpty {
            var searchRange = NSRange(location: 0, length: attr.length)
            let ns = attr.string as NSString
            while true {
                let r = ns.range(of: token, options: [], range: searchRange)
                if r.location == NSNotFound { break }
                attr.addAttributes(
                    [
                        .font: TDFont.boldBody2.font,
                        .foregroundColor: highlightColor
                    ],
                    range: r
                )
                let nextLoc = r.location + r.length
                if nextLoc >= attr.length { break }
                searchRange = NSRange(location: nextLoc, length: attr.length - nextLoc)
            }
        }
        return attr
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
