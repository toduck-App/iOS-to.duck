import UIKit

protocol SocialPostDelegate: AnyObject {
    func didTapLikeButton(_ cell: UICollectionViewCell)
    func didTapNicknameLabel(_ cell: UICollectionViewCell)
    func didTapRoutineView(_ cell: UICollectionViewCell)
    func didTapReport(_ cell: UICollectionViewCell)
    func didTapBlock(_ cell: UICollectionViewCell)
}

private extension SocialPostDelegate {
    func didTapLikeButton(_ cell: UICollectionViewCell) {}
    func didTapNicknameLabel(_ cell: UICollectionViewCell) {}
    func didTapRoutineView(_ cell: UICollectionViewCell) {}
    func didTapReport(_ cell: UICollectionViewCell) {}
    func didTapBlock(_ cell: UICollectionViewCell) {}
}
