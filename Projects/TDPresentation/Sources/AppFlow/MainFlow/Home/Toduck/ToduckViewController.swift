import Combine
import Lottie
import TDCore
import TDDomain
import UIKit
import TDDesign
import SnapKit
import Then

final class ToduckViewController: BaseViewController<ToduckView> {
    // MARK: - Properties
    private let viewModel = ToduckViewModel()
    private let input = PassthroughSubject<ToduckViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Common Methods
    override func configure() {
        updateLottieView(at: 0)
        layoutView.scheduleCollectionView.delegate = self
        layoutView.scheduleCollectionView.dataSource = self
        layoutView.scheduleCollectionView.register(
            ScheduleCollectionViewCell.self,
            forCellWithReuseIdentifier: ScheduleCollectionViewCell.identifier
        )
    }
    
    private func updateLottieView(at index: Int) {
        let lottieImageType = TDCategoryImageType(category: viewModel.todaySchedules[index].category)
        let newAnimation = ToduckLottieManager.shared.getLottieAnimation(for: lottieImageType)
        layoutView.lottieView.animation = newAnimation
        layoutView.lottieView.play()
    }
}

// MARK: - UICollectionViewDataSource
extension ToduckViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        viewModel.todaySchedules.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ScheduleCollectionViewCell.identifier,
            for: indexPath
        ) as? ScheduleCollectionViewCell else { return UICollectionViewCell() }
        
        updateLottieView(at: indexPath.row)
        
        let currentSchedule = viewModel.todaySchedules[indexPath.row]
        cell.eventDetailView.configureCell(
            isHomeToduck: true,
            color: currentSchedule.categoryColor,
            title: currentSchedule.title,
            time: currentSchedule.time,
            category: viewModel.categoryImages[indexPath.row].image,
            isFinished: currentSchedule.isFinished,
            place: currentSchedule.place
        )
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ToduckViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = collectionView.frame.width
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
    
    // 스크롤이 끝날 때 셀 단위로 스냅하도록 targetContentOffset 조정
    func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        let collectionView = layoutView.scheduleCollectionView
        
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        // 셀 전체 폭(셀 너비 + 간격)
        let cellWidth = collectionView.frame.width
        let cellSpacing = layout.minimumLineSpacing
        let cellWidthWithSpacing = cellWidth + cellSpacing
        let offset = scrollView.contentOffset.x
        
        // 현재 스크롤 위치에 해당하는 인덱스(소수점 포함)
        let estimatedIndex = offset / cellWidthWithSpacing
        
        // 스크롤 속도에 따라 올림, 내림, 반올림 처리
        let index: CGFloat
        if velocity.x > 0 {
            index = ceil(estimatedIndex)
        } else if velocity.x < 0 {
            index = floor(estimatedIndex)
        } else {
            index = round(estimatedIndex)
        }
        
        // 새 오프셋 계산
        let newOffsetX = index * cellWidthWithSpacing
        
        targetContentOffset.pointee = CGPoint(x: newOffsetX, y: targetContentOffset.pointee.y)
    }
}
