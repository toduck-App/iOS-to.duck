struct EventDTO: Decodable {
    let id: Int
    let eventName: String
    let startAt: String
    let endAt: String
    let thumbUrl: String?
    let appVersion: String
}
