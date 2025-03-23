import UIKit
import Then

public final class DiaryDetailView: UIView {
    
    // MARK: - UI Components
    
    // 공통 요소
    private let emotionContainerView = UIView()
    private let emotionImageView = UIImageView()
    private let dateLabel = TDLabel(toduckFont: TDFont.mediumCaption1, toduckColor: TDColor.Neutral.neutral600)
    private let titleLabel = TDLabel(toduckFont: TDFont.mediumBody2, toduckColor: TDColor.Neutral.neutral900)
    private let dropdownButton = TDBaseButton(image: TDImage.Dot.verticalMedium, backgroundColor: TDColor.baseWhite, foregroundColor: TDColor.Neutral.neutral500)
    
    // 섹션 컨테이너
    private lazy var contentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 24
    }
    
    // 문장 기록 섹션 (Lazy)
    private lazy var sentenceSection: UIView = {
        let container = UIView()
        let titleStack = UIStackView().then {
            $0.axis = .horizontal
            $0.spacing = 4
            $0.alignment = .center
        }
        
        let pencilIcon = UIImageView(image: TDImage.Pen.penNeutralColor)
        let sectionTitleLabel = TDLabel(
            labelText: "문장 기록",
            toduckFont: TDFont.boldBody2,
            toduckColor: TDColor.Neutral.neutral600
        )
        let contentLabel = TDLabel(
            toduckFont: TDFont.mediumBody2,
            toduckColor: TDColor.Neutral.neutral600
        ).then {
            $0.numberOfLines = 0
            $0.textAlignment = .natural
        }
        
        titleStack.addArrangedSubview(pencilIcon)
        titleStack.addArrangedSubview(sectionTitleLabel)
        container.addSubview(titleStack)
        container.addSubview(contentLabel)
        
        pencilIcon.snp.makeConstraints { $0.size.equalTo(16) }
        
        titleStack.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(titleStack.snp.bottom).offset(12)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        return container
    }()
    
    // 사진 기록 섹션 (Lazy)
    private lazy var photoSection: UIView = {
        let container = UIView()
        let photoIcon = UIImageView(image: TDImage.photo)
        let titleLabel = TDLabel(labelText: "사진 기록", toduckFont: TDFont.boldBody2, toduckColor: TDColor.Neutral.neutral600)
        let stackView = UIStackView().then {
            $0.axis = .horizontal
            $0.spacing = 12
            $0.distribution = .fillEqually
        }
        
        [photoIcon, titleLabel, stackView].forEach { container.addSubview($0) }
        
        photoIcon.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.size.equalTo(16)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(photoIcon)
            $0.leading.equalTo(photoIcon.snp.trailing).offset(4)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(photoIcon.snp.bottom).offset(12)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(160)
        }
        
        return container
    }()
    
    // MARK: - Properties
    private var photoStackView: UIStackView? {
        return photoSection.subviews.first(where: { $0 is UIStackView }) as? UIStackView
    }
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCommonUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    private func setupCommonUI() {
        backgroundColor = TDColor.baseWhite
        layer.cornerRadius = 12
        
        [emotionContainerView, dateLabel, titleLabel, dropdownButton, contentStackView].forEach {
            addSubview($0)
        }
        
        emotionContainerView.addSubview(emotionImageView)
    }
    
    private func setupLayout() {
        emotionContainerView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(16)
            $0.size.equalTo(32)
        }
        
        emotionImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints {
            $0.centerY.equalTo(emotionContainerView)
            $0.leading.equalTo(emotionContainerView.snp.trailing).offset(8)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(4)
            $0.leading.equalTo(dateLabel)
            $0.trailing.equalTo(dropdownButton.snp.leading).offset(-8)
        }
        
        dropdownButton.snp.makeConstraints {
            $0.centerY.equalTo(emotionContainerView)
            $0.trailing.equalToSuperview().inset(16)
            $0.size.equalTo(24)
        }
        
        contentStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(24)
        }
    }
    
    // MARK: - Public Methods
    public func configure(
        emotionImage: UIImage,
        date: String,
        title: String,
        sentences: [String]? = nil,
        photos: [UIImage]? = nil
    ) {
        emotionImageView.image = emotionImage
        dateLabel.setText(date)
        titleLabel.setText(title)
        
        // 문장 기록 추가
        if let sentences, !sentences.isEmpty {
            let contentLabel = sentenceSection.subviews
                .compactMap { $0 as? TDLabel }
                .first(where: { $0.text != "문장 기록" })
            
            contentLabel?.setText(sentences.joined(separator: "\n\n"))
            contentStackView.addArrangedSubview(sentenceSection)
        }
        
        // 사진 기록 추가
        if let photos = photos, !photos.isEmpty {
            setupPhotos(photos)
            contentStackView.addArrangedSubview(photoSection)
        }
    }
    
    // MARK: - Private Methods
    private func setupPhotos(_ photos: [UIImage]) {
        photoStackView?.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        photos.prefix(2).forEach { image in
            let imageView = UIImageView().then {
                $0.contentMode = .scaleAspectFit
                $0.layer.cornerRadius = 12
                $0.clipsToBounds = true
                $0.image = image
            }
            photoStackView?.addArrangedSubview(imageView)
        }
        
        if photos.count == 1 {
            let addPhotoButton = TDBaseButton(
                image: TDImage.plus,
                backgroundColor: TDColor.baseWhite,
                foregroundColor: TDColor.Neutral.neutral500,
                radius: 12
            )
            addPhotoButton.layer.borderWidth = 1
            addPhotoButton.layer.borderColor = TDColor.Neutral.neutral300.cgColor
            photoStackView?.addArrangedSubview(addPhotoButton)
        }
    }
    
    // MARK: - Dynamic Height
    override public var intrinsicContentSize: CGSize {
        let totalHeight = contentStackView.arrangedSubviews
            .map { $0.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height }
            .reduce(0, +)
        
        return CGSize(
            width: UIView.noIntrinsicMetric,
            height: totalHeight + 120
        )
    }
}
