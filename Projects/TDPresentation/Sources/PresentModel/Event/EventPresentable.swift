import UIKit

protocol EventPresentable {
    var id: Int? { get }
    var title: String { get }
    var categoryIcon: UIImage? { get }
    var categoryColor: UIColor { get }
    var time: String? { get }
    var memo: String? { get }
    var isFinished: Bool { get }
    var isRepeating: Bool { get }
}
