import SnapKit
import TDDesign
import Then
import UIKit

final class SocialAddPhotoView: UIView {
    private let title = TDRequiredTitle().then {
        $0.setTitleLabel("사진 첨부")
    }
    
    private let currentCounterLabel = TDLabel(toduckFont: .regularBody2, toduckColor: TDColor.Neutral.neutral800).then {
        $0.setText("0")
    }
    
    private let maxCounterLabel = TDLabel(toduckFont: .regularBody2, toduckColor: TDColor.Neutral.neutral600).then {
        $0.setText("/ 5")
    }
    
    private let addPhotoButton = UIButton().then {
        $0.layer.cornerRadius = 12
        $0.backgroundColor = TDColor.Neutral.neutral100
        let image = TDImage.cameraMedium.withRenderingMode(.alwaysOriginal).withTintColor(TDColor.Neutral.neutral600)
        $0.setImage(image, for: .normal)
        $0.imageView?.contentMode = .scaleAspectFit
    }
    
    private let photoScrollView = UIScrollView().then {
        $0.showsHorizontalScrollIndicator = false
    }
    
    private let photoStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .center
        $0.distribution = .fill
    }

    private let captionLabel = TDLabel(
        labelText: "사진은 10MB 이하의 PNG, GIF, JPG 파일만 등록할 수 있습니다.",
        toduckFont: .regularCaption1,
        toduckColor: TDColor.Neutral.neutral500
    )

    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func addPhoto(imageData: Data) {
        guard let image = UIImage(data: imageData) else {
            // TODO: Error Handling
            return
        }
        
        let imageView = UIImageView(image: image).then {
            $0.layer.cornerRadius = 8
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
        }
        
        let containerView = UIView().then {
            $0.layer.cornerRadius = 8
            $0.layer.borderColor = TDColor.Neutral.neutral300.cgColor
            $0.layer.borderWidth = 1
        }
        containerView.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.size.equalTo(CGSize(width: 88, height: 88))
        }
        
        photoStackView.addArrangedSubview(containerView)
        
        let currentCount = photoStackView.arrangedSubviews.count
        currentCounterLabel.setText("\(currentCount)")
    }
}

extension SocialAddPhotoView {
    private func setLayout() {
        addSubviews()
        setConstraints()
    }
    
    private func addSubviews() {
        addSubview(title)
        addSubview(currentCounterLabel)
        addSubview(maxCounterLabel)
        addSubview(addPhotoButton)
        addSubview(photoScrollView)
        addSubview(captionLabel)
        photoScrollView.addSubview(photoStackView)
    }
    
    private func setConstraints() {
        title.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
        
        maxCounterLabel.snp.makeConstraints { make in
            make.centerY.equalTo(title)
            make.trailing.equalToSuperview()
        }
        
        currentCounterLabel.snp.makeConstraints { make in
            make.centerY.equalTo(maxCounterLabel)
            make.trailing.equalTo(maxCounterLabel.snp.leading).offset(-4)
        }
        
        addPhotoButton.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(12)
            make.leading.equalToSuperview()
            make.size.equalTo(88)
        }

        photoScrollView.snp.makeConstraints { make in
            make.centerY.equalTo(addPhotoButton)
            make.leading.equalTo(addPhotoButton.snp.trailing).offset(12)
            make.trailing.equalToSuperview()
            make.height.equalTo(addPhotoButton)
        }

        photoStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        captionLabel.snp.makeConstraints { make in
            make.top.equalTo(addPhotoButton.snp.bottom).offset(12)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}
