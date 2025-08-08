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
    
    weak var lottieScrollView: UIScrollView?
    weak var delegate: ToduckViewDelegate?
    
    // MARK: - Initializer
    init(viewModel: ToduckViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        layoutView.scheduleSegmentedControl.selectedSegmentIndex = 0
        input.send(.fetchScheduleList)
    }
    
    // MARK: Common Methods
    override func binding() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
        output.receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .fetchedScheduleList(let isEmpty):
                    self?.layoutView.noScheduleContainerView.isHidden = !isEmpty
                    self?.layoutView.scheduleCollectionView.isHidden = isEmpty
                    self?.layoutView.scheduleCollectionView.reloadData()
                    self?.reloadLottiePages()
                case .failure(let error):
                    self?.showErrorAlert(errorMessage: error)
                }
            }.store(in: &cancellables)
    }
    
    override func configure() {
        setupSegmentedControl()
        setupScheduleCollectionView()
        layoutView.delegate = delegate
    }
    
    private func setupSegmentedControl() {
        layoutView.scheduleSegmentedControl.addAction(UIAction { [weak self] action in
            guard let segmentedControl = action.sender as? UISegmentedControl else { return }
            
            let selectedIndex = segmentedControl.selectedSegmentIndex
            let selectedType: ScheduleSegmentType = (selectedIndex == 0) ? .today : .uncompleted
            
            self?.viewModel.setSegment(selectedType)
            self?.layoutView.scheduleCollectionView.reloadData()
            self?.reloadLottiePages()
        }, for: .valueChanged)
    }
    
    private func setupScheduleCollectionView() {
        layoutView.scheduleCollectionView.delegate = self
        layoutView.scheduleCollectionView.dataSource = self
        layoutView.scheduleCollectionView.register(
            ScheduleCollectionViewCell.self,
            forCellWithReuseIdentifier: ScheduleCollectionViewCell.identifier
        )
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
        let itemCount = viewModel.currentSchedules.count
        guard itemCount > 1 else { return }
        
        let nextIndex = getNextIndex(for: collectionView, totalItems: itemCount)
        let newOffsetX = calculateNewOffsetX(for: collectionView, index: nextIndex)
        //        animateCollectionViewScroll(to: newOffsetX)
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
    
    func reloadLottiePages() {
        let lottieImageTypes = viewModel.currentDisplaySchedules.map { $0.category }
            .compactMap { TDCategoryImageType(category: $0) }
        let newAnimations = lottieImageTypes.compactMap {
            ToduckLottieManager.shared.getLottieAnimation(for: $0)
        }
        
        layoutView.lottiePageScrollView.configure(with: newAnimations)
    }
}

// MARK: - UIScrollViewDelegate
extension ToduckViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard
            scrollView === layoutView.scheduleCollectionView,
            let layout = layoutView.scheduleCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        else { return }
        
        let inset = layout.sectionInset.left
        let spacing = layout.minimumLineSpacing
        let pageWidth = layoutView.scheduleCollectionView.bounds.width
        let step = pageWidth + spacing
        
        let page = (scrollView.contentOffset.x + inset) / step
        let lottieWidth = layoutView.lottiePageScrollView.bounds.width
        
        layoutView.lottiePageScrollView.contentOffset.x = page * lottieWidth
    }
}

// MARK: - UICollectionViewDataSource
extension ToduckViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        viewModel.currentDisplaySchedules.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ScheduleCollectionViewCell.identifier,
            for: indexPath
        ) as? ScheduleCollectionViewCell else { return UICollectionViewCell() }
        
        let currentSchedule = viewModel.currentDisplaySchedules[indexPath.row]
        let categoryImage = viewModel.categoryImages[safe: indexPath.row]?.image
        
        cell.eventDetailView.configureCell(
            isHomeToduck: true,
            color: currentSchedule.categoryColor,
            title: currentSchedule.title,
            time: currentSchedule.time,
            category: categoryImage,
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
        
        let cellWidth = collectionView.frame.width
        let cellSpacing = layout.minimumLineSpacing
        let cellWidthWithSpacing = cellWidth + cellSpacing
        let offset = scrollView.contentOffset.x
        let estimatedIndex = offset / cellWidthWithSpacing
        
        let index: CGFloat
        if velocity.x > 0 {
            index = ceil(estimatedIndex)
        } else if velocity.x < 0 {
            index = floor(estimatedIndex)
        } else {
            index = round(estimatedIndex)
        }
        
        let lastIndex = CGFloat(viewModel.currentDisplaySchedules.count - 1)
        if index >= lastIndex {
            // 마지막 셀에 도달하면 더 이상 스크롤하지 않도록 고정
            let maxOffsetX = lastIndex * cellWidthWithSpacing
            targetContentOffset.pointee = CGPoint(x: maxOffsetX, y: targetContentOffset.pointee.y)
        } else {
            let newOffsetX = index * cellWidthWithSpacing
            targetContentOffset.pointee = CGPoint(x: newOffsetX, y: targetContentOffset.pointee.y)
        }
    }
}

extension ToduckViewController: ToduckViewDelegate {
    func didTapNoScheduleContainerView() {
        delegate?.didTapNoScheduleContainerView()
    }
}
