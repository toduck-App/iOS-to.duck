import SnapKit
import TDDesign
import TDDomain
import Then
import UIKit

final class QRWebLoginPopupViewController: TDPopupViewController<QRWebLoginPopupView> {
    private let sessionToken: String
    private let authorizeWebSessionUseCase: AuthorizeWebSessionUseCase
    var onLoginSuccess: (() -> Void)?

    init(sessionToken: String, authorizeWebSessionUseCase: AuthorizeWebSessionUseCase) {
        self.sessionToken = sessionToken
        self.authorizeWebSessionUseCase = authorizeWebSessionUseCase
        super.init()
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func configure() {
        super.configure()
        isBackgroundGestureEnabled = false

        popupContentView.loginButton.addAction(UIAction { [weak self] _ in
            self?.handleLogin()
        }, for: .touchUpInside)

        popupContentView.cancelButton.addAction(UIAction { [weak self] _ in
            self?.dismissPopup()
        }, for: .touchUpInside)
    }

    private func handleLogin() {
        popupContentView.loginButton.isEnabled = false

        Task { [weak self] in
            guard let self else { return }
            do {
                try await authorizeWebSessionUseCase.execute(sessionToken: sessionToken)
                await MainActor.run {
                    self.dismiss(animated: true) {
                        self.onLoginSuccess?()
                        self.showLoginSuccessToast()
                    }
                }
            } catch {
                await MainActor.run {
                    self.popupContentView.loginButton.isEnabled = true
                    self.showErrorAlert(errorMessage: "웹 로그인에 실패했습니다.")
                }
            }
        }
    }

    private func showLoginSuccessToast() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }) else { return }

        let toastLabel = UILabel().then {
            $0.text = "웹 로그인이 완료되었습니다."
            $0.font = TDFont.boldBody2.font
            $0.textColor = TDColor.baseWhite
            $0.backgroundColor = TDColor.Neutral.neutral700
            $0.textAlignment = .center
            $0.layer.cornerRadius = 12
            $0.clipsToBounds = true
        }

        window.addSubview(toastLabel)
        toastLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(window.safeAreaLayoutGuide).inset(32)
            $0.height.equalTo(44)
            $0.leading.trailing.equalToSuperview().inset(40)
        }

        UIView.animate(withDuration: 0.3, delay: 1.5, options: .curveEaseOut) {
            toastLabel.alpha = 0
        } completion: { _ in
            toastLabel.removeFromSuperview()
        }
    }
}
