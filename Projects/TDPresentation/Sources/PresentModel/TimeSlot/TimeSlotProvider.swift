import Foundation

protocol TimeSlotProvider {
    var timeSlots: [TimeSlot] { get }
    
    func convertEventToDisplayItem(event: EventPresentable) -> EventDisplayItem
    func isEventRepeating(at index: Int) -> Bool
}

extension TimeSlotProvider {
    func isEventRepeating(at index: Int) -> Bool {
        var cumulativeIndex = 0
        
        for slot in timeSlots {
            let count = slot.events.count
            
            // indexPath.row가 현재 누적 index 범위 안에 있다면 찾기
            if index < cumulativeIndex + count {
                let eventIndexInSlot = index - cumulativeIndex
                
                // 배열 범위 초과 방지
                guard eventIndexInSlot >= 0, eventIndexInSlot < slot.events.count else {
                    return false
                }
                
                return slot.events[eventIndexInSlot].isRepeating
            }
            
            // 다음 슬롯을 위해 누적 index 업데이트
            cumulativeIndex += count
        }
        
        return false
    }
}
