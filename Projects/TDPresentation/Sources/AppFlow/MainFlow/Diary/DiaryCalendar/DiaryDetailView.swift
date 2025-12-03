import UIKit
import TDDesign
import Then

public final class DiaryDetailView: UIView {
    
    // MARK: - UI Components
    
    private let mainStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 20
    }
    
    // 날짜 섹션
    private let dateHeaderStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.alignment = .center
    }
    private let emotionImageView = UIImageView()
    public let dropdownButton = TDBaseButton(
        image: TDImage.Dot.verticalMedium,
        backgroundColor: TDColor.baseWhite,
        foregroundColor: TDColor.Neutral.neutral500
    )
    public lazy var dropDownHoverView = TDDropdownHoverView(
        anchorView: dropdownButton,
        layout: .trailing,
        width: 110
    )
    
    private let dateVerticalStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
        $0.alignment = .leading
    }
    private let dateLabel = TDLabel(toduckFont: TDFont.mediumCaption1, toduckColor: TDColor.Neutral.neutral600)
    private let titleLabel = TDLabel(toduckFont: TDFont.mediumBody2, toduckColor: TDColor.Neutral.neutral900)
    
    // 키워드 섹션
    private let keywordVerticalStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 12
    }

    private let keywordHeaderStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
        $0.alignment = .center
    }

    private let keywordIcon = UIImageView(image: TDImage.Tomato.tomatoSmallEmtpy)
    
    private let keywordTitleLabel = TDLabel(
        labelText: "오늘의 키워드",
        toduckFont: TDFont.boldBody2,
        toduckColor: TDColor.Neutral.neutral600
    )

    private let keywordTagListView = TodayKeywordTagListView()
    
    // 문장 섹션
    private let sentenceVerticalStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 16
    }
    private let sentenceHeaderStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
        $0.alignment = .center
    }
    private let pencilIcon = UIImageView(image: TDImage.Pen.penNeutralColor)
    private let sentenceTitleLabel = TDLabel(
        labelText: "문장 기록",
        toduckFont: TDFont.boldBody2,
        toduckColor: TDColor.Neutral.neutral600
    )
    private let sentenceContentLabel = TDLabel(
        toduckFont: TDFont.regularBody4,
        toduckColor: TDColor.Neutral.neutral800
    ).then {
        $0.numberOfLines = 0
        $0.textAlignment = .natural
    }
    
    // 사진 섹션
    private let photoVerticalStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 16
    }
    private let photoHeaderStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
        $0.alignment = .center
    }
    private let photoIcon = UIImageView(image: TDImage.photo)
    private let photoTitleLabel = TDLabel(
        labelText: "사진 기록",
        toduckFont: TDFont.boldBody2,
        toduckColor: TDColor.Neutral.neutral600
    )
    private let photoContentStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 12
        $0.distribution = .fillEqually
    }
    
    // MARK: Properties
    private var currentImageURLs: [String] = []
    weak var delegate: TDFormPhotoDelegate?
    
    // MARK: Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupHierarchy() {
        addSubview(mainStackView)
        setupDateSection()
        setupKeywordSection()
        setupSentenceSection()
        setupPhotoSection()
    }
    
    private func setupDateSection() {
        mainStackView.addArrangedSubview(dateHeaderStackView)
        
        dateHeaderStackView.addArrangedSubview(emotionImageView)
        dateHeaderStackView.addArrangedSubview(dateVerticalStackView)
        dateHeaderStackView.addArrangedSubview(dropDownHoverView)
        
        dateVerticalStackView.addArrangedSubview(dateLabel)
        dateVerticalStackView.addArrangedSubview(titleLabel)
    }
    
    private func setupKeywordSection() {
        keywordHeaderStackView.addArrangedSubview(keywordIcon)
        keywordHeaderStackView.addArrangedSubview(keywordTitleLabel)
        
        keywordVerticalStackView.addArrangedSubview(keywordHeaderStackView)
        keywordVerticalStackView.addArrangedSubview(keywordTagListView)
    }
    
    private func setupSentenceSection() {
        sentenceHeaderStackView.addArrangedSubview(pencilIcon)
        sentenceHeaderStackView.addArrangedSubview(sentenceTitleLabel)
        
        sentenceVerticalStackView.addArrangedSubview(sentenceHeaderStackView)
        sentenceVerticalStackView.addArrangedSubview(sentenceContentLabel)
    }
    
    private func setupPhotoSection() {
        photoHeaderStackView.addArrangedSubview(photoIcon)
        photoHeaderStackView.addArrangedSubview(photoTitleLabel)
        
        photoVerticalStackView.addArrangedSubview(.spacer(height: 16))
        photoVerticalStackView.addArrangedSubview(photoHeaderStackView)
        photoVerticalStackView.addArrangedSubview(photoContentStackView)
    }
    
    private func setupLayout() {
        mainStackView.snp.makeConstraints { $0.edges.equalToSuperview().inset(16) }
        dateHeaderStackView.snp.makeConstraints { $0.height.equalTo(48) }
        emotionImageView.snp.makeConstraints { $0.size.equalTo(48) }
        dropdownButton.snp.makeConstraints { $0.size.equalTo(24) }
        pencilIcon.snp.makeConstraints { $0.size.equalTo(16) }
        photoIcon.snp.makeConstraints { $0.size.equalTo(16) }
        photoContentStackView.snp.makeConstraints { $0.height.equalTo(160) }
        keywordIcon.snp.makeConstraints { $0.size.equalTo(16) }
    }
    
    private func configureUI() {
        backgroundColor = TDColor.baseWhite
        layer.cornerRadius = 12
    }
    
    // MARK: - Public Method
    
    public func configure(
        emotionImage: UIImage,
        date: String,
        title: String,
        keywords: [String]? = nil,
        memo: String? = nil,
        photos: [UIImage]? = nil,
        imageURLs: [String]? = nil
    ) {
        emotionImageView.image = emotionImage
        dateLabel.setText(date)
        titleLabel.setText(title)
        
        mainStackView.arrangedSubviews
            .filter { $0 != dateHeaderStackView }
            .forEach { $0.removeFromSuperview() }
        
        if let keywords, !keywords.isEmpty {
            keywordTagListView.configure(keywords: keywords)
            keywordVerticalStackView.isHidden = false
            mainStackView.addArrangedSubview(keywordVerticalStackView)
        } else {
            keywordVerticalStackView.isHidden = true
        }

        if let memo, !memo.isEmpty {
            sentenceContentLabel.setText(memo)
            sentenceVerticalStackView.isHidden = false
            mainStackView.addArrangedSubview(sentenceVerticalStackView)
        }
        
        photoContentStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        currentImageURLs = imageURLs ?? []
        
        
        if let photos, !photos.isEmpty {
            configurePhotos(photos)
            photoVerticalStackView.isHidden = false
            mainStackView.addArrangedSubview(photoVerticalStackView)
        } else {
            photoVerticalStackView.isHidden = true
            let addPhotoButton = createAddPhotoButton(isEmpty: true)
            mainStackView.addArrangedSubview(addPhotoButton)
        }
    }
    
    // MARK: - Helpers
    
    private func configurePhotos(_ photos: [UIImage]) {
        photoContentStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for (index, photo) in photos.prefix(2).enumerated() {
            let imageView = createPhotoView(photo, index: index)
            photoContentStackView.addArrangedSubview(imageView)
        }
        
        if photos.count == 1 {
            photoContentStackView.addArrangedSubview(createAddPhotoButton(isEmpty: false))
        }
    }
    
    private func createPhotoView(_ image: UIImage, index: Int) -> UIImageView {
        let imageView = UIImageView().then {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 12
            $0.image = image
            $0.isUserInteractionEnabled = true
            $0.tag = index
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleImageTap(_:)))
        imageView.addGestureRecognizer(tapGesture)
        
        return imageView
    }
    
    @objc
    private func handleImageTap(_ sender: UITapGestureRecognizer) {
        guard let tappedView = sender.view else { return }
        let index = tappedView.tag
        
        guard currentImageURLs.indices.contains(index) else { return }
        
        let detailVC = DetailImageViewController(imageUrlList: currentImageURLs, selectedIndex: index)
        
        if let parentVC = findViewController() {
            parentVC.navigationController?.pushTDViewController(detailVC, animated: true)
        }
    }
    
    private func createAddPhotoButton(isEmpty: Bool) -> UIButton {
        let button = UIButton().then {
            $0.setImage(TDImage.plus, for: .normal)
            $0.setTitle(isEmpty ? "사진 추가" : nil, for: .normal)
            $0.setTitleColor(TDColor.Neutral.neutral700, for: .normal)
            $0.titleLabel?.font = TDFont.boldBody1.font
            $0.backgroundColor = TDColor.baseWhite
            $0.layer.cornerRadius = 12
            $0.layer.borderWidth = 1
            $0.layer.borderColor = TDColor.Neutral.neutral300.cgColor
            $0.snp.makeConstraints { $0.height.equalTo(52) }
        }
        
        button.addAction(UIAction { [weak self] _ in
            self?.delegate?.didTapAddPhotoButton(nil)
        }, for: .touchUpInside)
        
        return button
    }
}
