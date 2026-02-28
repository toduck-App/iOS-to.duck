import Foundation

public enum DeepLinkType {
    case profile(userId: String)
    case post(postId: String, commentId: String?)
    case createPost
    case todo
    case diary
    case home
    case notification
    case qrWebLogin(sessionToken: String)

    public init?(url: URL) {
        guard url.scheme == "toduck" else { return nil }

        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let queryItems = components?.queryItems
        func queryValue(for name: String) -> String? {
            return queryItems?.first(where: { $0.name == name })?.value
        }

        switch url.host {
        case "profile":
            guard let userId = queryValue(for: "userId") else { return nil }
            self = .profile(userId: userId)

        case "post":
            guard let postId = queryValue(for: "postId") else { return nil }
            let commentId = queryValue(for: "commentId")
            self = .post(postId: postId, commentId: commentId)

        case "createPost":
            self = .createPost

        case "todo":
            self = .todo

        case "diary":
            self = .diary

        case "home":
            self = .home

        case "notification":
            self = .notification

        case "qrWebLogin":
            guard let sessionToken = queryValue(for: "sessionToken") else { return nil }
            self = .qrWebLogin(sessionToken: sessionToken)

        default:
            return nil
        }
    }
}
