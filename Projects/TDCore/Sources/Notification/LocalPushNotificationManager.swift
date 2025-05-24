import UserNotifications

public final class LocalPushNotificationManager {
    public static let shared = LocalPushNotificationManager()
    
    private init() {}
    
    public func requestAuthorization(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }
    
    public func checkAuthorization(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                completion(settings.authorizationStatus == .authorized)
            }
        }
    }
    
    public func sendNotification(type: LocalNotificationType, delay: TimeInterval = 1) {
        let isPushEnabled = UserDefaults.standard.bool(forKey: UserDefaultsConstant.pushEnabledKey)
        guard isPushEnabled else {
            TDLogger.debug("Push notifications are disabled.")
            return
        }
        
        let content = UNMutableNotificationContent()
        content.title = type.title
        content.body = type.body
        
        let isSilent = UserDefaults.standard.bool(forKey: UserDefaultsConstant.pushSilentKey)
        content.sound = isSilent ? nil : .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: delay, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                TDLogger.error("Error adding notification: \(error.localizedDescription)")
            }
        }
    }
    
    public func removeAllScheduledNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
