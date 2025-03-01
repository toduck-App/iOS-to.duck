public protocol FocusCountRepository {
    func fetch() -> Int
    func update(_ focusCount: Int)
}
