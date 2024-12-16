import UIKit
import TDCore
import TDDesign

extension UIViewController {
    func setupNavigationBar(
        style: TDNavigationBarStyle,
        navigationDelegate: NavigationDelegate
    ) {
        // 좌측 버튼 설정 (캘린더 + 로고)
        navigationItem.leftBarButtonItems = createLeftBarButtons(style: style, navigationDelegate: navigationDelegate)
        
        // 우측 버튼 설정 (Style에 따라 다름)
        navigationItem.rightBarButtonItem = createRightBarButton(style: style)
    }
    
    // MARK: - 좌측 네비게이션 바 버튼 생성
    private func createLeftBarButtons(
        style: TDNavigationBarStyle,
        navigationDelegate: NavigationDelegate
    ) -> [UIBarButtonItem] {
        let calendarButton = UIButton(type: .custom)
        calendarButton.setImage(TDImage.Calendar.top2Medium, for: .normal)
        calendarButton.addAction(UIAction { _ in
            navigationDelegate.didTapCalendarButton()
        }, for: .touchUpInside)
        
        let toduckLogoImageView = UIImageView(image: TDImage.toduckLogo)
        toduckLogoImageView.contentMode = .scaleAspectFit
        
        // 집중 화면의 경우 TintColor 수정
        if style == .timer {
            calendarButton.setImage(TDImage.Calendar.top2Medium.withRenderingMode(.alwaysTemplate), for: .normal)
            calendarButton.tintColor = TDColor.Primary.primary300

            toduckLogoImageView.image = TDImage.toduckLogo.withRenderingMode(.alwaysTemplate)
            toduckLogoImageView.tintColor = TDColor.Primary.primary300
        }

        return [
            UIBarButtonItem(customView: calendarButton),
            UIBarButtonItem(customView: toduckLogoImageView)
        ]
    }
    
    // MARK: - 오른쪽 네비게이션 바 버튼 생성
    private func createRightBarButton(style: TDNavigationBarStyle) -> UIBarButtonItem? {
        let button = UIButton(type: .custom)
        
        switch style {
        case .home, .diary, .mypage:
            button.setImage(TDImage.Bell.topOffMedium, for: .normal)
            button.addAction(UIAction { _ in
                // TODO: - 알림 기능 추가
                TDLogger.debug("알림 버튼 클릭")
            }, for: .touchUpInside)
        case .timer:
            button.setImage(TDImage.Dot.verticalMedium.withRenderingMode(.alwaysTemplate), for: .normal)
            button.addAction(UIAction { _ in
                // TODO: - 점 기능 추가
                TDLogger.debug("Dot 버튼 클릭")
            }, for: .touchUpInside)
        case .social:
            button.setImage(TDImage.searchMedium, for: .normal)
            button.addAction(UIAction { _ in
                // TODO: - 검색 기능 추가
                TDLogger.debug("검색 버튼 클릭")
            }, for: .touchUpInside)
        }
        
        // Timer 스타일일 경우 TintColor 적용
        if style == .timer {
            button.tintColor = TDColor.Primary.primary300
        }
        
        return UIBarButtonItem(customView: button)
    }
}
