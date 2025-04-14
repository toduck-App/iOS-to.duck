public protocol FocusService {
    func fetchFocusPrecent() async throws -> Int
}
