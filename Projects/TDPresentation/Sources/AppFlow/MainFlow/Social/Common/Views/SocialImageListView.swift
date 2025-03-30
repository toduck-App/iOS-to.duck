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

private extension UIView {
    func findViewController() -> UIViewController? {
        var nextResponder: UIResponder? = self
        while nextResponder != nil {
            if let vc = nextResponder as? UIViewController {
                return vc
            }
            nextResponder = nextResponder?.next
        }
        return nil
    }
}

// MARK: - DetailImageViewController

final class DetailImageViewController: BaseViewController<BaseView> {
    private var imageUrlList: [String]
    private var selectedIndex: Int
    
    private lazy var pageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal,
        options: [UIPageViewController.OptionsKey.interPageSpacing: 10]
    ).then {
        $0.delegate = self
        $0.dataSource = self
    }
    
    private let pageControl = UIPageControl().then {
        $0.hidesForSinglePage = true
        $0.currentPageIndicatorTintColor = TDColor.baseBlack
        $0.pageIndicatorTintColor = TDColor.Neutral.neutral600
    }
    
    private lazy var thumbnailCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = 12
        $0.itemSize = CGSize(width: 100, height: 100)
    }).then {
        $0.backgroundColor = .clear
        $0.showsHorizontalScrollIndicator = false
        $0.dataSource = self
        $0.delegate = self
        $0.register(with: DetailImageCell.self)
    }
    
    // MARK: - Initializer

    init(imageUrlList: [String], selectedIndex: Int) {
        self.imageUrlList = imageUrlList
        self.selectedIndex = selectedIndex
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configure()
    }
    
    override func configure() {
        pageControl.numberOfPages = imageUrlList.count
        pageControl.currentPage = selectedIndex
        
        let initialVC = ImagePageViewController(imageUrl: imageUrlList[selectedIndex], index: selectedIndex)
        pageViewController.setViewControllers([initialVC], direction: .forward, animated: false, completion: nil)
    }
    
    private func setupUI() {
        view.backgroundColor = TDColor.Neutral.neutral100
        
        view.addSubview(pageViewController.view)
        pageViewController.view.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(view.snp.width)
        }
        
        view.addSubview(pageControl)
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(pageViewController.view.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(thumbnailCollectionView)
        thumbnailCollectionView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalToSuperview()
            make.height.equalTo(100)
        }
    }
}

// MARK: - UIPageViewController Delegate & DataSource

extension DetailImageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentVC = viewController as? ImagePageViewController,
              currentVC.index > 0 else { return nil }
        return ImagePageViewController(imageUrl: imageUrlList[currentVC.index - 1], index: currentVC.index - 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentVC = viewController as? ImagePageViewController,
              currentVC.index < imageUrlList.count - 1 else { return nil }
        return ImagePageViewController(imageUrl: imageUrlList[currentVC.index + 1], index: currentVC.index + 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool)
    {
        if completed, let currentVC = pageViewController.viewControllers?.first as? ImagePageViewController {
            pageControl.currentPage = currentVC.index
            selectedIndex = currentVC.index
            
            let indexPath = IndexPath(item: selectedIndex, section: 0)
            thumbnailCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            thumbnailCollectionView.reloadData()
        }
    }
}

// MARK: - UICollectionView DataSource & Delegate

extension DetailImageViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imageUrlList.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell: DetailImageCell = collectionView.dequeueReusableCell(for: indexPath)
        let isSelected = indexPath.item == selectedIndex
        cell.configure(urlString: imageUrlList[indexPath.item], isHighlight: isSelected)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == selectedIndex { return }
        let direction: UIPageViewController.NavigationDirection = indexPath.item > selectedIndex ? .forward : .reverse
        let newVC = ImagePageViewController(imageUrl: imageUrlList[indexPath.item], index: indexPath.item)
        pageViewController.setViewControllers([newVC], direction: direction, animated: true, completion: nil)
        
        selectedIndex = indexPath.item
        pageControl.currentPage = selectedIndex
        collectionView.reloadData()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == thumbnailCollectionView, !decelerate {
            updateCurrentPageFromCollectionView()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == thumbnailCollectionView {
            updateCurrentPageFromCollectionView()
        }
    }
    
    private func updateCurrentPageFromCollectionView() {
        let visibleRect = CGRect(origin: thumbnailCollectionView.contentOffset, size: thumbnailCollectionView.bounds.size)
        let visibleCenter = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        if let indexPath = thumbnailCollectionView.indexPathForItem(at: visibleCenter) {
            if indexPath.item != selectedIndex {
                let direction: UIPageViewController.NavigationDirection = indexPath.item > selectedIndex ? .forward : .reverse
                let newVC = ImagePageViewController(imageUrl: imageUrlList[indexPath.item], index: indexPath.item)
                pageViewController.setViewControllers([newVC], direction: direction, animated: true, completion: nil)
                
                selectedIndex = indexPath.item
                pageControl.currentPage = selectedIndex
                thumbnailCollectionView.reloadData()
            }
        }
    }
}

// MARK: - DetailImageCell

final class DetailImageCell: UICollectionViewCell {
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 12
        clipsToBounds = true
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(urlString: String, isHighlight: Bool) {
        imageView.kf.setImage(with: URL(string: urlString))
        imageView.alpha = isHighlight ? 1 : 0.8
        layer.borderColor = isHighlight ? TDColor.Primary.primary500.cgColor : UIColor.clear.cgColor
        layer.borderWidth = isHighlight ? 2 : 0
    }
}

// MARK: - ImagePageViewController

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
