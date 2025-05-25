import Foundation

extension String {
    public func toRelativeTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")

        guard let date = formatter.date(from: self) else {
            return self
        }

        let interval = Int(Date().timeIntervalSince(date))
        if interval < 60 {
            return "\(interval)초 전"
        } else if interval < 3600 {
            return "\(interval / 60)분 전"
        } else if interval < 86400 {
            return "\(interval / 3600)시간 전"
        } else {
            return "\(interval / 86400)일 전"
        }
    }
}
