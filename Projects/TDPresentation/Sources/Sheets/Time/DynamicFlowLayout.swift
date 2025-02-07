import UIKit

/// 시간 설정 시트지에서 시, 분 컬렉션뷰의 가로를 두 줄로 나누는 레이아웃입니다.
/// - 기기 구별없이 12개의 아이템을 각 줄에 6개씩 표시하며, 아이템의 크기는 동적으로 조절됩니다.
final class DynamicFlowLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        updateItemSize()
    }
    
    private func updateItemSize() {
        guard let collectionView = collectionView else { return }
        
        let numberOfItemsPerRow: CGFloat = 6
        let spacing = minimumInteritemSpacing
        let totalSpacing = spacing * (numberOfItemsPerRow - 1)
        let cellWidth = (collectionView.bounds.width - totalSpacing) / numberOfItemsPerRow
        
        itemSize = CGSize(width: cellWidth, height: 50)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
