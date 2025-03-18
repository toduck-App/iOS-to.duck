import Foundation

extension Date {
    var currentDateString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "M월 d일 (E)" // "3월 26일 (화)" 형식
        return formatter.string(from: Date())
    }
}
