import Foundation

public protocol Eventable {
    var id: Int? { get }
    var title: String { get }
    var memo: String? { get} 
    var category: TDCategory { get }
    var time: Date? { get }
    var isFinish: Bool { get }
}
