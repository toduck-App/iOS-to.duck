import UIKit
import TDDomain

protocol EventPresentable: Hashable {
    var id: Int? { get }
    var title: String { get }
    var categoryIcon: UIImage? { get }
    var categoryColor: UIColor { get }
    var time: String? { get }
    var repeatDays: [TDWeekDay]? { get }
    var alarmTime: AlarmTime? { get }
    var memo: String? { get }
    var isFinished: Bool { get }
    var isRepeating: Bool { get }
    var eventMode: TDEventMode { get }
}
