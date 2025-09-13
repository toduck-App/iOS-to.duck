import UIKit

public protocol CoachMarkPresenterDelegate: AnyObject {
    func coachMarkDidFinish(_ presenter: CoachMarkPresenter, skipped: Bool)
    func coachMarkDidMove(_ presenter: CoachMarkPresenter, to index: Int)
}

public final class CoachMarkPresenter: NSObject, UIGestureRecognizerDelegate {
    // MARK: - Public

    public weak var delegate: CoachMarkPresenterDelegate?

    public var nextTitle: String = "다음"
    public var doneTitle: String = "완료"
    public var skipTitle: String = "건너뛰기"
    public var autoChangeNextToDoneAtLastStep: Bool = true
    public var allowBackgroundTapToAdvance: Bool = true

    // MARK: - Private UI

    private var accessoryView: UIView?
    private weak var containerView: UIView?
    private var overlay: SpotlightOverlayView?
    private var bubble = CoachBubbleView()
    private var steps: [CoachStep] = []
    private var index = 0

    private let sideMargin: CGFloat = 16
    private let spacing: CGFloat = 30

    // 상단/하단 컨트롤들
    private let topBar = UIView()
    private let backButton = UIButton(type: .system)
    private let skipButton = UIButton(type: .system)
    private let bottomBar = UIView()
    private let nextButton = TDBaseButton(
        title: "다음",
        backgroundColor: TDColor.Primary.primary500,
        foregroundColor: TDColor.baseWhite,
        font: TDFont.boldHeader5.font
    )

    // 배경 탭 제스처
    private var bgTapGR: UITapGestureRecognizer?

    public init(containerView: UIView) {
        self.containerView = containerView
        super.init()
    }

    // MARK: - Start

    public func start(steps: [CoachStep]) {
        guard let container = containerView, !steps.isEmpty else { return }
        self.steps = steps
        index = 0

        // Overlay
        let overlay = SpotlightOverlayView(frame: container.bounds)
        overlay.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(overlay)
        NSLayoutConstraint.activate([
            overlay.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            overlay.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            overlay.topAnchor.constraint(equalTo: container.topAnchor),
            overlay.bottomAnchor.constraint(equalTo: container.bottomAnchor),
        ])
        self.overlay = overlay

        // Bubble
        bubble.translatesAutoresizingMaskIntoConstraints = false
        overlay.addSubview(bubble)

        // Top bar
        buildTopBar(in: overlay)

        // Bottom bar
        buildBottomBar(in: overlay)

        // Background tap (다음)
        if allowBackgroundTapToAdvance {
            let tap = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped(_:)))
            tap.cancelsTouchesInView = false
            tap.delegate = self
            overlay.addGestureRecognizer(tap)
            bgTapGR = tap
        }

        showCurrentStep(animated: true)
        overlay.showAnimated()
        updateControlsForStep()
    }

    // MARK: - UI Builders

    private func buildTopBar(in overlay: UIView) {
        topBar.translatesAutoresizingMaskIntoConstraints = false
        overlay.addSubview(topBar)
        topBar.backgroundColor = .clear

        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .white
        backButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)

        skipButton.translatesAutoresizingMaskIntoConstraints = false
        skipButton.setTitle(skipTitle, for: .normal)
        skipButton.setTitleColor(.white, for: .normal)
        skipButton.titleLabel?.font = TDFont.boldHeader5.font
        skipButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        skipButton.addTarget(self, action: #selector(skipTapped), for: .touchUpInside)

        topBar.addSubview(backButton)
        topBar.addSubview(skipButton)

        NSLayoutConstraint.activate([
            topBar.leadingAnchor.constraint(equalTo: overlay.leadingAnchor),
            topBar.trailingAnchor.constraint(equalTo: overlay.trailingAnchor),
            topBar.topAnchor.constraint(equalTo: overlay.safeAreaLayoutGuide.topAnchor),
            topBar.heightAnchor.constraint(equalToConstant: 44),

            backButton.leadingAnchor.constraint(equalTo: overlay.leadingAnchor, constant: 8),
            backButton.centerYAnchor.constraint(equalTo: topBar.centerYAnchor),

            skipButton.trailingAnchor.constraint(equalTo: overlay.trailingAnchor, constant: -12),
            skipButton.centerYAnchor.constraint(equalTo: topBar.centerYAnchor),
        ])
    }

    private func buildBottomBar(in overlay: UIView) {
        bottomBar.translatesAutoresizingMaskIntoConstraints = false
        overlay.addSubview(bottomBar)
        bottomBar.backgroundColor = .clear

        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.setTitle(nextTitle, for: .normal)
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)

        bottomBar.addSubview(nextButton)

        NSLayoutConstraint.activate([
            bottomBar.leadingAnchor.constraint(equalTo: overlay.leadingAnchor),
            bottomBar.trailingAnchor.constraint(equalTo: overlay.trailingAnchor),
            bottomBar.bottomAnchor.constraint(equalTo: overlay.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            bottomBar.heightAnchor.constraint(greaterThanOrEqualToConstant: 56),

            nextButton.centerXAnchor.constraint(equalTo: bottomBar.centerXAnchor),
            nextButton.topAnchor.constraint(equalTo: bottomBar.topAnchor),
            nextButton.bottomAnchor.constraint(equalTo: bottomBar.bottomAnchor),
            nextButton.leadingAnchor.constraint(equalTo: bottomBar.leadingAnchor, constant: 16),
            nextButton.trailingAnchor.constraint(equalTo: bottomBar.trailingAnchor, constant: -16),
        ])
    }

    // 센터 이미지 등 부가 뷰
    private func updateAccessoryView(for step: CoachStep) {
        accessoryView?.removeFromSuperview()
        accessoryView = nil

        guard let overlay else { return }
        guard let image = step.centerImage else { return }

        let iv = UIImageView(image: image)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.isUserInteractionEnabled = false
        overlay.addSubview(iv)

        if overlay.subviews.contains(bubble) {
            overlay.insertSubview(iv, belowSubview: bubble)
        }

        let maxW = min(step.centerImageMaxWidth ?? 240, overlay.bounds.width - sideMargin * 2)
        let aspect = (image.size.width > 0) ? (image.size.height / image.size.width) : 1.0
        let yOffset = step.centerImageYOffset ?? 0

        NSLayoutConstraint.activate([
            iv.leadingAnchor.constraint(equalTo: overlay.leadingAnchor),
            iv.centerYAnchor.constraint(equalTo: overlay.centerYAnchor, constant: yOffset),
            iv.widthAnchor.constraint(lessThanOrEqualToConstant: maxW),
            iv.heightAnchor.constraint(equalTo: iv.widthAnchor, multiplier: aspect),
        ])

        accessoryView = iv
        bringOverlayToFrontSafely()
    }

    private func bringOverlayToFrontSafely() {
        guard let overlay, let superview = overlay.superview else { return }
        superview.bringSubviewToFront(overlay)
        overlay.layer.zPosition = 9999
    }

    // MARK: - Step 전환

    @objc private func backTapped() {
        guard index > 0 else { return }
        index -= 1
        showCurrentStep(animated: true, haptic: true)
        updateControlsForStep()
        delegate?.coachMarkDidMove(self, to: index)
    }

    @objc private func skipTapped() {
        finish(skipped: true)
    }

    @objc private func nextTapped() {
        if index >= steps.count - 1 {
            finish(skipped: false)
            return
        }
        index += 1
        showCurrentStep(animated: true, haptic: true)
        updateControlsForStep()
        delegate?.coachMarkDidMove(self, to: index)
    }

    private func finish(skipped: Bool) {
        overlay?.hideAnimated { [weak self] in
            guard let self else { return }
            delegate?.coachMarkDidFinish(self, skipped: skipped)
        }
    }

    private func updateControlsForStep() {
        let isFirst = (index == 0)
        backButton.isHidden = isFirst

        if autoChangeNextToDoneAtLastStep {
            let isLast = (index == steps.count - 1)
            nextButton.setTitle(isLast ? doneTitle : nextTitle, for: .normal)
        } else {
            nextButton.setTitle(nextTitle, for: .normal)
        }

        nextButton.accessibilityLabel = nextButton.title(for: .normal)
        nextButton.accessibilityHint = "코치마크 단계를 진행합니다."
        skipButton.accessibilityHint = "코치마크를 종료합니다."
        backButton.accessibilityHint = "이전 단계로 이동합니다."
    }

    // MARK: - 배경 탭 → 다음

    @objc private func backgroundTapped(_ gr: UITapGestureRecognizer) {
        guard gr.state == .ended else { return }
        let p = gr.location(in: overlay)

        if bubble.frame.contains(p) ||
            backButton.frame.insetBy(dx: -10, dy: -10).contains(gr.location(in: backButton.superview)) ||
            skipButton.frame.insetBy(dx: -10, dy: -10).contains(gr.location(in: skipButton.superview)) ||
            nextButton.frame.insetBy(dx: -10, dy: -10).contains(gr.location(in: nextButton.superview))
        { return }

        nextTapped()
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let v = touch.view
        if v === nextButton || v === skipButton || v === backButton || v?.isDescendant(of: bubble) == true {
            return false
        }
        return true
    }

    // 방향 선택 로직(자동)
    private func chooseDirection(for target: CGRect,
                                 in containerBounds: CGRect,
                                 preferred: CoachArrowDirection?) -> CoachArrowDirection
    {
        if let p = preferred { return p }
        let topSpace = target.minY
        let bottomSpace = containerBounds.height - target.maxY
        let leftSpace = target.minX
        let rightSpace = containerBounds.width - target.maxX

        let candidates: [(CoachArrowDirection, CGFloat)] = [
            (.up, topSpace), (.down, bottomSpace), (.left, leftSpace), (.right, rightSpace),
        ]
        return candidates.max(by: { $0.1 < $1.1 })?.0 ?? .down
    }

    // MARK: - 핵심: 고정 크기 버블 + 타겟을 향하는 말꼬리

    private func showCurrentStep(animated: Bool, haptic: Bool = false) {
        guard let overlay, index < steps.count else { return }
        let currentIndex = index
        let step = steps[currentIndex]

        overlay.blocksHoleTouches = true
        step.onEnter?()

        let bgTapAllowed = step.allowBackgroundTapToAdvance ?? allowBackgroundTapToAdvance
        bgTapGR?.isEnabled = bgTapAllowed

        bringOverlayToFrontSafely()

        DispatchQueue.main.async { [weak self] in
            guard
                let self,
                let overlay = self.overlay,
                currentIndex < steps.count,
                index == currentIndex,
                let container = containerView,
                let target = steps[currentIndex].targetProvider()
            else { return }

            bringOverlayToFrontSafely()
            updateAccessoryView(for: step)

            let targetRect = target.convert(target.bounds, to: container)
            overlay.setCutout(targetRect.insetBy(dx: -6, dy: -6),
                              cornerRadius: step.cornerRadius,
                              animated: animated)

            // 배치 방향(버블을 어디에 둘지)
            let placeDirection = chooseDirection(for: targetRect,
                                                 in: container.bounds,
                                                 preferred: step.preferredDirection)

            // 화살표는 타겟을 향해야 하므로 배치의 '반대' 방향
            func opposite(_ d: CoachArrowDirection) -> CoachArrowDirection {
                switch d {
                case .up: .down
                case .down: .up
                case .left: .right
                case .right: .left
                }
            }
            let arrowDirection = opposite(placeDirection)

            // 버블 텍스트 적용 (화살표 방향으로 넘김)
            bubble.configure(
                title: step.title,
                icon: step.icon,
                iconSize: step.iconSize,
                description: step.description,
                highlightTokens: step.highlightTokens,
                highlightColor: TDColor.Primary.primary500,
                direction: arrowDirection
            )

            // 기존 버블 제약 제거
            let toRemove = overlay.constraints.filter {
                ($0.firstItem as AnyObject) === self.bubble || ($0.secondItem as AnyObject) === self.bubble
            }
            overlay.removeConstraints(toRemove)

            // 고정 크기
            let widthC = bubble.widthAnchor.constraint(equalToConstant: CoachBubbleView.fixedSize.width)
            let heightC = bubble.heightAnchor.constraint(equalToConstant: CoachBubbleView.fixedSize.height)
            widthC.priority = .required
            heightC.priority = .required

            // 화면 안으로 centerX/centerY 클램프
            let overlayW = container.bounds.width
            let overlayH = container.bounds.height
            let bubbleW = CoachBubbleView.fixedSize.width
            let bubbleH = CoachBubbleView.fixedSize.height
            let minCenterX = sideMargin + bubbleW / 2
            let maxCenterX = overlayW - sideMargin - bubbleW / 2
            let minCenterY = sideMargin + bubbleH / 2
            let maxCenterY = overlayH - sideMargin - bubbleH / 2

            let clampedCenterX = min(max(targetRect.midX, minCenterX), maxCenterX)
            let clampedCenterY = min(max(targetRect.midY, minCenterY), maxCenterY)

            // 배치
            switch placeDirection {
            case .down: // 버블을 타겟 '아래'에 둠 → 화살표는 ↑
                NSLayoutConstraint.activate([
                    bubble.topAnchor.constraint(equalTo: overlay.topAnchor, constant: targetRect.maxY + spacing),
                    bubble.centerXAnchor.constraint(equalTo: overlay.leadingAnchor, constant: clampedCenterX),
                    widthC, heightC,
                ])
            case .up: // 버블을 타겟 '위'에 둠 → 화살표는 ↓
                NSLayoutConstraint.activate([
                    bubble.bottomAnchor.constraint(equalTo: overlay.topAnchor, constant: targetRect.minY - spacing),
                    bubble.centerXAnchor.constraint(equalTo: overlay.leadingAnchor, constant: clampedCenterX),
                    widthC, heightC,
                ])
            case .left: // 버블을 타겟 '왼쪽'에 둠 → 화살표는 →
                NSLayoutConstraint.activate([
                    bubble.trailingAnchor.constraint(equalTo: overlay.leadingAnchor, constant: targetRect.minX - spacing),
                    bubble.centerYAnchor.constraint(equalTo: overlay.topAnchor, constant: clampedCenterY),
                    widthC, heightC,
                ])
            case .right: // 버블을 타겟 '오른쪽'에 둠 → 화살표는 ←
                NSLayoutConstraint.activate([
                    bubble.leadingAnchor.constraint(equalTo: overlay.leadingAnchor, constant: targetRect.maxX + spacing),
                    bubble.centerYAnchor.constraint(equalTo: overlay.topAnchor, constant: clampedCenterY),
                    widthC, heightC,
                ])
            }

            overlay.layoutIfNeeded()

            // 말꼬리 앵커(타겟을 향하도록) - 화살표 방향 기준으로 축 선택
            let bubbleFrame = bubble.frame
            let anchorRatio: CGFloat
            switch arrowDirection {
            case .up, .down:
                let anchorX = min(max(targetRect.midX, bubbleFrame.minX + 10), bubbleFrame.maxX - 10)
                anchorRatio = (anchorX - bubbleFrame.minX) / bubbleFrame.width
            case .left, .right:
                let anchorY = min(max(targetRect.midY, bubbleFrame.minY + 10), bubbleFrame.maxY - 10)
                anchorRatio = (anchorY - bubbleFrame.minY) / bubbleFrame.height
            }
            bubble.setTail(direction: arrowDirection, anchorRatio: anchorRatio)

            if animated {
                bubble.alpha = 0
                bubble.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                    self.bubble.alpha = 1
                    self.bubble.transform = .identity
                })
            }

            if haptic {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            }
        }
    }
}
