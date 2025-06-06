import TDDomain
import UIKit

protocol SocialPostDelegate: AnyObject {
    func didTapProfileImage(_ cell: UICollectionViewCell, _ userID: User.ID)
    
    func didTapLikeButton(_ cell: UICollectionViewCell, _ postID: Post.ID)
    
    func didTapNicknameLabel(_ cell: UICollectionViewCell, _ userID: User.ID)
    
    func didTapRoutineView(_ cell: UICollectionViewCell, _ routine: Routine)
    
    func didTapReport(_ cell: UICollectionViewCell, _ postID: Post.ID)
    
    func didTapReportComment(_ cell: UICollectionViewCell, _ commentID: Comment.ID)
    
    func didTapScrapPost(_ cell: UICollectionViewCell, _ postID: Post.ID)
    
    func didTapSharePost(_ cell: UICollectionViewCell, _ postID: Post.ID)
    
    func didTapBlock(_ cell: UICollectionViewCell, _ userID: User.ID)
    
    func didTapReplyLikeButton(_ cell: UICollectionViewCell, _ commentID: Comment.ID)
    
    func didTapEditPost(_ cell: UICollectionViewCell, _ post: Post)
    
    func didTapEditComment(_ cell: UICollectionViewCell, _ commentID: Comment.ID)
    
    func didTapDeletePost(_ cell: UICollectionViewCell, _ postID: Post.ID)
    
    func didTapDeleteComment(_ cell: UICollectionViewCell, _ commentID: Comment.ID)
}

extension SocialPostDelegate {
    func didTapLikeButton(_ cell: UICollectionViewCell, _ postID: Post.ID) {}
    
    func didTapNicknameLabel(_ cell: UICollectionViewCell, _ userID: User.ID) {}
    
    func didTapRoutineView(_ cell: UICollectionViewCell, _ routine: Routine) {}
    
    func didTapReport(_ cell: UICollectionViewCell, _ postID: Post.ID) {}
    
    func didTapReportComment(_ cell: UICollectionViewCell, _ commentID: Comment.ID) {}
    
    func didTapScrapPost(_ cell: UICollectionViewCell, _ postID: Post.ID) {}
    
    func didTapSharePost(_ cell: UICollectionViewCell, _ postID: Post.ID) {}
    
    func didTapBlock(_ cell: UICollectionViewCell, _ userID: User.ID) {}
    
    func didTapReplyLikeButton(_ cell: UICollectionViewCell, _ commentID: Comment.ID) {}
    
    func didTapEditPost(_ cell: UICollectionViewCell, _ post: Post) {}
    
    func didTapEditComment(_ cell: UICollectionViewCell, _ commentID: Comment.ID) {}
    
    func didTapDeletePost(_ cell: UICollectionViewCell, _ postID: Post.ID) {}
    
    func didTapDeleteComment(_ cell: UICollectionViewCell, _ commentID: Comment.ID) {}
}
