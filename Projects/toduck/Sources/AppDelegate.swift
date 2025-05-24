import UIKit
import TDNetwork
import TDCore
import FirebaseCore
import FirebaseMessaging
import UserNotifications
import KakaoSDKAuth
import KakaoSDKCommon

@main
final class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    var window: UIWindow?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        configureFirebase()
        configureKakaoSDK()
        return true
    }
    
    // MARK: Firebase 초기화
    
    private func configureFirebase() {
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
    }
    
    // MARK: - APNs 등록 성공/실패
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        Messaging.messaging().apnsToken = deviceToken
        TDLogger.info("✅ APNs 디바이스 토큰 등록 완료")
        
        Messaging.messaging().token { token, error in
            if let error = error {
                TDLogger.error("❌ FCM 토큰 받기 실패: \(error.localizedDescription)")
            } else if let token = token {
                TDLogger.info("✅ 초기 FCM 토큰: \(token)")
                NotificationCenter.default.post(
                    name: .didReceiveFCMToken,
                    object: nil,
                    userInfo: ["token": token]
                )
            }
        }
    }
    
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        TDLogger.error("❌ APNs 등록 실패: \(error.localizedDescription)")
    }
    
    // MARK: - 푸시 알림 응답 처리
    
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
    
    // MARK: - FCM 토큰 갱신
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken else { return }
        TDLogger.info("🔄 FCM 토큰 갱신됨: \(fcmToken)")
        
        NotificationCenter.default.post(
            name: .didReceiveFCMToken,
            object: nil,
            userInfo: ["token": fcmToken]
        )
    }
    
    // MARK: - 카카오 로그인 처리
    
    func application(
        _ application: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        if AuthApi.isKakaoTalkLoginUrl(url) {
            return AuthController.handleOpenUrl(url: url)
        }
        return false
    }
    
    // MARK: - Kakao SDK 초기화
    
    private func configureKakaoSDK() {
        if let kakaoAppKey = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] as? String {
            KakaoSDK.initSDK(appKey: kakaoAppKey)
        }
    }
}
