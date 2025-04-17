import Kingfisher
import SnapKit
import TDDesign
import Then
import UIKit

// MARK: - SocialImageListView

final class SocialImageListView: UIView {
    // MARK: LayoutStyle Enum

    enum LayoutStyle {
        case scroll
        case regular(maxImagesToShow: Int)
    }
    
    // MARK: Properties

    private var images: [String]
    private var layoutStyle: LayoutStyle
    private var containerStackView: UIStackView!
    
    // MARK: Initializer

    init(style: LayoutStyle, images: [String]) {
        self.layoutStyle = style
        self.images = images
        super.init(frame: .zero)
        if images.isEmpty {
            self.isHidden = true
        } else {
            self.isHidden = false
            setupUI()
            addImages()
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI Setup & 이미지 추가

private extension SocialImageListView {
    func setupUI() {
        switch layoutStyle {
        case .regular:
            containerStackView = UIStackView().then {
                $0.axis = .horizontal
                $0.alignment = .leading
                $0.spacing = 4
                $0.distribution = .equalSpacing
            }
            addSubview(containerStackView)
            containerStackView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
        case .scroll:
            let scrollView = UIScrollView().then {
                $0.showsHorizontalScrollIndicator = false
            }
            addSubview(scrollView)
            scrollView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            containerStackView = UIStackView().then {
                $0.axis = .horizontal
                $0.alignment = .center
                $0.spacing = 4
            }
            scrollView.addSubview(containerStackView)
            containerStackView.snp.makeConstraints { make in
                make.edges.equalTo(scrollView.contentLayoutGuide)
                make.height.equalTo(scrollView.frameLayoutGuide)
            }
        }
    }
    
    func addImages() {
        switch layoutStyle {
        case .regular(let maxImagesToShow):
            var displayedImages = images.prefix(maxImagesToShow)
            if displayedImages.count < maxImagesToShow {
                displayedImages.append(contentsOf: Array(repeating: "", count: maxImagesToShow - displayedImages.count))
            }
            
            for imageURL in displayedImages {
                let imageView = UIImageView().then {
                    $0.contentMode = .scaleAspectFill
                    $0.clipsToBounds = true
                    $0.layer.cornerRadius = 4
                }
                imageView.kf.setImage(with: URL(string: imageURL))
                containerStackView.addArrangedSubview(imageView)
                imageView.snp.makeConstraints { make in
                    make.size.equalTo(self.snp.width).inset(2).dividedBy(maxImagesToShow)
                }
            }
            
            if images.count > maxImagesToShow, let lastImageView = containerStackView.arrangedSubviews.last {
                let extraCountLabel = TDLabel(toduckFont: .mediumBody2, alignment: .center, toduckColor: TDColor.baseWhite).then {
                    $0.backgroundColor = TDColor.baseBlack.withAlphaComponent(0.3)
                    $0.setText("+\(images.count - maxImagesToShow)")
                }
                lastImageView.addSubview(extraCountLabel)
                extraCountLabel.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
            }
            
        case .scroll:
            for (index, imageURL) in images.enumerated() {
                let imageView = UIImageView().then {
                    $0.contentMode = .scaleAspectFill
                    $0.clipsToBounds = true
                    $0.layer.cornerRadius = 4
                }
                imageView.kf.setImage(with: URL(string: imageURL))
                imageView.tag = index
                imageView.isUserInteractionEnabled = true
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleImageTap(_:)))
                imageView.addGestureRecognizer(tapGesture)
                
                containerStackView.addArrangedSubview(imageView)
                imageView.snp.makeConstraints { make in
                    let dividedAmount = images.count < 3 ? 2.0 : 1.9
                    make.size.equalTo(self.snp.width).inset(10).dividedBy(dividedAmount)
                }
            }
        }
    }
    
    @objc func handleImageTap(_ sender: UITapGestureRecognizer) {
        guard let tappedView = sender.view else { return }
        let index = tappedView.tag
        
        let detailVC = DetailImageViewController(imageUrlList: images, selectedIndex: index)
        if let parentVC = findViewController() {
            parentVC.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}
