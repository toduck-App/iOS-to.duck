import Foundation
import EventKit
import TDCore
import TDData

final class ScheduleStorageImpl: ScheduleStorage {
    private let eventStore = EKEventStore()
    
    func fetchEvents(from startDate: Date, to endDate: Date) async throws -> [EKEvent] {
        guard EKEventStore.authorizationStatus(for: .event) == .authorized else {
            throw TDDataError.permissionDenied
        }
        
        let predicate = eventStore.predicateForEvents(
            withStart: startDate,
            end: endDate,
            calendars: nil
        )
        
        let events = eventStore.events(matching: predicate)
        
        return events
    }
}
