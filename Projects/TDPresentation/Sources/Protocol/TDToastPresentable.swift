import SnapKit
import TDDesign
import UIKit

protocol TDToastPresentable {
    func showToast(type: TDToast.TDToastType, title: String, message: String)
}

extension TDToastPresentable where Self: UIViewController {
	func showToast(type: TDToast.TDToastType, title: String, message: String) {
		let toastView = TDToast(toastType: type, titleText: title, contentText: message)

		guard
			let keyWindow = UIApplication.shared.connectedScenes
				.compactMap({ $0 as? UIWindowScene })
				.flatMap({ $0.windows })
				.first(where: { $0.isKeyWindow })
		else {
			return
		}

		keyWindow.addSubview(toastView)
		toastView.snp.makeConstraints { make in
			make.top.equalTo(view.safeAreaLayoutGuide).inset(-69)
			make.leading.trailing.equalToSuperview().inset(20)
		}
		keyWindow.layoutIfNeeded()

		// 애니메이션으로 화면 아래로 이동하여 표시
		UIView.animate(
			withDuration: 0.5, delay: 0, options: .curveEaseInOut,
			animations: {
				toastView.snp.updateConstraints { make in
					make.top.equalTo(self.view.safeAreaLayoutGuide).inset(10)
				}
				keyWindow.layoutIfNeeded()
			}
		) { _ in
			// 2초 대기 후 페이드 아웃 및 제거
			UIView.animate(
				withDuration: 0.5, delay: 2.0, options: .curveEaseIn,
				animations: {
					toastView.alpha = 0
				}
			) { _ in
				toastView.removeFromSuperview()
			}
		}
	}
}
