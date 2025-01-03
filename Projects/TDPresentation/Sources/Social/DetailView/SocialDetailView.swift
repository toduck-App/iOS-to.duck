import SnapKit
import TDDesign
import UIKit

final class SocialDetailView: BaseView, UITextViewDelegate {
    private(set) lazy var detailCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: makeCollectionViewLayout()
    ).then {
        $0.backgroundColor = TDColor.baseWhite
    }

    private let bottomContainerView = UIView().then {
        $0.backgroundColor = TDColor.baseWhite
        $0.layer.cornerRadius = 14
        $0.layer.shadowOffset = CGSize(width: 0, height: -2)
        $0.layer.shadowColor = TDColor.Neutral.neutral200.cgColor
        $0.layer.shadowOpacity = 1
        $0.layer.shadowRadius = 14
    }

    private let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 18
        $0.image = TDImage.Profile.medium
    }

    private let commentTextView = UITextView().then {
        $0.backgroundColor = TDColor.baseWhite
        $0.text = ""
        $0.textColor = TDColor.Neutral.neutral900
        $0.font = TDFont.mediumBody2.font
        $0.isScrollEnabled = false
        $0.textContainerInset = UIEdgeInsets(top: 11, left: 16, bottom: 11, right: 0)
        $0.layer.masksToBounds = true
    }

    private let placeholderLabel = UILabel().then {
        $0.text = "댓글을 남겨주세요"
        $0.textColor = TDColor.Neutral.neutral500
        $0.font = TDFont.mediumBody2.font
    }

    override func addview() {
        addSubview(detailCollectionView)
        addSubview(bottomContainerView)
        bottomContainerView.addSubview(profileImageView)
        bottomContainerView.addSubview(commentTextView)
        commentTextView.addSubview(placeholderLabel)
    }

    override func configure() {
        backgroundColor = TDColor.baseWhite
        detailCollectionView.register(with: SocialDetailPostCell.self)
        detailCollectionView.register(with: SocialDetailCommentCell.self)

        commentTextView.delegate = self
    }

    override func layout() {
        detailCollectionView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(bottomContainerView.snp.top)
        }

        bottomContainerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(56)
        }

        profileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(36)
        }

        commentTextView.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing)
            make.trailing.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
        }

        placeholderLabel.snp.makeConstraints { make in
            make.top.equalTo(commentTextView).inset(commentTextView.textContainerInset.top)
            make.leading.equalTo(commentTextView).inset(commentTextView.textContainerInset.left)
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}

private extension SocialDetailView {
    func makeCollectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(1.0)
        )
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(1.0)
        )

        return UICollectionViewCompositionalLayout.makeVerticalCompositionalLayout(
            itemSize: itemSize,
            groupSize: groupSize
        )
    }
}
