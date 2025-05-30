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
        TDImage.Category.sleep,     // 물
        TDImage.Category.power,     // 운동
        TDImage.Category.people,    // 사람
        TDImage.Category.medicine,  // 약
        TDImage.Category.talk,      // 채팅
        TDImage.Category.heart,     // 하트
        TDImage.Category.vehicle,   // 차
    ]
    private var categoryColors = [UIColor]()
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
        
        collectionView.backgroundColor = .white
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
    public func selectCategory(categoryImage: UIImage) {
        guard let index = categoryImages.firstIndex(of: categoryImage) else { return }
        selectedIndex = index
        
        for cell in collectionView.visibleCells {
            guard
                let indexPath = collectionView.indexPath(for: cell),
                let categoryCell = cell as? TDCategoryCell
            else { continue }
            
            let image = categoryImages[indexPath.row]
            let color = categoryColors[indexPath.row]
            let isSelected = (indexPath.item == selectedIndex)
            
            categoryCell.configure(image: image, backgroundColor: color, isSelected: isSelected)
        }
    }
    
    public func setupCategoryView(colors: [UIColor]) {
        self.categoryColors = colors.map { TDColor.opacityPair[ColorValue(color: $0)] ?? $0 }
        collectionView.reloadData()
    }
    
    public func isCategorySelected() -> Bool {
        return selectedIndex != nil
    }
    
    public func updateColor(at index: Int, with color: UIColor) {
        guard index >= 0 && index < categoryColors.count else { return }
        categoryColors[index] = color
        
        if let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? TDCategoryCell {
            cell.configure(
                image: categoryImages[index],
                backgroundColor: color,
                isSelected: index == selectedIndex
            )
        }
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
        let isSelected = (selectedIndex == nil) || (indexPath.item == selectedIndex)
        cell.configure(image: image, backgroundColor: color, isSelected: isSelected)

        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension TDCategoryCollectionView: UICollectionViewDelegateFlowLayout {
    public func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        selectedIndex = indexPath.row
        
        for cell in collectionView.visibleCells {
            guard let index = collectionView.indexPath(for: cell)?.row,
                  let categoryCell = cell as? TDCategoryCell else { continue }
            
            let image = categoryImages[index]
            let color = categoryColors[index]
            let isSelected = (index == selectedIndex)
            
            categoryCell.configure(image: image, backgroundColor: color, isSelected: isSelected)
        }
        
        delegate?.didTapCategoryCell(
            categoryColors[indexPath.row],
            categoryImages[indexPath.row],
            indexPath.row
        )
    }
}
