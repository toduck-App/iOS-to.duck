import UIKit
import SnapKit
import Then

public protocol TDCategoryCellDelegate: AnyObject {
    func didTapCategoryCell(_ color: UIColor, _ image: UIImage, _ index: Int)
}

public final class TDCategoryCollectionView: UIView {
    // MARK: - UI Components
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.itemSize = CGSize(width: 50, height: 50)
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    // MARK: - Data Properties
    private let categoryImages: [UIImage] = [
        TDImage.Category.computer,  // 컴퓨터
        TDImage.Category.food,      // 밥
        TDImage.Category.pencil,    // 연필
        TDImage.Category.redBook,   // 빨간책
        TDImage.Category.yellowBook,// 노란책
        TDImage.Category.sleep,     // 물
        TDImage.Category.power,     // 운동
        TDImage.Category.people,    // 사람
        TDImage.Category.medicine,  // 약
        TDImage.Category.talk,      // 채팅
        TDImage.Category.heart,     // 하트
        TDImage.Category.vehicle,   // 차
        TDImage.Category.none       // None
    ]
    private var categoryColors: [UIColor] = []
    private var selectedIndex: Int?
    public weak var delegate: TDCategoryCellDelegate?
    
    // MARK: - Initialization
    public init() {
        super.init(frame: .zero)
        setupCollectionView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupCollectionView() {
        addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            TDCategoryCell.self,
            forCellWithReuseIdentifier: TDCategoryCell.identifier
        )
    }
    
    // MARK: - Public Method
    public func setupCategoryView(colors: [UIColor]) {
        self.categoryColors = colors
        collectionView.reloadData()
    }
    
    public func isCategorySelected() -> Bool {
        return selectedIndex != nil
    }
    
    public func updateColor(at index: Int, with color: UIColor) {
        guard index >= 0 && index < categoryColors.count else { return }
        categoryColors[index] = color
        collectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
    }

    // 특정 색상 가져오기 메서드 추가
    public func getColor(at index: Int) -> UIColor? {
        guard index >= 0 && index < categoryColors.count else { return nil }
        return categoryColors[index]
    }
}

// MARK: - UICollectionViewDataSource
extension TDCategoryCollectionView: UICollectionViewDataSource {
    public func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        categoryImages.count
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TDCategoryCell.identifier,
            for: indexPath
        ) as? TDCategoryCell else { return UICollectionViewCell() }
        
        let image = categoryImages[indexPath.row]
        let color = indexPath.row < categoryColors.count ? categoryColors[indexPath.row] : UIColor.clear
        
        cell.configure(image: image, backgroundColor: color)
        cell.alpha = (indexPath.row == selectedIndex) ? 1.0 : 0.3
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension TDCategoryCollectionView: UICollectionViewDelegateFlowLayout {
    public func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let previousIndex = selectedIndex
        selectedIndex = indexPath.row

        // 이전 셀과 선택된 셀을 모두 업데이트
        var itemsToReload = [IndexPath(row: indexPath.row, section: 0)]
        if let previousIndex = previousIndex, previousIndex != selectedIndex {
            itemsToReload.append(IndexPath(row: previousIndex, section: 0))
        }

        collectionView.reloadItems(at: itemsToReload)
        
        delegate?.didTapCategoryCell(
            categoryColors[indexPath.row],
            categoryImages[indexPath.row],
            indexPath.row
        )
    }
}
