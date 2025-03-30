struct ServerResponse<T: Decodable>: Decodable {
    let code: Int
    let content: T?
    let message: String?
    
    enum CodingKeys: CodingKey {
        case code
        case content
        case message
    }
    
    init(from decoder: any Decoder) throws {
        let container: KeyedDecodingContainer<ServerResponse<T>.CodingKeys> = try decoder.container(keyedBy: ServerResponse<T>.CodingKeys.self)
        self.code = try container.decode(Int.self, forKey: ServerResponse<T>.CodingKeys.code)
        self.content = try? container.decodeIfPresent(T.self, forKey: ServerResponse<T>.CodingKeys.content)
        self.message = try container.decodeIfPresent(String.self, forKey: ServerResponse<T>.CodingKeys.message)
    }
}
