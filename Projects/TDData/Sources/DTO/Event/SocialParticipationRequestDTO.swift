public struct SocialParticipationRequestDTO: Encodable, Sendable {
    public let socialId: Int
    public let phone: String
    public let date: String // ISO-8601 date (yyyy-MM-dd)
}
