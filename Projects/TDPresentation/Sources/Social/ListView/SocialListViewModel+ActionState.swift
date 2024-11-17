import TDDomain

extension SocialListViewModel {
    enum Action {
        case fetchPosts
        case refreshPosts
        case likePost(at: Int)
        case sortPost(by: SocialSortType)
        case chipSelect(at: Int)
        case segmentSelect(at: Int)
    }
    
    enum FetchState {
        case loading
        case finish(post: [Post])
        case empty
        case error
    }
    
    enum RefreshState {
        case finish(post: [Post])
        case empty
        case error
    }
    
    enum LikeState {
        case finish(post: Post)
        case error
    }
}
