extension SocialViewModel {
    enum Action {
        case fetchPosts
        case likePost(at: Int)
    }
    
    enum FetchState {
        case loading
        case finish
        case empty
        case error
    }
    
    enum LikeState {
        case finish
        case error
    }
}
