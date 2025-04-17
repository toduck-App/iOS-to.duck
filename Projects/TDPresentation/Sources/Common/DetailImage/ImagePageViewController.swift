import UIKit

final class ImagePageViewController: UIViewController {
    let imageUrl: String
    let index: Int
    private let imageView = UIImageView()
    
    init(imageUrl: String, index: Int) {
        self.imageUrl = imageUrl
        self.index = index
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        imageView.kf.setImage(with: URL(string: imageUrl))
        
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
