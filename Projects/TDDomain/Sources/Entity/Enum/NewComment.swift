import Foundation

public enum CommentTarget {
    case post(Post.ID)
    case comment(Comment.ID)
}

public struct NewComment {
    public let content: String
    public let target: CommentTarget
    public let image: Data?
    
    public init(content: String, target: CommentTarget, image: Data?) {
        self.content = content
        self.target = target
        self.image = image
    }
}

