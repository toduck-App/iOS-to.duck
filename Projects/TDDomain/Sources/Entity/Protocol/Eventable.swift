import Foundation

public protocol Eventable {
    var id: Int? { get }
    var title: String { get }
    var category: TDCategory { get }
    var time: Date? { get }
    var memo: String? { get }
    var isFinished: Bool { get }
    var isRepeating: Bool { get }
    var eventMode: TDEventMode { get }
}
