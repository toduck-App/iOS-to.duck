import UserNotifications

public final class LocalPushNotificationManager {
    public static let shared = LocalPushNotificationManager()
    
    private init() {}
    
    public func sendNotification(type: LocalNotificationType, delay: TimeInterval = 1) {
        let content = UNMutableNotificationContent()
        content.title = type.title
        content.body = type.body
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: delay, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("로컬 알림 등록 실패: \(error.localizedDescription)")
            }
        }
    }
}
