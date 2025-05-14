import UIKit
import KakaoSDKAuth
import KakaoSDKCommon
import FirebaseCore
import FirebaseMessaging
import UserNotifications

@main
final class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    var window: UIWindow?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        configureFirebase()
        configureKakaoSDK()
        configurePushNotification()
        return true
    }
    
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        return UISceneConfiguration(
            name: "Default Configuration",
            sessionRole: connectingSceneSession.role
        )
    }
    
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        if AuthApi.isKakaoTalkLoginUrl(url) {
            return AuthController.handleOpenUrl(url: url)
        }
        return false
    }
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        Messaging.messaging().apnsToken = deviceToken
        print("✅ APNs 디바이스 토큰 등록 완료")
    }
    
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        print("❌ APNs 등록 실패: \(error.localizedDescription)")
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo

        if let actionUrlString = userInfo["actionUrl"] as? String,
           let actionUrl = URL(string: actionUrlString) {
            DispatchQueue.main.async {
                NotificationCenter.default.post(
                    name: .didReceivePushNotificationURL,
                    object: nil,
                    userInfo: ["url": actionUrl]
                )
            }
        }

        completionHandler()
    }
    
    // MARK: - Firebase 초기화
    
    private func configureFirebase() {
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        
        // FCM 초기 토큰 수신
        Messaging.messaging().token { token, error in
            if let error = error {
                print("❌ FCM 토큰 받기 실패: \(error.localizedDescription)")
            } else if let token = token {
                print("✅ 초기 FCM 토큰: \(token)")
                // 서버 전송 로직 위치
            }
        }
    }
    
    // MARK: - Kakao 초기화
    
    private func configureKakaoSDK() {
        if let kakaoAppKey = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] as? String {
            KakaoSDK.initSDK(appKey: kakaoAppKey)
        }
    }
    
    // MARK: - 푸시 알림 권한 요청
    
    private func configurePushNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else {
                print("❌ 푸시 알림 권한 거부 또는 오류: \(error?.localizedDescription ?? "unknown error")")
            }
        }
    }
    
    // MARK: - FCM 토큰 갱신 시
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken = fcmToken else { return }
        print("🔄 FCM 토큰 갱신됨: \(fcmToken)")
    }
}
