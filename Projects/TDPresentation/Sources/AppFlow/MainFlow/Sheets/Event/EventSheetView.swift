import Kingfisher
import SnapKit
import TDDesign
import TDDomain
import Then
import UIKit

protocol EventSheetViewDelegate: AnyObject {
    func eventSheetDidTapViewDetails(_ view: EventSheetView)
    func eventSheetDidTapHideToday(_ view: EventSheetView)
    func eventSheetDidTapClose(_ view: EventSheetView)
}

final class EventSheetView: BaseView, UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate {
    weak var delegate: EventSheetViewDelegate?
    private(set) var currentPageIndex: Int = 0

    private var events: [TDEvent] = []
    private var aspectByIndex: [CGFloat?] = []
    private var currentAspect: CGFloat = 9.0/16.0

    private let vStack = UIStackView()
    private let pagerContainer = UIView()
    private lazy var flowLayout = UICollectionViewFlowLayout()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    private let pageControl = UIPageControl()
    private lazy var detailsButton = TDBaseButton(
            title: "이벤트 내용 보기",
            backgroundColor: TDColor.Primary.primary500,
            foregroundColor: TDColor.baseWhite,
            font: TDFont.boldHeader3.font
        ).then {
            $0.addAction(UIAction { [weak self] _ in
                guard let self else { return }
                delegate?.eventSheetDidTapViewDetails(self)
            }, for: .touchUpInside)
    }
    private let bottomContainer = UIView()
    private let bottomStack = UIStackView()
    private lazy var hideTodayButton = TDBaseButton(
            title: "오늘 그만 보기",
            backgroundColor: TDColor.baseWhite,
            foregroundColor: TDColor.Neutral.neutral500,
            font: TDFont.boldHeader3.font,
            radius: 0
        ).then {
            $0.addAction(UIAction { [weak self] _ in
                guard let self else { return }
                delegate?.eventSheetDidTapHideToday(self)
            }, for: .touchUpInside)
        }

        private lazy var closeButton = TDBaseButton(
            title: "닫기",
            backgroundColor: TDColor.baseWhite,
            foregroundColor: TDColor.Neutral.neutral700,
            font: TDFont.boldHeader3.font,
            radius: 0
        ).then {
            $0.addAction(UIAction { [weak self] _ in
                guard let self else { return }
                delegate?.eventSheetDidTapClose(self)
            }, for: .touchUpInside)
        }

    private var heightConstraint: Constraint?
    private var lastWidth: CGFloat = 0

    override func addview() {
        addSubview(vStack)
        vStack.addArrangedSubview(pagerContainer)
        pagerContainer.addSubview(collectionView)
        pagerContainer.addSubview(pageControl)
        pagerContainer.addSubview(detailsButton)
        vStack.addArrangedSubview(bottomContainer)
        bottomContainer.addSubview(bottomStack)
        bottomStack.addArrangedSubview(hideTodayButton)
        bottomStack.addArrangedSubview(closeButton)
    }

    override func layout() {
        vStack.axis = .vertical
        vStack.alignment = .fill
        vStack.distribution = .fill
        vStack.spacing = 0

        vStack.snp.makeConstraints { $0.edges.equalTo(safeAreaLayoutGuide) }

        pagerContainer.snp.makeConstraints { make in
            heightConstraint = make.height.equalTo(0).priority(900).constraint
        }

        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0

        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(EventPageCell.self, forCellWithReuseIdentifier: EventPageCell.reuseID)

        collectionView.snp.makeConstraints { $0.edges.equalToSuperview() }

        pageControl.hidesForSinglePage = true
        pageControl.isUserInteractionEnabled = false
        pageControl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(detailsButton.snp.top).offset(-8)
        }

        detailsButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(20)
            $0.horizontalEdges.equalToSuperview().inset(18)
        }

        bottomContainer.layer.borderWidth = 1 / UIScreen.main.scale
        bottomContainer.layer.borderColor = TDColor.Neutral.neutral400.cgColor
        bottomContainer.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
            $0.height.greaterThanOrEqualTo(64)
        }
        bottomStack.axis = .horizontal
        bottomStack.distribution = .fillEqually
        bottomStack.spacing = 1
        bottomStack.snp.makeConstraints { $0.edges.equalToSuperview() }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let containerSize = pagerContainer.bounds.size
        if containerSize.width > 0 && containerSize.height > 0 {
            if flowLayout.itemSize != containerSize {
                flowLayout.itemSize = containerSize
                collectionView.collectionViewLayout.invalidateLayout()
            }
        } else {
            let fallbackWidth = max(containerSize.width, lastWidth, UIScreen.main.bounds.width)
            let fallbackHeight = max(containerSize.height, fallbackWidth * currentAspect, 1)
            let fallbackSize = CGSize(width: fallbackWidth, height: fallbackHeight)
            if flowLayout.itemSize != fallbackSize {
                flowLayout.itemSize = fallbackSize
                collectionView.collectionViewLayout.invalidateLayout()
            }
        }

        if abs(pagerContainer.bounds.width - lastWidth) > .ulpOfOne {
            lastWidth = pagerContainer.bounds.width
            applyHeight(for: currentAspect, animated: false)
        }
    }

    func configure(events: [TDEvent], precomputedAspects: [CGFloat?]) {
        self.events = events
        self.aspectByIndex = precomputedAspects.count == events.count
        ? precomputedAspects
        : Array(repeating: nil, count: events.count)

        pageControl.numberOfPages = events.count
        pageControl.currentPage = 0
        currentPageIndex = 0

        if let a0 = aspectByIndex.first ?? nil {
            currentAspect = a0
        } else {
            currentAspect = 9.0/16.0
        }
        lastWidth = pagerContainer.bounds.width > 0 ? pagerContainer.bounds.width : UIScreen.main.bounds.width
        applyHeight(for: currentAspect, animated: false)

        updateDetailsButton(for: currentPageIndex)
        collectionView.reloadData()
    }

    private func updateDetailsButton(for index: Int) {
        guard events.indices.contains(index) else { return }
        let event = events[index]
        detailsButton.isHidden = !event.isButtonVisible
        if let buttonText = event.buttonText, !buttonText.isEmpty {
            detailsButton.setTitle(buttonText, for: .normal)
        }
    }

    // MARK: - DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { events.count }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = events[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventPageCell.reuseID, for: indexPath) as! EventPageCell

        let hasPre = aspectByIndex[indexPath.item] != nil
        cell.configure(url: item.thumbURL,
                       placeholder: TDImage.Event.socialThumnail,
                       reportSize: !hasPre) { [weak self] size in
            guard let self else { return }
            let ar = size.height / size.width
            self.aspectByIndex[indexPath.item] = ar
            if indexPath.item == self.currentPageIndex {
                self.applyHeight(for: ar, animated: true)
            }
        }
        return cell
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let w = max(scrollView.bounds.width, 1)
        let targetPage = Int(round(targetContentOffset.pointee.x / w))
        guard events.indices.contains(targetPage) else { return }
        pageControl.currentPage = targetPage
        currentPageIndex = targetPage

        updateDetailsButton(for: targetPage)
        if let ar = aspectByIndex[targetPage] {
            applyHeight(for: ar, animated: true)
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let w = max(scrollView.bounds.width, 1)
        let page = Int(round(scrollView.contentOffset.x / w))
        guard events.indices.contains(page) else { return }
        pageControl.currentPage = page
        currentPageIndex = page
        updateDetailsButton(for: page)
        if let ar = aspectByIndex[page] {
            applyHeight(for: ar, animated: true)
        }
    }

    private func applyHeight(for aspect: CGFloat, animated: Bool) {
        currentAspect = aspect
        let width = pagerContainer.bounds.width > 0 ? pagerContainer.bounds.width : lastWidth
        let target = width * aspect

        let updates = {
            self.heightConstraint?.update(offset: target)
            self.layoutIfNeeded()
        }
        animated
        ? UIView.animate(withDuration: 0.18, delay: 0, options: [.curveEaseInOut], animations: updates, completion: nil)
        : updates()
    }
}

// MARK: - Cell
private final class EventPageCell: UICollectionViewCell {
    static let reuseID = "EventPageCell"
    private let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    required init?(coder: NSCoder) { super.init(coder: coder) }

    func configure(url: URL?, placeholder: UIImage?, reportSize: Bool, onSize: @escaping (CGSize) -> Void) {
        guard let url else {
            imageView.image = placeholder
            if reportSize, let s = placeholder?.size { onSize(s) }
            return
        }
        imageView.kf.setImage(
            with: url,
            placeholder: placeholder,
            options: [.cacheOriginalImage, .backgroundDecode, .transition(.fade(0.12)), .scaleFactor(UIScreen.main.scale)]
        ) { result in
            if reportSize, case .success(let v) = result {
                onSize(v.image.size)
            }
        }
    }
}
