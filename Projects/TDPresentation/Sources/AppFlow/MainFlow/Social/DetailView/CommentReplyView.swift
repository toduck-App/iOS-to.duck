import TDDesign
import UIKit

final class CommentReplyForm: UIView {
    var onRemove: (() -> Void)?
    
    private let removeButton = UIButton().then {
        $0.setImage(TDImage.X.x2Medium, for: .normal)
    }
    
    private let label = TDLabel(toduckFont: .mediumBody3, toduckColor: TDColor.Neutral.neutral600)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
        removeButton.addTarget(self, action: #selector(removeTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = TDColor.Neutral.neutral200
        addSubview(removeButton)
        addSubview(label)
    }
    
    private func setupLayout() {
        removeButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-18)
            make.centerY.equalToSuperview()
            make.size.equalTo(24)
        }
        
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalTo(removeButton.snp.leading).offset(-10)
            make.centerY.equalToSuperview()
        }
    }
    
    @objc private func removeTapped() {
        onRemove?()
    }
    
    func configure(userName: String) {
        label.setText("\(userName)님에게 답글 남기기")
    }
    
    func setAction(_ action: UIAction) {
        removeButton.addAction(action, for: .touchUpInside)
    }
}
