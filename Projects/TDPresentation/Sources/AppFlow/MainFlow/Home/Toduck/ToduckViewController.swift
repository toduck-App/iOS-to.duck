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
    private let viewModel: ToduckViewModel
    private let input = PassthroughSubject<ToduckViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    private var autoScrollTimer: Timer?
    weak var delegate: ToduckViewDelegate?
    
    init(
        viewModel: ToduckViewModel
    ) {
        self.viewModel = viewModel
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        input.send(.fetchScheduleList)
    }
    
    // MARK: Common Methods
    override func binding() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
        output.receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .fetchedScheduleList:
                    self?.layoutView.noScheduleContainerView.isHidden = true
                    self?.layoutView.scheduleCollectionView.isHidden = false
                    self?.layoutView.scheduleCollectionView.reloadData()
                    self?.updateLottieView(at: 0)
                    self?.updateAutoScroll()
                case .fetchedEmptyScheduleList:
                    self?.layoutView.noScheduleContainerView.isHidden = false
                    self?.layoutView.scheduleCollectionView.isHidden = true
                case .failure(let error):
                    self?.showErrorAlert(errorMessage: error)
                }
            }.store(in: &cancellables)
    }
    
    override func configure() {
        setupSegmentedControl()
        updateLottieAnimationForVisibleCell()
        layoutView.delegate = delegate
        layoutView.scheduleCollectionView.delegate = self
        layoutView.scheduleCollectionView.dataSource = self
        layoutView.scheduleCollectionView.register(
            ScheduleCollectionViewCell.self,
            forCellWithReuseIdentifier: ScheduleCollectionViewCell.identifier
        )
    }
    
    private func setupSegmentedControl() {
        layoutView.scheduleSegmentedControl.addAction(UIAction { [weak self] action in
            guard let segmentedControl = action.sender as? UISegmentedControl else { return }
            let selectedIndex = segmentedControl.selectedSegmentIndex
            
            if selectedIndex == 0 {
                self?.viewModel.switchToTodaySchedules()
            } else {
                self?.viewModel.switchToRemainingSchedules()
            }
            
            self?.layoutView.scheduleCollectionView.reloadData()
            self?.updateAutoScroll()
        }, for: .valueChanged)
    }
    
    private func updateLottieView(at index: Int) {
        let lottieImageType = TDCategoryImageType(category: viewModel.currentDisplaySchedules[index].category)
        let newAnimation = ToduckLottieManager.shared.getLottieAnimation(for: lottieImageType)
        layoutView.lottieView.animation = newAnimation
        layoutView.lottieView.play()
    }
    
    // MARK: 종일 일정만 있는 경우 자동스크롤 구현
    private func updateAutoScroll() {
        if viewModel.isAllDays {
            startAutoScroll()
            layoutView.scheduleCollectionView.isScrollEnabled = false
        } else {
            stopAutoScroll()
            layoutView.scheduleCollectionView.isScrollEnabled = true
        }
    }
    
    private func startAutoScroll() {
        guard viewModel.isAllDays else {
            stopAutoScroll()
            return
        }
        
        stopAutoScroll()
        autoScrollTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] _ in
            self?.scrollToNextItem()
        }
    }
    
    private func stopAutoScroll() {
        autoScrollTimer?.invalidate()
        autoScrollTimer = nil
    }
    
    /// 자동 스크롤이 일정한 간격을 유지를 위해 셀의 너비에 따라 다음 인덱스 계산
    private func scrollToNextItem() {
        let collectionView = layoutView.scheduleCollectionView
        let itemCount = viewModel.todaySchedules.count
        guard itemCount > 1 else { return }
        
        let nextIndex = getNextIndex(for: collectionView, totalItems: itemCount)
        let newOffsetX = calculateNewOffsetX(for: collectionView, index: nextIndex)
        
        animateCollectionViewScroll(to: newOffsetX)
    }
    
    private func getNextIndex(for collectionView: UICollectionView, totalItems: Int) -> Int {
        let currentIndex = Int(round(collectionView.contentOffset.x / collectionView.frame.width))
        return (currentIndex + 1) % totalItems
    }
    
    private func calculateNewOffsetX(for collectionView: UICollectionView, index: Int) -> CGFloat {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return 0 }
        
        let sectionInsetLeft = layout.sectionInset.left
        let cellSpacing = layout.minimumLineSpacing
        let cellWidth = collectionView.frame.width
        let totalCellWidth = cellWidth + cellSpacing
        
        return CGFloat(index) * totalCellWidth - sectionInsetLeft
    }
    
    private func animateCollectionViewScroll(to offsetX: CGFloat) {
        let collectionView = layoutView.scheduleCollectionView
        
        UIView.animate(withDuration: 0.3, animations: {
            collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
        }) { _ in
            self.updateLottieAnimationForVisibleCell()
        }
    }
}

// MARK: - UICollectionViewDataSource
extension ToduckViewController: UICollectionViewDataSource {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updateLottieAnimationForVisibleCell()
    }
    
    func updateLottieAnimationForVisibleCell() {
        let collectionView = layoutView.scheduleCollectionView
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        guard let visibleIndexPath = collectionView.indexPathForItem(at: CGPoint(x: visibleRect.midX, y: visibleRect.midY)) else { return }
        
        updateLottieView(at: visibleIndexPath.row)
    }
    
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
        
        // TODO: 투두에서 일정 완료하고 '토덕'에 돌아와 '남은 투두'에서 스와이프하면 인덱스 문제로 크래시 발생
        let currentSchedule = viewModel.currentDisplaySchedules[indexPath.row]
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

extension ToduckViewController: ToduckViewDelegate {
    func didTapNoScheduleContainerView() {
        delegate?.didTapNoScheduleContainerView()
    }
}
