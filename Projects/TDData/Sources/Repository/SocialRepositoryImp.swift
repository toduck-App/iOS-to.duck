import Foundation
@preconcurrency import Combine
import TDCore
@preconcurrency import TDDomain

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
    
    func adjustCommentCountEverywhere(postID: Post.ID, by delta: Int) {
        guard delta != 0 else { return }
        withAllLists { list in
            if let i = list.firstIndex(where: { $0.id == postID }) {
                var p = list[i]
                let current = p.commentCount ?? 0
                let next = max(0, current + delta)
                p.commentCount = next
                list[i] = p
            }
        }
    }

    // 서버에서 최신 count를 내려줬을 때 강제 설정용 (옵션)
    func setCommentCountEverywhere(postID: Post.ID, to newValue: Int) {
        withAllLists { list in
            if let i = list.firstIndex(where: { $0.id == postID }) {
                var p = list[i]
                p.commentCount = max(0, newValue)
                list[i] = p
            }
        }
    }

    func snapshot() -> (default: [Post], search: [Post]) { (defaultPosts, searchPosts) }
    func restore(defaultPosts: [Post], searchPosts: [Post]) {
        self.defaultPosts = defaultPosts
        self.searchPosts  = searchPosts
    }
    
}


public final class SocialRepositoryImp: SocialRepository {

    // MARK: Dependencies
    private let socialService: SocialService
    private let awsService: AwsService

    // MARK: SSOT & State
    private let store = PostStore()
    private let postSubjectInternal = CurrentValueSubject<[Post], Never>([])
    public var postSubject: PassthroughSubject<[Post], Never> = .init()

    public var postPublisher: AnyPublisher<[Post], Never> {
        postSubjectInternal
            .handleEvents(receiveOutput: { [weak self] in self?.postSubject.send($0) })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    

    private var searchCursor = SocialCursor()
    private var defaultCursor = SocialCursor()

    private let publishQueue = DispatchQueue(label: "social.repo.publish", qos: .userInitiated)

    // MARK: Init
    public init(socialService: SocialService, awsService: AwsService) {
        self.socialService = socialService
        self.awsService = awsService
    }

    // MARK: Mode
    public func setModeDefault() {
        Task { await store.setMode(.default) }
    }

    public func setModeSearch(_ keyword: String) {
        Task { await store.setMode(.search(keyword: keyword)) }
    }

    // MARK: Fetch Default
    public func fetchPostList(cursor: Int?, limit: Int = 20, category: [PostCategory]?) async throws {
        let categoryIDs: [Int]? = category?.map(\.rawValue)
        let dto = try await socialService.requestPosts(cursor: cursor, limit: limit, categoryIDs: categoryIDs)
        let posts = dto.results.compactMap { $0.convertToPost() }

        if cursor == nil {
            await store.replaceAll(with: posts)
        } else {
            await store.appendDedup(posts)
        }
        await publishSnapshot()
        defaultCursor.update(with: (dto.hasMore, dto.nextCursor))
    }

    // MARK: Fetch Search
    public func searchPost(keyword: String, cursor: Int?, limit: Int, category: [PostCategory]?) async throws {
        let categoryIDs: [Int]? = category?.map(\.rawValue)
        let dto = try await socialService.requestSearchPosts(cursor: cursor, limit: limit, keyword: keyword, categoryIDs: categoryIDs)
        let posts = dto.results.compactMap { $0.convertToPost() }

        if cursor == nil {
            await store.replaceAll(with: posts)
        } else {
            await store.appendDedup(posts)
        }
        await publishSnapshot()
        searchCursor.update(with: (dto.hasMore, dto.nextCursor))
    }

    // MARK: Mutations

    public func togglePostLike(postID: Post.ID, currentLike: Bool) async throws {
        let rollback = await optimisticToggleLike(postID: postID, currentLike: currentLike)
        do {
            if currentLike {
                try await socialService.requestUnlikePost(postID: postID)
            } else {
                try await socialService.requestLikePost(postID: postID)
            }
        } catch {
            await rollback()
            throw error
        }
    }
    
    public func createPost(post: Post, image: [(fileName: String, imageData: Data)]?) async throws -> Int {
        var imageUrls: [String] = []
        if let image {
            for (fileName, imageData) in image {
                let urls = try await awsService.requestPresignedUrl(fileName: fileName)
                try await awsService.requestUploadImage(url: urls.presignedUrl, data: imageData)
                imageUrls.append(urls.fileUrl.absoluteString)
            }
        }

        let requestDTO = TDPostCreateRequestDTO(
            title: post.titleText,
            content: post.contentText,
            routineId: post.routine?.id,
            isAnonymous: false,
            socialCategoryIds: post.category?.compactMap(\.rawValue) ?? [],
            socialImageUrls: imageUrls
        )
        let response = try await socialService.requestCreatePost(requestDTO: requestDTO)
        try await fetchPostList(cursor: nil, limit: 20, category: nil)
        return response.socialId
    }

    public func updatePost(prevPost: Post, updatePost: Post, image: [(fileName: String, imageData: Data)]?) async throws {
        let isChangeTitle = prevPost.titleText != updatePost.titleText
        let isChangeRoutine = prevPost.routine?.id != updatePost.routine?.id
        let isChangeContent = prevPost.contentText != updatePost.contentText
        let isChangeCategory = prevPost.category != updatePost.category
        let isChangeImage = image != nil

        var imageUrls: [String] = []
        if isChangeImage, let image {
            for (fileName, imageData) in image {
                let urls = try await awsService.requestPresignedUrl(fileName: fileName)
                try await awsService.requestUploadImage(url: urls.presignedUrl, data: imageData)
                imageUrls.append(urls.fileUrl.absoluteString)
            }
        }

        let requestDTO = TDPostUpdateRequestDTO(
            id: prevPost.id,
            isChangeTitle: isChangeTitle,
            title: isChangeTitle ? updatePost.titleText : nil,
            isChangeRoutine: isChangeRoutine,
            routineId: isChangeRoutine ? updatePost.routine?.id : nil,
            content: isChangeContent ? updatePost.contentText : nil,
            isAnonymous: false,
            socialCategoryIds: isChangeCategory ? updatePost.category?.compactMap(\.rawValue) ?? [] : nil,
            socialImageUrls: isChangeImage ? imageUrls : nil
        )

        let rollback = await optimisticReplace(updatePost)

        do {
            try await socialService.requestUpdatePost(requestDTO: requestDTO)
        } catch {
            await rollback()
            throw error
        }
    }

    public func deletePost(postID: Post.ID) async throws {
        let snap = await store.snapshot()
        await store.removeEverywhere(id: postID)
        await publishSnapshot()
        do { try await socialService.requestDeletePost(postID: postID) }
        catch { await store.restore(defaultPosts: snap.default, searchPosts: snap.search); await publishSnapshot(); throw error }
    }

    public func fetchPost(postID: Post.ID) async throws -> (Post, [Comment]) {
        let dto = try await socialService.requestPost(postID: postID)
        var post = dto.convertToPost()
        let comments = dto.convertToComment()
        post.commentCount = comments.count

        await store.insertOrReplaceEverywhere(post)
        await publishSnapshot()
        return (post, comments)
    }


    public func reportPost(postID: Post.ID, reportType: ReportType, reason: String?, blockAuthor: Bool) async throws {
        try await socialService.requestReportPost(postID: postID, reportType: reportType.rawValue, reason: reason, blockAuthor: blockAuthor)
    }

    public func toggleCommentLike(postID: Post.ID, commentID: Comment.ID, currentLike: Bool) async throws {
        if currentLike {
            try await socialService.requestUnlikeComment(postID: postID, commentID: commentID)
        } else {
            try await socialService.requestLikeComment(postID: postID, commentID: commentID)
        }
    }

    public func createComment(
        postID: Post.ID,
        parentId: Comment.ID?,
        content: String,
        image: (fileName: String, imageData: Data)?
    ) async throws -> Comment.ID {
        let rollback = await optimisticAdjustCommentCount(postID: postID, delta: +1)

        do {
            var imageUrls: String?
            if let image {
                let urls = try await awsService.requestPresignedUrl(fileName: image.fileName)
                try await awsService.requestUploadImage(url: urls.presignedUrl, data: image.imageData)
                imageUrls = urls.fileUrl.absoluteString
            }

            let newID = try await socialService.requestCreateComment(
                socialId: postID,
                content: content,
                parentId: parentId,
                imageUrl: imageUrls
            )

            return newID
        } catch {
            await rollback()
            throw error
        }
    }

    public func updateComment(comment: Comment) async throws -> Bool {
        false
    }

    public func deleteComment(postID: Post.ID, commentID: Comment.ID) async throws {
        let rollback = await optimisticAdjustCommentCount(postID: postID, delta: -1)

        do {
            try await socialService.requestRemoveComment(postID: postID, commentID: commentID)
        } catch {
            await rollback()
            throw error
        }
    }


    public func reportComment(postID: Post.ID, commentID: Comment.ID, reportType: ReportType, reason: String?, blockAuthor: Bool) async throws {
        try await socialService.requestReportComment(postID: postID, commentID: commentID, reportType: reportType.rawValue, reason: reason, blockAuthor: blockAuthor)
    }
}

// MARK: Helpers
extension SocialRepositoryImp {
    private func publishSnapshot() async {
        let posts = await store.current()
        publishQueue.async { [postSubjectInternal] in
            postSubjectInternal.send(posts)
        }
    }

    private func optimisticToggleLike(postID: Post.ID, currentLike: Bool) async -> () async -> Void {
        let snap = await store.snapshot()
        await store.mutateEverywhere(id: postID) { var p = $0; p.toggleLike(); return p }
        await publishSnapshot()
        return { [weak self] in guard let self else { return }
            await self.store.restore(defaultPosts: snap.default, searchPosts: snap.search)
            await self.publishSnapshot()
        }
    }

    private func optimisticReplace(_ newPost: Post) async -> () async -> Void {
        let snap = await store.snapshot()
        await store.insertOrReplaceEverywhere(newPost)
        await publishSnapshot()
        return { [weak self] in guard let self else { return }
            await self.store.restore(defaultPosts: snap.default, searchPosts: snap.search)
            await self.publishSnapshot()
        }
    }
    
    private func optimisticAdjustCommentCount(postID: Post.ID, delta: Int) async -> () async -> Void {
        let snap = await store.snapshot()
        await store.adjustCommentCountEverywhere(postID: postID, by: delta)
        await publishSnapshot()
        return { [weak self] in
            guard let self else { return }
            await self.store.restore(defaultPosts: snap.default, searchPosts: snap.search)
            await self.publishSnapshot()
        }
    }
}
extension SocialRepositoryImp {
    
    public func refresh(limit: Int = 20, category: [PostCategory]? = nil) async throws {
        await store.setMode(.default)
        defaultCursor.reset()
        try await fetchPostList(cursor: nil, limit: limit, category: category)
    }

    public func startSearch(keyword: String, limit: Int = 20, category: [PostCategory]? = nil) async throws {
        await store.setMode(.search(keyword: keyword))
        searchCursor.reset()
        try await searchPost(keyword: keyword, cursor: nil, limit: limit, category: category)
    }

    public func loadMore(limit: Int = 20, category: [PostCategory]? = nil) async throws {
        let mode = await currentMode()

        switch mode {
        case .default:
            guard defaultCursor.hasMore else { return }
            let cursor = defaultCursor.nextCursor
            let categoryIDs: [Int]? = category?.map(\.rawValue)
            let dto = try await socialService.requestPosts(cursor: cursor, limit: limit, categoryIDs: categoryIDs)
            let posts = dto.results.compactMap { $0.convertToPost() }
            await store.appendDedup(posts)
            await publishSnapshot()
            defaultCursor.update(with: (dto.hasMore, dto.nextCursor))

        case .search(let keyword):
            guard searchCursor.hasMore else { return }
            let cursor = searchCursor.nextCursor
            let categoryIDs: [Int]? = category?.map(\.rawValue)
            let dto = try await socialService.requestSearchPosts(cursor: cursor, limit: limit, keyword: keyword, categoryIDs: categoryIDs)
            let posts = dto.results.compactMap { $0.convertToPost() }
            await store.appendDedup(posts)
            await publishSnapshot()
            searchCursor.update(with: (dto.hasMore, dto.nextCursor))
        }
    }

    private func currentMode() async -> PostStore.Mode {
        await withUnsafeContinuation { cont in
            Task { @MainActor in
                cont.resume(returning: await _currentMode())
            }
        }
    }

    private func _currentMode() async -> PostStore.Mode {
        await store.modeValue()
    }
    
    public func currentPosts() async -> [Post] { await store.current() }
}

