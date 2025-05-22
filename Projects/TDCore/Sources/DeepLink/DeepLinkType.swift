import Foundation

public enum DeepLinkType {
    case profile(userId: String)
    case post(postId: String, commentId: String?)
    case todo
    case diary
    case home
    case notification
    
    public init?(url: URL) {
        guard url.scheme == "toduck" else { return nil }
        
        switch url.host {
        case "profile":
            guard let userId = url.queryParameters?["userId"] else { return nil }
            self = .profile(userId: userId)
            
        case "post":
            guard let postId = url.queryParameters?["postId"] else { return nil }
            let commentId = url.queryParameters?["commentId"]
            self = .post(postId: postId, commentId: commentId)
            
        case "todo":
            self = .todo
            
        case "diary":
            self = .diary
            
        case "home":
            self = .home
            
        case "notification":
            self = .notification
            
        default:
            return nil
        }
    }
}
