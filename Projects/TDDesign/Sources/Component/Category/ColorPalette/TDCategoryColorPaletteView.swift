import UIKit

public protocol TDCategoryColorPaletteViewDelegate: AnyObject {
    func didSelectColor(_ color: UIColor)
}

public final class TDCategoryColorPaletteView: UIView {
    // MARK: - UI Components
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        let itemSize = (UIScreen.main.bounds.width - 64) / 5 // 한 줄에 5개씩 표시
        layout.itemSize = CGSize(width: itemSize, height: itemSize + 16)
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    // MARK: - Properties
    private var categoryColors: [(text: UIColor, back: UIColor)] = []
    private var selectedIndex: Int? = nil
    public weak var delegate: TDCategoryColorPaletteViewDelegate?
    
    // MARK: - Initialization
    public init() {
        super.init(frame: .zero)
        setupCollectionView()
        loadCategoryColors()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func reloadPaletteView() {
        collectionView.reloadData()
    }
    
    // MARK: - Setup
    private func setupCollectionView() {
        addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            TDCategoryColorCell.self,
            forCellWithReuseIdentifier: TDCategoryColorCell.identifier
        )
    }
    
    private func loadCategoryColors() {
        categoryColors = (1...14).compactMap { TDColor.ColorPair[$0] }
        categoryColors.append((text: TDColor.Schedule.text15, back: TDColor.baseWhite))
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension TDCategoryColorPaletteView: UICollectionViewDataSource {
    public func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        categoryColors.count
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TDCategoryColorCell.identifier,
            for: indexPath
        ) as? TDCategoryColorCell else { return UICollectionViewCell() }
        
        let colorPair = categoryColors[indexPath.row]
        let isSelected = indexPath.row == selectedIndex
        
        cell.configure(
            color: colorPair.back,
            textColor: colorPair.text,
            isSelected: isSelected
        )
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension TDCategoryColorPaletteView: UICollectionViewDelegate {
    public func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        selectedIndex = indexPath.row
        collectionView.reloadData() // 선택 상태를 반영하기 위해 리로드
        
        // 선택된 색상 정보를 Delegate에 전달
        let selectedColor = categoryColors[indexPath.row].back
        delegate?.didSelectColor(selectedColor)
    }
}
