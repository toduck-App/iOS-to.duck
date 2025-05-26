import UIKit
import SnapKit
import Then

public protocol DiaryMoodCollectionViewDelegate: AnyObject {
    func didTapCategoryCell(_ diaryMoodCollectionView: DiaryMoodCollectionView, selectedMood: UIImage)
}

public final class DiaryMoodCollectionView: UIView {
    // MARK: - UI Components
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 14
        layout.minimumInteritemSpacing = 14
        layout.itemSize = CGSize(width: 50, height: 50)
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    // MARK: - Data Properties
    private let moodImages: [UIImage] = [
        TDImage.Mood.love,      // 사랑
        TDImage.Mood.happy,     // 기쁨
        TDImage.Mood.good,      // 좋음
        TDImage.Mood.soso,      // 보통
        TDImage.Mood.sick,      // 아픔
        TDImage.Mood.sad,       // 슬픔
        TDImage.Mood.tired,     // 지침
        TDImage.Mood.anxious,   // 불안
        TDImage.Mood.angry,     // 화남
    ]
    private var selectedIndex: Int?
    public weak var delegate: DiaryMoodCollectionViewDelegate?
    
    // MARK: - Initialization
    public init() {
        super.init(frame: .zero)
        setupCollectionView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Method
    public func isCategorySelected() -> Bool {
        return selectedIndex != nil
    }
    
    public func setupSelectedMoodImage(_ image: UIImage) {
        guard let index = moodImages.firstIndex(of: image) else { return }
        selectedIndex = index
        
        DispatchQueue.main.async { [weak self] in
            self?.updateVisibleCellsSelectionState()
        }
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
            DiaryMoodCell.self,
            forCellWithReuseIdentifier: DiaryMoodCell.identifier
        )
    }
    
    private func updateVisibleCellsSelectionState() {
        for cell in collectionView.visibleCells {
            guard let indexPath = collectionView.indexPath(for: cell),
                  let moodCell = cell as? DiaryMoodCell else { continue }

            let image = moodImages[indexPath.item]
            let isSelected = (indexPath.item == selectedIndex)
            moodCell.configure(image: image, isSelected: isSelected)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension DiaryMoodCollectionView: UICollectionViewDataSource {
    public func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        moodImages.count
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: DiaryMoodCell.identifier,
            for: indexPath
        ) as? DiaryMoodCell else { return UICollectionViewCell() }


        let image = moodImages[indexPath.item]
        let isSelected = (selectedIndex == nil) || (indexPath.item == selectedIndex)
        cell.configure(image: image, isSelected: isSelected)

        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension DiaryMoodCollectionView: UICollectionViewDelegateFlowLayout {
    public func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        selectedIndex = indexPath.row
        updateVisibleCellsSelectionState()
        
        let selectedMood = moodImages[indexPath.row]
        delegate?.didTapCategoryCell(self, selectedMood: selectedMood)
    }
}
