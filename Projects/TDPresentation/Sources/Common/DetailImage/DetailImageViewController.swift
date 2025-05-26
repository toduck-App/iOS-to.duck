import UIKit
import TDDesign

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
