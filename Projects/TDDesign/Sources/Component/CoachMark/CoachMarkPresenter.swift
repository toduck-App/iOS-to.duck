import SnapKit
import Then
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
    private let bubble = CoachBubbleView()
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
        if overlay != nil {
            finish(skipped: true)
        }
        self.steps = steps
        index = 0

        // Overlay
        let overlay = SpotlightOverlayView(frame: .zero).then {
            $0.backgroundColor = .clear
        }
        container.addSubview(overlay)
        overlay.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.overlay = overlay

        // Bubble
        overlay.addSubview(bubble)

        // Top bar
        buildTopBar(in: overlay)

        // Bottom bar
        buildBottomBar(in: overlay)

        // Background tap (다음)
        if allowBackgroundTapToAdvance {
            let tap = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped(_:))).then {
                $0.cancelsTouchesInView = false
                $0.delegate = self
            }
            overlay.addGestureRecognizer(tap)
            bgTapGR = tap
        }

        showCurrentStep(animated: true)
        overlay.showAnimated()
        updateControlsForStep()
    }

    // MARK: - UI Builders

    private func buildTopBar(in overlay: UIView) {
        overlay.addSubview(topBar)
        topBar.do {
            $0.backgroundColor = .clear
            $0.isUserInteractionEnabled = true
        }
        topBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(overlay.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(44)
        }

        backButton.do {
            $0.setImage(UIImage(systemName: "chevron.left"), for: .normal)
            $0.tintColor = .white
            $0.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
            $0.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        }
        skipButton.do {
            $0.setTitle(skipTitle, for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = TDFont.boldHeader5.font
            $0.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
            $0.addTarget(self, action: #selector(skipTapped), for: .touchUpInside)
        }

        topBar.addSubview(backButton)
        topBar.addSubview(skipButton)

        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
        }
        skipButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
        }
    }

    private func buildBottomBar(in overlay: UIView) {
        overlay.addSubview(bottomBar)
        bottomBar.do {
            $0.backgroundColor = .clear
            $0.isUserInteractionEnabled = true
        }
        bottomBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(overlay.safeAreaLayoutGuide.snp.bottom).inset(8)
            make.height.greaterThanOrEqualTo(56)
        }

        bottomBar.addSubview(nextButton)
        nextButton.do {
            $0.setTitle(nextTitle, for: .normal)
            $0.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        }
        nextButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
        }
    }

    private func updateAccessoryView(for step: CoachStep) {
        accessoryView?.removeFromSuperview()
        accessoryView = nil

        guard let overlay, let image = step.centerImage else { return }

        let iv = UIImageView(image: image).then {
            $0.contentMode = .scaleAspectFit
            $0.isUserInteractionEnabled = false
        }

        if overlay.subviews.contains(bubble) {
            overlay.insertSubview(iv, belowSubview: bubble)
        } else {
            overlay.addSubview(iv)
        }

        let maxW = min(step.centerImageMaxWidth ?? 240, overlay.bounds.width - sideMargin * 2)
        let aspect = (image.size.width > 0) ? (image.size.height / image.size.width) : 1.0
        let yOffset = step.centerImageYOffset ?? 0

        iv.snp.makeConstraints { make in
            make.leading.equalToSuperview() // 원래 코드와 동일하게 leading 기준
            make.centerY.equalToSuperview().offset(yOffset)
            make.width.lessThanOrEqualTo(maxW)
            make.height.equalTo(iv.snp.width).multipliedBy(aspect)
        }

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
            if let tap = bgTapGR, let overlay {
                overlay.removeGestureRecognizer(tap)
            }
            bgTapGR = nil
            bubble.removeFromSuperview()
            accessoryView?.removeFromSuperview()
            accessoryView = nil
            overlay = nil
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
        {
            return
        }

        nextTapped()
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let v = touch.view
        if v === nextButton || v === skipButton || v === backButton || v?.isDescendant(of: bubble) == true {
            return false
        }
        return true
    }

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

            // 버블 텍스트 적용
            bubble.configure(
                title: step.title,
                icon: step.icon,
                iconSize: step.iconSize,
                description: step.description,
                highlightTokens: step.highlightTokens,
                highlightColor: TDColor.Primary.primary500,
                direction: arrowDirection
            )

            // 고정 크기 상수
            let bubbleW = CoachBubbleView.fixedSize.width
            let bubbleH = CoachBubbleView.fixedSize.height

            // 화면 안으로 centerX/centerY 클램프
            let overlayW = container.bounds.width
            let overlayH = container.bounds.height
            let minCenterX = sideMargin + bubbleW / 2
            let maxCenterX = overlayW - sideMargin - bubbleW / 2
            let minCenterY = sideMargin + bubbleH / 2
            let maxCenterY = overlayH - sideMargin - bubbleH / 2

            let clampedCenterX = min(max(targetRect.midX, minCenterX), maxCenterX)
            let clampedCenterY = min(max(targetRect.midY, minCenterY), maxCenterY)

            bubble.snp.remakeConstraints { make in
                make.width.equalTo(bubbleW)
                make.height.equalTo(bubbleH)

                switch placeDirection {
                case .down:
                    make.top.equalToSuperview().inset(targetRect.maxY + self.spacing)
                    make.centerX.equalTo(overlay.snp.leading).offset(clampedCenterX)
                case .up:
                    make.bottom.equalTo(overlay.snp.top).offset(targetRect.minY - self.spacing)
                    make.centerX.equalTo(overlay.snp.leading).offset(clampedCenterX)
                case .left:
                    make.trailing.equalTo(overlay.snp.leading).offset(targetRect.minX - self.spacing)
                    make.centerY.equalTo(overlay.snp.top).offset(clampedCenterY)
                case .right:
                    make.leading.equalTo(overlay.snp.leading).offset(targetRect.maxX + self.spacing)
                    make.centerY.equalTo(overlay.snp.top).offset(clampedCenterY)
                }
            }

            overlay.layoutIfNeeded()

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
