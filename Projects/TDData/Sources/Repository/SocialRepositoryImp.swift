import Foundation
@preconcurrency import Combine
import TDCore
@preconcurrency import TDDomain

public final class SocialRepositoryImp: SocialRepository {

    // MARK: - 의존성 주입
    private let socialService: SocialService
    private let awsService: AwsService

    // MARK: - 상태 관리 (SSOT)
    private let store = PostCache()
    private let postSubject = CurrentValueSubject<[Post], Never>([])
    private let publishQueue = DispatchQueue(label: "social.repo.publish", qos: .userInitiated)

    public var postPublisher: AnyPublisher<[Post], Never> {
        postSubject
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    private var defaultCursor = SocialCursor()
    private var searchCursor = SocialCursor()

    // MARK: - 초기화
    public init(
        socialService: SocialService,
        awsService: AwsService
    ) {
        self.socialService = socialService
        self.awsService = awsService
    }

    // MARK: - 모드 관리
    public func setModeDefault() {
        Task { await store.setMode(.default) }
    }

    public func setModeSearch(_ keyword: String) {
        Task { await store.setMode(.search(keyword: keyword)) }
    }

    // MARK: - 게시글 조회

    /// 기본 피드(홈 피드) 게시글을 요청합니다.
    public func fetchPostList(
        cursor: Int? = nil,
        limit: Int = 20,
        category: [PostCategory]? = nil
    ) async throws {
        let categoryIDs = category?.map(\.rawValue)
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

    /// 검색 결과 게시글을 요청합니다.
    public func searchPost(
        keyword: String,
        cursor: Int? = nil,
        limit: Int = 20,
        category: [PostCategory]? = nil
    ) async throws {
        let categoryIDs = category?.map(\.rawValue)
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

    // MARK: - 게시글 생성 / 수정 / 삭제

    /// 게시글 좋아요를 토글합니다. (Optimistic UI 반영)
    public func togglePostLike(
        postID: Post.ID,
        currentLike: Bool
    ) async throws {
        let rollback = await performOptimisticLikeToggle(postID: postID, isLiked: currentLike)
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

    /// 게시글을 생성합니다.
    public func createPost(
        post: Post,
        image: [(fileName: String, imageData: Data)]?
    ) async throws -> Int {
        var imageUrls: [String] = []
        if let image {
            for (fileName, data) in image {
                let urls = try await awsService.requestPresignedUrl(fileName: fileName)
                try await awsService.requestUploadImage(url: urls.presignedUrl, data: data)
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

    /// 게시글을 업데이트합니다.
    public func updatePost(
        prevPost: Post,
        updatePost: Post,
        image: [(fileName: String, imageData: Data)]?
    ) async throws {
        let isChangeTitle = prevPost.titleText != updatePost.titleText
        let isChangeRoutine = prevPost.routine?.id != updatePost.routine?.id
        let isChangeContent = prevPost.contentText != updatePost.contentText
        let isChangeCategory = prevPost.category != updatePost.category
        let isChangeImage = image != nil

        var imageUrls: [String] = []
        var updatePost = updatePost
        if isChangeImage, let image {
            for (fileName, data) in image {
                let urls = try await awsService.requestPresignedUrl(fileName: fileName)
                try await awsService.requestUploadImage(url: urls.presignedUrl, data: data)
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
        updatePost.setImage(imagesURL: imageUrls)

        let rollback = await performOptimisticReplace(updatePost)
        do {
            try await socialService.requestUpdatePost(requestDTO: requestDTO)
        } catch {
            await rollback()
            throw error
        }
    }

    /// 게시글을 삭제합니다.
    public func deletePost(
        postID: Post.ID
    ) async throws {
        let snap = await store.snapshot()
        await store.removeEverywhere(postID)
        await publishSnapshot()
        do {
            try await socialService.requestDeletePost(postID: postID)
        } catch {
            await store.restore(snap)
            await publishSnapshot()
            throw error
        }
    }

    /// 단일 게시글을 불러옵니다. (댓글 포함)
    public func fetchPost(
        postID: Post.ID
    ) async throws -> (Post, [Comment]) {
        let dto = try await socialService.requestPost(postID: postID)
        let post = dto.convertToPost()
        let comments = dto.convertToComment()

        await store.replaceEveryWhere(post)
        await publishSnapshot()
        return (post, comments)
    }

    // MARK: - 댓글 처리

    public func toggleCommentLike(
        postID: Post.ID,
        commentID: Comment.ID,
        currentLike: Bool
    ) async throws {
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
        let rollback = await performOptimisticCommentAdjust(postID: postID, delta: +1)
        do {
            var imageUrl: String?
            if let image {
                let urls = try await awsService.requestPresignedUrl(fileName: image.fileName)
                try await awsService.requestUploadImage(url: urls.presignedUrl, data: image.imageData)
                imageUrl = urls.fileUrl.absoluteString
            }

            let newID = try await socialService.requestCreateComment(
                socialId: postID,
                content: content,
                parentId: parentId,
                imageUrl: imageUrl
            )
            return newID
        } catch {
            await rollback()
            throw error
        }
    }

    public func deleteComment(
        postID: Post.ID,
        commentID: Comment.ID
    ) async throws {
        let rollback = await performOptimisticCommentAdjust(postID: postID, delta: -1)
        do {
            try await socialService.requestRemoveComment(postID: postID, commentID: commentID)
        } catch {
            await rollback()
            throw error
        }
    }
    
    public func reportPost(
        postID: Post.ID,
        reportType: ReportType,
        reason: String?,
        blockAuthor: Bool
    ) async throws {
        try await socialService.requestReportPost(postID: postID, reportType: reportType.rawValue, reason: reason, blockAuthor: blockAuthor)
    }
    
    public func reportComment(
        postID: Post.ID,
        commentID: Comment.ID,
        reportType: ReportType,
        reason: String?,
        blockAuthor: Bool
    ) async throws {
        try await socialService.requestReportComment(postID: postID, commentID: commentID, reportType: reportType.rawValue, reason: reason, blockAuthor: blockAuthor)
    }

    // MARK: - 스냅샷 퍼블리시
    private func publishSnapshot() async {
        let posts = await store.current()
        let subject = postSubject
        publishQueue.async {
            subject.send(posts)
        }
    }
}

// MARK: - Optimistic Helper
private extension SocialRepositoryImp {
    func performOptimisticLikeToggle(postID: Post.ID, isLiked: Bool) async -> () async -> Void {
        let snapshot = await store.snapshot()
        await store.updateEverywhere(postID) { var p = $0; p.toggleLike(); return p }
        await publishSnapshot()
        return { [weak self] in
            guard let self else { return }
            await self.store.restore(snapshot)
            await self.publishSnapshot()
        }
    }

    func performOptimisticReplace(_ newPost: Post) async -> () async -> Void {
        let snapshot = await store.snapshot()
        await store.replaceEveryWhere(newPost)
        await publishSnapshot()
        return { [weak self] in
            guard let self else { return }
            await self.store.restore(snapshot)
            await self.publishSnapshot()
        }
    }

    func performOptimisticCommentAdjust(postID: Post.ID, delta: Int) async -> () async -> Void {
        let snapshot = await store.snapshot()
        await store.adjustCommentCount(postID, by: delta)
        await publishSnapshot()
        return { [weak self] in
            guard let self else { return }
            await self.store.restore(snapshot)
            await self.publishSnapshot()
        }
    }
}

// MARK: - Pagination 관련
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
        let mode = await store.currentMode()
        switch mode {
        case .default:
            guard defaultCursor.hasMore else { return }
            try await fetchPostList(cursor: defaultCursor.nextCursor, limit: limit, category: category)
        case .search(let keyword):
            guard searchCursor.hasMore else { return }
            try await searchPost(keyword: keyword, cursor: searchCursor.nextCursor, limit: limit, category: category)
        }
    }

    /// 현재 게시글 목록을 반환합니다.
    public func currentPosts() async -> [Post] {
        await store.current()
    }
}

