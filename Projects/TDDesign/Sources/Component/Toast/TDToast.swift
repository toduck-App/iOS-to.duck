import UIKit
import SnapKit

public final class TDToast: UIView {
    let toastView: TDToastView
    private var timer: Timer?
    private var remainingSeconds: Int = 0
    
    public convenience init(
        toastType: TDToastType,
        titleText: String,
        contentText: String
    ) {
        self.init(
            foregroundColor: toastType.color,
            tomatoImage: toastType.tomato,
            titleText: titleText,
            contentText: contentText
        )
    }
    
    public init(
        foregroundColor: UIColor,
        tomatoImage: UIImage,
        titleText: String,
        contentText: String
    ) {
        toastView = TDToastView(
            foregroundColor: foregroundColor,
            tomatoImage: tomatoImage,
            titleText: titleText,
            contentText: contentText
        )
        super.init(frame: .zero)
        configure()
        layout()
    }
    
    @available(*, unavailable)
    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        timer?.invalidate()
    }
    
    private func configure() {
        backgroundColor = .clear
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 10
        layer.masksToBounds = false
        
        addSubview(toastView)
    }
    
    private func layout() {
        toastView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    @MainActor
    public func startCountdown(seconds: Int) {
        timer?.invalidate()
        remainingSeconds = seconds
        updateMessage()

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self else { return }
            remainingSeconds -= 1

            if remainingSeconds > 0 {
                updateMessage()
            } else {
                timer?.invalidate()
                timer = nil
            }
        }
    }

    private func updateMessage() {
        toastView.updateContentText("\(remainingSeconds)초 안에 재시작하면 집중시간이 이어집니다")
    }
}
