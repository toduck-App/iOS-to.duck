import SnapKit
import TDDesign
import Then
import UIKit
final class TodayKeywordTagListView: UIView, UICollectionViewDataSource {

    // MARK: - UI
    private lazy var collectionView: UICollectionView = {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 12
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.isScrollEnabled = false
        cv.dataSource = self
        cv.delegate = self
        cv.register(with: KeywordChipCell.self)
        return cv
    }()
    
    // MARK: - Properties
    private var keywords: [String] = []
    private var keywordIds: [Int] = []
    private var selectedKeywordIds: Set<Int> = []
    private var heightConstraint: NSLayoutConstraint?
    weak var delegate: TodayKeywordTagListViewDelegate?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupHierarchy() {
        addSubview(collectionView)
    }

    private func setupLayout() {
        collectionView.snp.makeConstraints { $0.edges.equalToSuperview() }
        heightConstraint = heightAnchor.constraint(equalToConstant: 1)
        heightConstraint?.isActive = true
    }

    // MARK: - Public
    func configure(keywords: [String], keywordIds: [Int] = []) {
        self.keywords = keywords
        self.keywordIds = keywordIds.isEmpty ? Array(0..<keywords.count) : keywordIds
        collectionView.reloadData()

        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.collectionView.collectionViewLayout.invalidateLayout()
            self.collectionView.layoutIfNeeded()
            let height = self.collectionView.collectionViewLayout.collectionViewContentSize.height
            self.heightConstraint?.constant = height
        }
    }
    
    func updateSelectedKeywords(_ selectedIds: Set<Int>) {
        self.selectedKeywordIds = selectedIds
        collectionView.reloadData()
    }

    // MARK: - DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        keywords.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: KeywordChipCell = collectionView.dequeueReusableCell(for: indexPath)
        let keywordId = indexPath.item < keywordIds.count ? keywordIds[indexPath.item] : indexPath.item
        let isSelected = selectedKeywordIds.contains(keywordId)
        cell.configure(text: keywords[indexPath.item], isSelectedForDeletion: isSelected)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension TodayKeywordTagListView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard !selectedKeywordIds.isEmpty else { return }
        let keywordId = indexPath.item < keywordIds.count ? keywordIds[indexPath.item] : indexPath.item
        delegate?.didSelectKeyword(at: keywordId)
    }
}

// MARK: - TodayKeywordTagListViewDelegate
protocol TodayKeywordTagListViewDelegate: AnyObject {
    func didSelectKeyword(at id: Int)
}
