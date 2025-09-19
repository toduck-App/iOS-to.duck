/// 특정 날짜의 데이터를 가공한 최종 결과물 모델
public struct DailyTodoList {
    public let allDayItems: [any TodoItem]
    public let timedItems: [any TodoItem]
    
    public init(
        allDayItems: [any TodoItem],
        timedItems: [any TodoItem]
    ) {
        self.allDayItems = allDayItems
        self.timedItems = timedItems
    }
}
