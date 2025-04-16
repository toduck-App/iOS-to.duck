import SnapKit
import TDDesign
import Then
import UIKit

final class SocialDetailView: BaseView, UITextViewDelegate {
    private(set) lazy var detailCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: makeCollectionViewLayout()
    ).then {
        $0.backgroundColor = TDColor.Neutral.neutral200
        $0.bounces = false
        $0.isUserInteractionEnabled = true
        $0.contentInsetAdjustmentBehavior = .never
        $0.keyboardDismissMode = .onDrag
    }
    
    let commentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fill
        $0.spacing = 0
    }
    
    let commentImageView = CommentImageView()
    let commentReplyView = CommentReplyForm()
    let commentInputForm = CommentInputForm()
    var commentInputFormBottomConstraint: Constraint?
    
    override func addview() {
        addSubview(detailCollectionView)
        addSubview(commentStackView)
        
        commentStackView.addArrangedSubview(commentImageView)
        commentStackView.addArrangedSubview(commentReplyView)
        commentStackView.addArrangedSubview(commentInputForm)
        
        commentImageView.isHidden = true
        commentReplyView.isHidden = true
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    override func configure() {
        backgroundColor = TDColor.baseWhite
        detailCollectionView.register(with: SocialDetailPostCell.self)
        detailCollectionView.register(with: SocialDetailCommentCell.self)
    }
    
    override func layout() {
        detailCollectionView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(commentInputForm.snp.top)
        }
        
        commentStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            commentInputFormBottomConstraint = make.bottom.equalToSuperview().offset(-20).constraint
        }
        
        commentReplyView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(48)
        }
        
        commentImageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(142)
        }
    }
    
    func showCommentInputImage(with data: Data) {
        commentImageView.configure(with: data)
        commentImageView.isHidden = false
    }
    
    func removeCommentInputImage() {
        commentImageView.isHidden = true
    }
    
    func showReplyInputForm(name: String) {
        if !commentReplyView.isHidden {
            removeReplyInputForm()
        }
        commentReplyView.configure(userName: name)
        commentReplyView.isHidden = false
    }
    
    func removeReplyInputForm() {
        commentReplyView.isHidden = true
    }
    
    func clearText() {
        commentInputForm.clearText()
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
              let curveValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else { return }
        let options = UIView.AnimationOptions(rawValue: curveValue << 16)
        let keyboardHeight = keyboardFrame.height
        commentInputFormBottomConstraint?.update(offset: -keyboardHeight)
        UIView.animate(withDuration: duration, delay: 0, options: options) {
            self.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
              let curveValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else { return }
        let options = UIView.AnimationOptions(rawValue: curveValue << 16)
        commentInputFormBottomConstraint?.update(offset: -20)
        UIView.animate(withDuration: duration, delay: 0, options: options) {
            self.layoutIfNeeded()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func makeCollectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(1))
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(1))
        let groupEdge = NSCollectionLayoutEdgeSpacing(leading: .fixed(0),
                                                      top: .fixed(0),
                                                      trailing: .fixed(0),
                                                      bottom: .fixed(8))
        
        return UICollectionViewCompositionalLayout.makeVerticalCompositionalLayout(itemSize: itemSize,
                                                                                  groupSize: groupSize,
                                                                                   groupEdgeSpacing: groupEdge)
    }
}
