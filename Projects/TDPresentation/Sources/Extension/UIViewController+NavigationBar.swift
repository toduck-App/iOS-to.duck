import UIKit
import TDDesign

extension UIViewController {
    func setupNavigationBar(
        style: TDNavigationBarStyle,
        navigationDelegate: NavigationDelegate
    ) {
        // 좌측 캘린더 버튼
        let calendarButton = UIButton(type: .custom)
        calendarButton.setImage(TDImage.Calendar.top2Medium, for: .normal)
        calendarButton.addAction(UIAction { _ in
            navigationDelegate.didTapCalendarButton()
        }, for: .touchUpInside)

        // 로고 이미지
        let toduckLogoImageView = UIImageView(image: TDImage.toduckLogo)
        toduckLogoImageView.contentMode = .scaleAspectFit
        
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(customView: calendarButton),
            UIBarButtonItem(customView: toduckLogoImageView)
        ]
        
        // 우측 버튼
        navigationItem.rightBarButtonItem = createRightBarButton(style: style)
    }
    
    // MARK: - 오른쪽 네비게이션 바 버튼 생성
    private func createRightBarButton(style: TDNavigationBarStyle) -> UIBarButtonItem? {
        let button = UIButton(type: .custom)
        
        switch style {
        case .home, .diary, .info:
            // 알림 버튼
            button.setImage(TDImage.Bell.topOffMedium, for: .normal)
            button.addAction(UIAction { _ in
                print("알림 버튼 클릭")
            }, for: .touchUpInside)
        case .timer:
            // 점 버튼
            button.setImage(TDImage.Dot.vertical2Small, for: .normal)
            button.addAction(UIAction { _ in
                print("점 버튼 클릭")
            }, for: .touchUpInside)
        case .social:
            // 검색 버튼
            button.setImage(TDImage.Setting.fillMedium, for: .normal)
            button.addAction(UIAction { _ in
                print("검색 버튼 클릭")
            }, for: .touchUpInside)
        }
        
        return UIBarButtonItem(customView: button)
    }
}
