import Foundation

protocol Event {
    var id: Int { get }
    var name: String { get }
    var startDate: Date { get }
    var endDate: Date { get }
    var thumbnailUrl: URL? { get }
    var appVersion: String { get }
}
