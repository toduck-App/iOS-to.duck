extension SocialViewModel {
    enum Action {
        case fetchPosts
        case likePost(at: Int)
    }
    
    enum FetchState {
        case loading
        case finish(post: [Post])
        case empty
        case error
    }
    
    enum LikeState {
        case finish(post: Post)
        case error
    }
}
