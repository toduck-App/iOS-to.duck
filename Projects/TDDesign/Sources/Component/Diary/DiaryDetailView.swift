import UIKit
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
    
    // MARK: - Initializers
    
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
        sentences: String? = nil,
        photos: [UIImage]? = nil
    ) {
        emotionImageView.image = emotionImage
        dateLabel.setText(date)
        titleLabel.setText(title)
        
        mainStackView.arrangedSubviews
            .filter { $0 != dateHeaderStackView }
            .forEach { $0.removeFromSuperview() }
        
        if let sentences, !sentences.isEmpty {
            sentenceContentLabel.text = sentences
            sentenceVerticalStackView.isHidden = false
            mainStackView.addArrangedSubview(sentenceVerticalStackView)
        }
        
        photoContentStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
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
        
        switch photos.count {
        case 1:
            photoContentStackView.addArrangedSubview(createPhotoView(photos[0]))
            photoContentStackView.addArrangedSubview(createAddPhotoButton(isEmpty: false))
        case 2...:
            photos.prefix(2).forEach { photoContentStackView.addArrangedSubview(createPhotoView($0)) }
        default:
            break
        }
    }
    
    private func createPhotoView(_ image: UIImage) -> UIImageView {
        return UIImageView().then {
            $0.contentMode = .scaleAspectFit
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 12
            $0.image = image
        }
    }
    
    private func createAddPhotoButton(isEmpty: Bool) -> UIButton {
        return UIButton().then {
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
    }
}
