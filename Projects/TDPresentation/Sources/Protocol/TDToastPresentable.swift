import SnapKit
import TDDesign
import UIKit

protocol TDToastPresentable {
    func showToast(type: TDToastView.TDToastType, title: String, message: String, duration: Double?)
}

@MainActor
extension TDToastPresentable where Self: UIViewController {
    func showToast(
        type: TDToastView.TDToastType,
        title: String,
        message: String,
        duration: Double?
    ) {
        let toastView = TDToastView(type: type, titleText: title, contentText: message)
        guard let keyWindow = getKeyWindow() else { return }
        
        addToastView(toastView, to: keyWindow)
        animateToastAppearance(toastView, in: keyWindow, duration: duration)
    }
    
    private func getKeyWindow() -> UIWindow? {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
    
    private func addToastView(_ toastView: TDToastView, to window: UIWindow) {
        window.addSubview(toastView)
        toastView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(-70)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        window.layoutIfNeeded()
    }
    
    private func animateToastAppearance(
        _ toastView: TDToastView,
        in window: UIWindow,
        duration: Double?
    ) {
        if let duration {
            toastView.startCountdown(seconds: Int(duration))
        }
        
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                toastView.snp.updateConstraints { make in
                    make.top.equalToSuperview().inset(80)
                }
                window.layoutIfNeeded()
            },
            completion: { _ in
                UIView.animate(
                    withDuration: 0.5,
                    delay: duration ?? 2,
                    options: .curveEaseIn,
                    animations: {
                        toastView.alpha = 0
                    },
                    completion: { _ in
                        toastView.removeFromSuperview()
                    }
                )
            }
        )
    }
    
    func dismissToast() {
        guard let keyWindow = getKeyWindow() else { return }
        keyWindow.subviews
            .filter { $0 is TDToastView }
            .forEach { $0.removeFromSuperview() }
    }
}
