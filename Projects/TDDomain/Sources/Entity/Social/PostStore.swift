private actor PostStore {
    enum Mode: Equatable {
        case `default`
        case search(keyword: String)
    }

    private(set) var mode: Mode = .default
    private var defaultPosts: [Post] = []
    private var searchPosts:  [Post] = []

    private var activePosts: [Post] {
        get {
            switch mode {
            case .default: return defaultPosts
            case .search:  return searchPosts
            }
        }
        set {
            switch mode {
            case .default: defaultPosts = newValue
            case .search:  searchPosts  = newValue
            }
        }
    }

    private func withAllLists(_ body: (inout [Post]) -> Void) {
        body(&defaultPosts)
        body(&searchPosts)
    }

    // MARK: - Mode
    func setMode(_ newMode: Mode) { mode = newMode }
    func modeValue() -> Mode { mode }

    // MARK: - Query
    func current() -> [Post] { activePosts }

    // MARK: - Write APIs (현재 모드에 대해서만)
    func replaceAll(with posts: [Post]) { activePosts = posts }

    func appendDedup(_ newPosts: [Post]) {
        guard !newPosts.isEmpty else { return }
        var seen = Set(activePosts.map(\.id))
        var merged = activePosts
        merged.reserveCapacity(activePosts.count + newPosts.count)
        for p in newPosts where seen.insert(p.id).inserted {
            merged.append(p)
        }
        activePosts = merged
    }

    func upsertAtHead(_ post: Post) {
        if let idx = activePosts.firstIndex(where: { $0.id == post.id }) {
            activePosts[idx] = post
        } else {
            var arr = activePosts
            arr.insert(post, at: 0)
            activePosts = arr
        }
    }

    func updateOne(id: Post.ID, _ transform: (Post) -> Post?) {
        guard let i = activePosts.firstIndex(where: { $0.id == id }) else { return }
        if let new = transform(activePosts[i]) {
            var arr = activePosts
            arr[i] = new
            activePosts = arr
        }
    }

    func remove(id: Post.ID) {
        activePosts.removeAll { $0.id == id }
    }

    func mutateEverywhere(id: Post.ID, _ transform: (Post) -> Post?) {
        withAllLists { list in
            if let i = list.firstIndex(where: { $0.id == id }) {
                if let new = transform(list[i]) { list[i] = new }
            }
        }
    }

    func insertOrReplaceEverywhere(_ post: Post) {
        var inserted = false
        withAllLists { list in
            if let i = list.firstIndex(where: { $0.id == post.id }) {
                list[i] = post
                inserted = true
            }
        }
        if !inserted { upsertAtHead(post) }
    }

    func removeEverywhere(id: Post.ID) {
        withAllLists { list in
            list.removeAll { $0.id == id }
        }
    }

    func snapshot() -> (default: [Post], search: [Post]) {
        (defaultPosts, searchPosts)
    }
    
    func restore(defaultPosts: [Post], searchPosts: [Post]) {
        self.defaultPosts = defaultPosts
        self.searchPosts  = searchPosts
    }
}
