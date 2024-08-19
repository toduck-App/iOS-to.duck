import UIKit

/// 주어진 뷰 컨트롤러를 팝업으로 표시합니다.
///
/// - Parameters:
///   - viewController: 팝업으로 표시할 뷰 컨트롤러. 이 뷰 컨트롤러는 **반드시** `TDPopupPresentDelegate`를 채택해야 합니다.
///
/// - Important: 이 메서드를 호출하기 전에, `viewController`가 `TDPopupPresentDelegate`를 준수하는지 확인해야 합니다.
///
/// 예제:
/// ```swift
/// let popupVC = TDPopupViewController()
/// popupVC.delegate = self
/// presentPopup(with: popupVC)
/// ```
///
/// - Note: 이 메서드에 전달되는 `viewController`는 `TDPopupViewController`의 서브클래스이면서 `TDPopupPresentDelegate`를 준수해야 합니다.
protocol TDPopupPresent {
    // popup을 띄우는 함수입니다
    func presentPopup(with vc: TDPopupViewController)
}

extension TDPopupPresent where Self: UIViewController {
    func presentPopup(with viewController: TDPopupViewController) {
        viewController.modalPresentationStyle = .overFullScreen
        viewController.modalTransitionStyle = .crossDissolve
        present(viewController, animated: true)
    }
}

// MARK: - Delegate

/// TDPopupPresent에 그려질 뷰를 그립니다.
///
/// 각각의 뷰는 스택으로 쌓여진 상태로 순서는 `Title` - `Content` - `Bottom` 입니다.
protocol TDPopupPresentDelegate: UIViewController {
    func popupTitleView(popupVc: TDPopupViewController) -> UIView?
    func popupContentView(popupVc: TDPopupViewController) -> UIView?
    func popupBottomView(popupVc: TDPopupViewController) -> UIView?
}

extension TDPopupPresentDelegate where Self: UIViewController {
    func popupTitleView(popupVc _: TDPopupViewController) -> UIView? {
        return nil
    }

    func popupContentView(popupVc _: TDPopupViewController) -> UIView? {
        return nil
    }

    func popupBottomView(popupVc _: TDPopupViewController) -> UIView? {
        return nil
    }
}
