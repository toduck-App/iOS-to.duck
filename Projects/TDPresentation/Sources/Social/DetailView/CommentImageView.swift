import TDDesign
import UIKit

final class CommentImageView: UIView {
    var onRemove: (() -> Void)?
    
    private let label = TDLabel(labelText: "사진", toduckFont: .mediumBody3, toduckColor: TDColor.Neutral.neutral600)
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 4
        $0.layer.masksToBounds = true
    }
    
    private let circleView = UIButton().then {
        $0.layer.cornerRadius = 7
        $0.backgroundColor = TDColor.baseBlack
        $0.setImage(TDImage.X.x2Medium.withRenderingMode(.alwaysOriginal).withTintColor(.white), for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
        circleView.addTarget(self, action: #selector(removeTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = TDColor.Neutral.neutral200
        addSubview(label)
        addSubview(imageView)
        addSubview(circleView)
    }
    
    private func setupLayout() {
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-18)
        }
        
        imageView.snp.makeConstraints { make in
            make.size.equalTo(90)
            make.top.equalTo(label.snp.bottom).offset(8)
            make.bottom.equalToSuperview().offset(-10)
            make.leading.equalToSuperview().offset(20)
        }
        
        circleView.snp.makeConstraints { make in
            make.size.equalTo(14)
            make.trailing.equalTo(imageView.snp.trailing).offset(-8)
            make.top.equalTo(imageView.snp.top).offset(8)
        }
    }
    
    @objc private func removeTapped() {
        onRemove?()
    }
    
    func configure(with data: Data) {
        imageView.image = UIImage(data: data)
    }
}
