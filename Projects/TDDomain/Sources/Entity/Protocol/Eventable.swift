import Foundation

public protocol Eventable: Hashable {
    var id: Int? { get }
    var title: String { get }
    var category: TDCategory { get }
    var isAllDay: Bool { get }
    var time: String? { get }
    var isRepeating: Bool { get }
    var repeatDays: [TDWeekDay]? { get }
    var alarmTime: AlarmTime? { get }
    var memo: String? { get }
    var isFinished: Bool { get }
    var eventMode: TDEventMode { get }
}
