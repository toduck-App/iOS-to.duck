import SnapKit
import TDDesign
import UIKit

protocol TDToastPresentable {
    func showToast(type: TDToastView.TDToastType, title: String, message: String, duration: Double?) async
}

extension TDToastPresentable where Self: UIViewController {
    @MainActor
    func showToast(
        type: TDToastView.TDToastType,
        title: String,
        message: String,
        duration: Double?
    ) {
        let toastView = TDToastView(type: .orange, titleText: title, contentText: message)
        
        guard
            let keyWindow = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .flatMap({ $0.windows })
                .first(where: { $0.isKeyWindow })
        else { return }
        
        keyWindow.addSubview(toastView)
        toastView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(-70)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        keyWindow.layoutIfNeeded()
        
        if let duration {
            toastView.startCountdown(seconds: Int(duration))
        }
        
        UIView.animate(
            withDuration: 0.5, delay: 0, options: .curveEaseInOut,
            animations: {
                toastView.snp.updateConstraints { make in
                    make.top.equalToSuperview().inset(80)
                }
                keyWindow.layoutIfNeeded()
            },
            completion: { _ in
                UIView.animate(
                    withDuration: 0.5,
                    delay: duration ?? 2,
                    options: .curveEaseIn,
                    animations: { toastView.alpha = 0 },
                    completion: { _ in toastView.removeFromSuperview() }
                )
            })
    }
    
    func dismissToast() {
        guard let keyWindow = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow }) else {
            return
        }
        
        keyWindow.subviews
            .filter { $0 is TDToastView }
            .forEach { $0.removeFromSuperview() }
    }
}
