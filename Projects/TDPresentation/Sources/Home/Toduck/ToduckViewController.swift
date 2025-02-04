import UIKit
import TDDesign
import SnapKit
import Then

final class ToduckViewController: BaseViewController<ToduckView> {
    private let events = ["A", "B", "C", "D"]
    
    override func configure() {
        layoutView.scheduleCollectionView.delegate = self
        layoutView.scheduleCollectionView.dataSource = self
        layoutView.scheduleCollectionView.register(
            ScheduleCollectionViewCell.self,
            forCellWithReuseIdentifier: ScheduleCollectionViewCell.identifier
        )
    }
}

// MARK: - UICollectionViewDataSource
extension ToduckViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return events.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ScheduleCollectionViewCell.identifier,
            for: indexPath
        ) as? ScheduleCollectionViewCell else { return UICollectionViewCell() }
        
        cell.eventDetailView.configureCell(
            color: .blue,
            title: events[indexPath.row],
            time: "10:00",
            category: .actions,
            isFinish: false,
            place: "asd"
        )
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ToduckViewController: UICollectionViewDelegateFlowLayout {
    // 셀 사이의 간격은 이미 layout.minimumLineSpacing에서 10pt로 설정됨.
    // 셀의 크기를 지정: 컬렉션뷰의 중앙에 셀 하나가 완전히 보이고, 양쪽에 일부 셀이 보이도록 설정
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        // 예를 들어, 컬렉션뷰 너비의 80%를 셀 너비로 사용
        let width = collectionView.frame.width * 0.8
        let height: CGFloat = 116
        return CGSize(width: width, height: height)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
}
