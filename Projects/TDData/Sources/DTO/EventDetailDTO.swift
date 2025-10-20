struct EventDetailDTO: Decodable {
    let eventsDetailId: Int
    let eventsId: Int
    let routingUrl: String?
    let eventsDetailImgUrl: [String]?
}
