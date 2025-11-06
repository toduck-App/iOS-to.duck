// MARK: - 내부 데이터 캐시 관리용 Actor
/// 게시글 데이터를 메모리 내에서 관리합니다.
/// 기본(PostList)과 검색(Search) 모드를 분리해 상태를 보존합니다.
public actor PostCache {
    /// 게시글 모드 (일반/검색)
    public enum Mode: Equatable {
        case `default`
        case search(keyword: String)
    }

    // MARK: - 내부 저장 프로퍼티
    private(set) var mode: Mode = .default
    private var defaultPosts: [Post] = []
    private var searchPosts: [Post] = []

    /// 현재 모드에 따라 접근할 게시글 리스트
    private var activeList: [Post] {
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
    
    public init() { }

    /// 두 리스트 모두에 대해 동일 작업을 수행할 때 사용
    private func withAllLists(_ body: (inout [Post]) -> Void) {
        body(&defaultPosts)
        body(&searchPosts)
    }

    // MARK: - 모드 관리
    public func setMode(_ newMode: Mode) { mode = newMode }
    public func currentMode() -> Mode { mode }

    // MARK: - 조회
    public func current() -> [Post] { activeList }

    // MARK: - 갱신 (현재 모드만)
    public func replaceAll(with posts: [Post]) { activeList = posts }

    /// 중복되지 않게 게시글을 추가 (커서 기반 append용)
    public func appendDedup(_ newPosts: [Post]) {
        guard !newPosts.isEmpty else { return }
        var seen = Set(activeList.map(\.id))
        var merged = activeList
        merged.reserveCapacity(activeList.count + newPosts.count)
        for p in newPosts where seen.insert(p.id).inserted {
            merged.append(p)
        }
        activeList = merged
    }
    
    public func append(_ newPost: Post) {
        activeList.append(newPost)
    }

    /// 특정 게시글을 업데이트 (변환 클로저 사용)
    public func update(_ id: Post.ID, transform: (Post) -> Post?) {
        guard let i = activeList.firstIndex(where: { $0.id == id }) else { return }
        if let new = transform(activeList[i]) {
            var arr = activeList
            arr[i] = new
            activeList = arr
        }
    }

    /// 특정 게시글을 제거
    public func remove(_ id: Post.ID) {
        activeList.removeAll { $0.id == id }
    }

    // MARK: - 전체 리스트에 적용 (default + search)
    public func appendEverywhere(_ post: Post) {
        withAllLists { list in
            list.append(post)
        }
    }
    
    public func updateEverywhere(_ id: Post.ID, transform: (Post) -> Post?) {
        withAllLists { list in
            if let i = list.firstIndex(where: { $0.id == id }) {
                if let new = transform(list[i]) { list[i] = new }
            }
        }
    }

    public func replaceEveryWhere(_ post: Post) {
        withAllLists { list in
            if let i = list.firstIndex(where: { $0.id == post.id }) {
                list[i] = post
            }
        }
    }

    public func removeEverywhere(_ id: Post.ID) {
        withAllLists { list in
            list.removeAll { $0.id == id }
        }
    }

    // MARK: - 댓글 수 조정
    public func adjustCommentCount(_ postID: Post.ID, by delta: Int) {
        guard delta != 0 else { return }
        withAllLists { list in
            if let i = list.firstIndex(where: { $0.id == postID }) {
                var p = list[i]
                let current = p.commentCount ?? 0
                p.commentCount = max(0, current + delta)
                list[i] = p
            }
        }
    }

    // MARK: - 스냅샷 (복원용)
    public func snapshot() -> (default: [Post], search: [Post]) {
        (defaultPosts, searchPosts)
    }

    public func restore(_ snapshot: (default: [Post], search: [Post])) {
        self.defaultPosts = snapshot.default
        self.searchPosts  = snapshot.search
    }
}
