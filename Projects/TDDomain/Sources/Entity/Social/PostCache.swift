// MARK: - 내부 데이터 캐시 관리용 Actor
/// 게시글 데이터를 메모리 내에서 관리합니다.
/// 기본(PostList)과 검색(Search) 모드를 분리해 상태를 보존합니다.
public actor PostCache {
    // MARK: - 게시글 모드
    public enum Mode: Equatable {
        case `default`
        case search(keyword: String)
    }

    // MARK: - 적용 범위
    public enum Scope {
        case current
        case everywhere
        case specific(Mode)
    }

    // MARK: - 내부 저장소
    private(set) var mode: Mode = .default
    private var defaultPosts: [Post] = []
    private var searchPosts: [Post] = []

    public init() {}

    // MARK: - 모드 관리
    public func setMode(_ newMode: Mode) { mode = newMode }
    public func currentMode() -> Mode { mode }

    // MARK: - 내부 리스트 접근자

    private func setList(_ new: [Post], for scope: Scope) {
        switch scope {
        case .current:
            switch mode {
            case .default: defaultPosts = new
            case .search: searchPosts = new
            }
        case .specific(let target):
            switch target {
            case .default: defaultPosts = new
            case .search: searchPosts = new
            }
        case .everywhere:
            defaultPosts = new
            searchPosts = new
        }
    }

    private func withLists(for scope: Scope, _ body: (inout [Post]) -> Void) {
        switch scope {
        case .current:
            switch mode {
            case .default: body(&defaultPosts)
            case .search: body(&searchPosts)
            }
        case .specific(let target):
            switch target {
            case .default: body(&defaultPosts)
            case .search: body(&searchPosts)
            }
        case .everywhere:
            body(&defaultPosts)
            body(&searchPosts)
        }
    }

    // MARK: - 조회
    public func current() -> [Post] {
        switch mode {
        case .default: return defaultPosts
        case .search: return searchPosts
        }
    }

    // MARK: - 수정/갱신 (범위 지정형)

    public func replaceAll(with posts: [Post], scope: Scope = .current) {
        setList(posts, for: scope)
    }

    public func append(_ newPosts: [Post], dedup: Bool = true, scope: Scope = .current) {
        withLists(for: scope) { list in
            guard !newPosts.isEmpty else { return }
            if dedup {
                var seen = Set(list.map(\.id))
                for p in newPosts where seen.insert(p.id).inserted {
                    list.append(p)
                }
            } else {
                list.append(contentsOf: newPosts)
            }
        }
    }

    public func insertAtTop(_ post: Post, scope: Scope = .current) {
        withLists(for: scope) { list in
            list.insert(post, at: 0)
        }
    }

    public func update(_ id: Post.ID, scope: Scope = .current, transform: (Post) -> Post?) {
        withLists(for: scope) { list in
            if let i = list.firstIndex(where: { $0.id == id }),
               let new = transform(list[i]) {
                list[i] = new
            }
        }
    }

    public func remove(_ id: Post.ID, scope: Scope = .current) {
        withLists(for: scope) { list in
            list.removeAll { $0.id == id }
        }
    }

    public func adjustCommentCount(_ postID: Post.ID, by delta: Int, scope: Scope = .current) {
        guard delta != 0 else { return }
        withLists(for: scope) { list in
            if let i = list.firstIndex(where: { $0.id == postID }) {
                var p = list[i]
                let current = p.commentCount ?? 0
                p.commentCount = max(0, current + delta)
                list[i] = p
            }
        }
    }

    // MARK: - 스냅샷
    public func snapshot() -> (default: [Post], search: [Post]) {
        (defaultPosts, searchPosts)
    }

    public func restore(_ snapshot: (default: [Post], search: [Post])) {
        defaultPosts = snapshot.default
        searchPosts = snapshot.search
    }
}
