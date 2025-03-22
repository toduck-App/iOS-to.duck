struct ServerResponse<T: Decodable>: Decodable {
    let code: Int
    let content: T?
    let message: String?
}
