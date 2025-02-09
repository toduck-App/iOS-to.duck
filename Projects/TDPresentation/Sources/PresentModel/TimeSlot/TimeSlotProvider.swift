protocol TimeSlotProvider {
    var timeSlots: [TimeSlot] { get }
    
    func convertEventToDisplayItem(event: EventPresentable) -> EventDisplayItem
}
