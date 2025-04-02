import Foundation
import TDCore
import TDDomain

public final class PostRepositoryImpl: PostRepository {
    private let dummyRoutine = Routine(
        id: nil,
        title: "123",
        category: TDCategory(
            colorHex: "#123456",
            imageName: "computer"
        ),
        isAllDay: false,
        isPublic: true,
        time: nil,
        repeatDays: nil,
        alarmTime: nil,
        memo: nil,
        recommendedRoutines: nil,
        isFinished: false
    )
    private var dummyPost = Post.dummy

    private let socialService: SocialService
    private let awsService: AwsService
    private let cachePost: [Post] = []

    public init(socialService: SocialService, awsService: AwsService) {
        self.socialService = socialService
        self.awsService = awsService
    }

    public func fetchPostList(cursor: Int?, limit: Int = 20, category: [PostCategory]?) async throws -> (result: [Post], hasMore: Bool, nextCursor: Int?) {
        let categoryIDs: [Int]? = category?.map(\.rawValue)
        let postListDTO = try await socialService.requestPosts(cursor: cursor, limit: limit, categoryIDs: categoryIDs)
        let postList = postListDTO.results.compactMap { $0.convertToEntity(category: category) }

        return (postList, postListDTO.hasMore, postListDTO.nextCursor)
    }

    public func searchPost(keyword: String, cursor: Int?, limit: Int, category: [PostCategory]?) async throws -> (result: [Post], hasMore: Bool, nextCursor: Int?) {
        let categoryIDs: [Int]? = category?.map(\.rawValue)
        let postListDTO = try await socialService.requestSearchPosts(cursor: cursor, limit: limit, keyword: keyword)
        let postList = postListDTO.results.compactMap { $0.convertToEntity(category: category) }
        return (postList, postListDTO.hasMore, postListDTO.nextCursor)
        // TODO: 카테고리 필터 필요
    }

    public func togglePostLike(postID: Post.ID, currentLike: Bool) async throws {
        if currentLike {
            try await socialService.requestUnlikePost(postID: postID)
        } else {
            try await socialService.requestLikePost(postID: postID)
        }
    }

    public func bringUserRoutine(routine: Routine) async throws -> Routine {
        dummyRoutine
    }

    public func createPost(post: Post, image: [(fileName: String, imageData: Data)]?) async throws {
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
        try await socialService.requestCreatePost(requestDTO: requestDTO)
    }

    public func updatePost(post: Post) async throws {}

    public func deletePost(postID: Post.ID) async throws {
        try await socialService.requestDeletePost(postID: postID)
    }

    public func fetchPost(postID: Post.ID) async throws -> Post {
        let postDTO = try await socialService.requestPost(postID: postID)
        let post = postDTO.convertToEntity()

        return post
    }

    public func reportPost(postID: Post.ID) async throws {}

    public func blockPost(postID: Post.ID) async throws {}
}
