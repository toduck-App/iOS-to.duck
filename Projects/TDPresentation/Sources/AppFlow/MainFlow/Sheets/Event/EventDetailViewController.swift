import TDCore
import TDDomain
import TDDesign
import UIKit
import SnapKit
import Then
import Kingfisher

final class EventDetailViewController: BaseViewController<BaseView> {
    weak var coordinator: EventSheetCoordinator?
    
    private var eventDetail: TDEventDetail
    
    init(eventDetail: TDEventDetail) {
        self.eventDetail = eventDetail
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    private let backButton = UIButton(type: .system).then {
        $0.setImage(TDImage.X.x2Medium.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.tintColor = TDColor.Neutral.neutral800
    }
    
    private(set) var actionButton = TDBaseButton(
        title: "게시글 작성하러 가기",
        backgroundColor: TDColor.Event.buttonEventBackground,
        foregroundColor: TDColor.baseWhite,
        radius: 12,
        font: TDFont.boldHeader3.font
    )
    
    private let scrollView = UIScrollView().then {
        $0.alwaysBounceVertical = true
        $0.isDirectionalLockEnabled = true
        $0.showsVerticalScrollIndicator = true
        $0.backgroundColor = .clear
    }
    
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fill
        $0.spacing = 0
        $0.isLayoutMarginsRelativeArrangement = false
    }
    
    private var imageViews: [UIImageView] = []
    private var heightConstraints: [Constraint] = []
    private var lastLayoutWidth: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
    }
    
    override func configure() {
        super.configure()
        setupScrollLayout()
        loadImages()
        
        backButton.addAction(UIAction { [weak self] _ in
            self?.coordinator?.finish(by: .pop)
        }, for: .touchUpInside)
        
        actionButton.addAction(UIAction { [weak self] _ in
            guard let url = self?.eventDetail.routingURL, let deepLinkType = DeepLinkType(url: url) else { return }
            self?.coordinator?.deepLinkRouter?.route(to: deepLinkType, dismissPresented: false)
        }, for: .touchUpInside)
    }
    
    override func layout() {
        layoutView.addSubview(actionButton)
        actionButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(56)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let currentWidth = scrollView.bounds.width
        guard currentWidth > 0, abs(currentWidth - lastLayoutWidth) > .ulpOfOne else { return }
        lastLayoutWidth = currentWidth
        
        for (idx, iv) in imageViews.enumerated() {
            guard idx < heightConstraints.count, let img = iv.image else { continue }
            let ratio = img.size.height / img.size.width
            let scale = UIScreen.main.scale
            let snappedH = floor((currentWidth * ratio) * scale) / scale
            heightConstraints[idx].update(offset: snappedH)
        }
        view.layoutIfNeeded()
    }
    
    // MARK: - Setup
    private func setupNavigation() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    private func setupScrollLayout() {
        layoutView.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(layoutView.safeAreaLayoutGuide)
        }
        
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
    }
    
    // MARK: - Image Loading
    private func appendImageView() -> (UIImageView, Constraint) {
        let iv = UIImageView().then {
            $0.contentMode = .scaleAspectFit
            $0.clipsToBounds = true
            $0.isOpaque = true
            $0.backgroundColor = .clear
        }
        stackView.addArrangedSubview(iv)
        imageViews.append(iv)
        
        var heightConstraint: Constraint!
        iv.snp.makeConstraints { make in
            heightConstraint = make.height.equalTo(100).constraint // 임시값
        }
        return (iv, heightConstraint)
    }
    
    private func loadImages() {
        guard !eventDetail.imageURLs.isEmpty else { return }
        heightConstraints.removeAll()
        imageViews.removeAll()
        
        let baseWidth: CGFloat = scrollView.bounds.width > 0
        ? scrollView.bounds.width
        : UIScreen.main.bounds.width
        lastLayoutWidth = baseWidth
        
        let kfOptions: KingfisherOptionsInfo = [
            .cacheOriginalImage,
            .transition(.fade(0.15)),
            .backgroundDecode,
            .scaleFactor(UIScreen.main.scale)
        ]
        
        for url in eventDetail.imageURLs.reversed() {
            let (iv, h) = appendImageView()
            heightConstraints.append(h)
            
            iv.kf.setImage(with: url, options: kfOptions) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let value):
                    let img = value.image
                    let ratio = img.size.height / img.size.width
                    let scale = UIScreen.main.scale
                    let width = self.scrollView.bounds.width > 0 ? self.scrollView.bounds.width : UIScreen.main.bounds.width
                    let snappedH = floor((width * ratio) * scale) / scale
                    h.update(offset: snappedH)
                    iv.setNeedsLayout()
                case .failure(let error):
                    TDLogger.debug("이벤트 이미지 불러오기 실패")
                }
            }
        }
    }
}
