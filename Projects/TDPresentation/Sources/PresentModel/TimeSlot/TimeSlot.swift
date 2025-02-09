/// 일정과 루틴을 함께 사용하는 뷰컨트롤러에서 사용할 타임슬롯 모델입니다.
/// - timeText: 시간 텍스트
/// - events: 일정 or 루틴 이벤트 모델
/// 11:00에 일정이 3개 있다면, 뷰모델에서는 ["11:00", [event1, event2, event3]]으로 구성됩니다.
struct TimeSlot {
    let timeText: String
    let events: [EventPresentable]
}
