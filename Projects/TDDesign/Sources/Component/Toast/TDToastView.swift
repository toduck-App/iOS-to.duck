import UIKit
import SnapKit

public final class TDToastView: UIView {
    private let sideDumpView = UIView()
    private let tomatoImageView = UIImageView()
    private let titleLabel = TDLabel(toduckFont: .boldBody2)
    private let contentLabel = TDLabel(
        toduckFont: .mediumBody3,
        toduckColor: TDColor.Neutral.neutral700
    )
    private let verticalStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 2
    }
    
    // MARK: - Properties
    private let type: TDToastType
    private var timer: Timer?
    private var remainingSeconds: Int = 0
    private let titleText: String
    private var contentText: String
    
    // MARK: - Init
    public init(
        type: TDToastType,
        titleText: String,
        contentText: String
    ) {
        self.type = type
        self.titleText = titleText
        self.contentText = contentText
        super.init(frame: .zero)
        
        setupUI()
        layoutUI()
        configure()
        setupGesture()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        timer?.invalidate()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        backgroundColor = .white
        layer.cornerRadius = 8
        clipsToBounds = true
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 10
        
        tomatoImageView.image = type.tomato
        titleLabel.setColor(type.color)
        titleLabel.setText(titleText)
        contentLabel.setText(contentText)
        
        addSubview(sideDumpView)
        addSubview(tomatoImageView)
        addSubview(verticalStackView)
        verticalStackView.addArrangedSubview(titleLabel)
        verticalStackView.addArrangedSubview(contentLabel)
    }
    
    private func layoutUI() {
        snp.makeConstraints {
            $0.height.equalTo(69)
        }
        
        sideDumpView.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
            $0.width.equalTo(8)
        }
        
        tomatoImageView.snp.makeConstraints {
            $0.leading.equalTo(sideDumpView.snp.trailing).offset(16)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }
        
        verticalStackView.snp.makeConstraints {
            $0.leading.equalTo(tomatoImageView.snp.trailing).offset(12)
            $0.trailing.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
        }
    }
    
    private func configure() {
        tomatoImageView.isUserInteractionEnabled = false
        titleLabel.isUserInteractionEnabled = false
        contentLabel.isUserInteractionEnabled = false
    }
    
    // MARK: - Countdown
    @MainActor
    public func startCountdown(seconds: Int) {
        timer?.invalidate()
        remainingSeconds = seconds
        updateCountdownMessage()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self else { return }
            self.remainingSeconds -= 1
            if self.remainingSeconds > 0 {
                self.updateCountdownMessage()
            } else {
                self.timer?.invalidate()
                self.timer = nil
            }
        }
    }
    
    private func updateCountdownMessage() {
        contentLabel.setText("\(remainingSeconds)초 안에 재시작하면 집중시간이 이어집니다")
    }
    
    // MARK: - Gesture
    private func setupGesture() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        addGestureRecognizer(pan)
    }
    
    @objc
    private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        guard translation.y < 0 else { return }
        
        switch gesture.state {
        case .changed:
            transform = CGAffineTransform(translationX: 0, y: translation.y)
        case .ended, .cancelled:
            let velocity = gesture.velocity(in: self).y
            let shouldDismiss = translation.y < -40 || velocity < -300
            
            if shouldDismiss {
                dismissWithSwipe()
            } else {
                UIView.animate(withDuration: 0.2) {
                    self.transform = .identity
                }
            }
        default:
            break
        }
    }
    
    private func dismissWithSwipe() {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn) {
            self.transform = CGAffineTransform(translationX: 0, y: -self.bounds.height)
            self.alpha = 0
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
}
