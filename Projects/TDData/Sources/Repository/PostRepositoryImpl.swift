import TDDomain
import Foundation

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
        date: Date(),
        time: nil,
        repeatDays: nil,
        alarmTime: nil,
        memo: nil,
        recommendedRoutines: nil,
        isFinished: false
    )
    private let dummyUser = User(id: UUID(), name: "", icon: "", title: "", isblock: false)
    private var dummyPost = Post.dummy
    
    private let socialService: SocialService
    private let awsService: AwsService

    public init(socialService: SocialService, awsService: AwsService) {
        self.socialService = socialService
        self.awsService = awsService
    }

    public func fetchPostList(category: PostCategory?) async throws -> [Post] {
        guard let category = category else {
            return dummyPost
        }
        return dummyPost
            .filter { $0.category?.contains(category) ?? false }
    }

    public func searchPost(keyword: String, category: PostCategory?) async throws -> [Post]? {
        guard let category = category else {
            return dummyPost
                .filter { $0.contentText.contains(keyword) }
        }
        return dummyPost
            .filter { $0.contentText.contains(keyword) && $0.category?.contains(category) ?? false }
    }

    public func togglePostLike(postID: Post.ID) async throws -> Result<Post, Error> {
        if let index = dummyPost.firstIndex(where: { $0.id == postID }) {
            dummyPost[index].toggleLike()
            return .success(dummyPost[index])
        }
        //TODO: 실제 리소스에 반영 후 적절한 Error 처리 필요
        return .failure(NSError(domain: "PostRepositoryImpl", code: 0, userInfo: nil))
    }

    public func bringUserRoutine(routine: Routine) async throws -> Routine {
        return dummyRoutine
    }

    public func createPost(post: Post, image: [(fileName: String, imageData: Data)]?) async throws {
        var imageUrls: [String] = []
        if let image = image {
            for (fileName, imageData) in image {
                let url = try await awsService.requestPresignedUrl(fileName: fileName)
                try await awsService.requestUploadImage(url: url, data: imageData)
                imageUrls.append(url.absoluteString)
            }
        }
        
        let requestDTO = TDPostCreateRequestDTO(
            title: post.titleText,
            content: post.contentText,
            routineId: post.routine?.id,
            isAnonymous: false,
            socialCategoryIds: post.category?.compactMap { $0.rawValue } ?? [],
            socialImageUrls: imageUrls
        )
        let responseDTO = try await socialService.requestCreatePost(requestDTO: requestDTO)
    }

    public func updatePost(post: Post) async throws {
        return
    }

    public func deletePost(postID: Post.ID) async throws  {
        return
    }

    public func fetchPost(postID: Post.ID) async throws -> Post {
        let postDTO = try await socialService.requestPost(postID: postID)
//        let post = Post(
//            id: postDTO.socialId,
//            user: User(
//                id: postDTO.owner.ownerID,
//                name: postDTO.owner.nickname,
//                icon: nil,
//                title: "작심삼일",
//                isblock: false
//            ),
//            contentText: postDTO.content,
//            imageList: postDTO.images.map { $0.url },
//            timestamp: postDTO.createdAt,
//            likeCount: <#T##Int#>,
//            isLike: <#T##Bool#>,
//            commentCount: <#T##Int?#>,
//            shareCount: <#T##Int?#>,
//            routine: <#T##Routine?#>,
//            category: <#T##[PostCategory]?#>
//        )
        
    }

    public func reportPost(postID: Post.ID) async throws {
        return
    }

    public func blockPost(postID: Post.ID) async throws {
        return
    }
}
