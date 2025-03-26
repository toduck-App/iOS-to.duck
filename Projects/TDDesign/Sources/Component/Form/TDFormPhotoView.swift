import SnapKit
import Then
import UIKit

public protocol TDFormPhotoDelegate: AnyObject {
    func didTapAddPhotoButton(_ view: TDFormPhotoView?)
}

/// 프로필 또는 게시물 등에서 사진을 추가할 수 있는 폼의 사진 입력 뷰를 나타내는 `TDFormPhotoView` 클래스입니다.
/// 사용자가 최대 지정된 개수만큼 사진을 추가할 수 있으며, 추가된 사진의 썸네일을 스크롤 뷰에 표시합니다.
/// TDPhotoPickerController 와 함께 사용합니다.
public final class TDFormPhotoView: UIView {
    
    // MARK: - Properties
    
    /// 사진 추가 이벤트를 전달받을 델리게이트입니다.
    public weak var delegate: TDFormPhotoDelegate?
    
    /// 최대 사진 개수.
    private let maxCount: Int
    
    /// 필수 항목 여부.
    private let isRequired: Bool
    
    // MARK: - UI Components
    
    /// 제목과 필수 표시(*)를 포함하는 레이블 뷰.
    private let title = TDRequiredTitle()
    
    /// 현재 추가된 사진 개수를 표시하는 레이블.
    private let currentCounterLabel = TDLabel(
        toduckFont: .regularBody2,
        toduckColor: TDColor.Neutral.neutral800
    ).then {
        $0.setText("0")
    }
    
    /// 최대 사진 개수를 표시하는 레이블.
    private let maxCounterLabel = TDLabel(
        toduckFont: .regularBody2,
        toduckColor: TDColor.Neutral.neutral600
    )
    
    /// 사진을 추가하는 버튼.
    private let addPhotoButton = UIButton().then {
        $0.layer.cornerRadius = 12
        $0.backgroundColor = TDColor.Neutral.neutral100
        let image = TDImage.Camera.cameraMedium.withRenderingMode(.alwaysOriginal)
            .withTintColor(TDColor.Neutral.neutral600)
        $0.setImage(image, for: .normal)
        $0.imageView?.contentMode = .scaleAspectFit
    }
    
    /// 추가된 사진을 스크롤할 수 있는 스크롤 뷰.
    private let photoScrollView = UIScrollView().then {
        $0.showsHorizontalScrollIndicator = false
    }
    
    /// 사진 썸네일을 배치하는 스택 뷰.
    private let photoStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .center
        $0.distribution = .fill
    }

    /// 사진 업로드에 대한 안내 문구를 표시하는 레이블.
    private let captionLabel = TDLabel(
        labelText: "사진은 10MB 이하의 PNG, GIF, JPG 파일만 등록할 수 있습니다.",
        toduckFont: .regularCaption1,
        toduckColor: TDColor.Neutral.neutral500
    )

    // MARK: - Initializer
    
    /// `TDFormPhotoView`의 기본 이니셜라이저입니다.
    ///
    /// - Parameters:
    ///   - frame: 뷰의 프레임. 기본값은 `.zero`입니다.
    ///   - titleText: 제목 텍스트 (예: "사진 첨부"). 기본값은 "사진 첨부"입니다.
    ///   - isRequired: 필수 항목 여부. `true`일 경우 제목 옆에 별표(*)가 표시됩니다. 기본값은 `false`입니다.
    ///   - maxCount: 추가할 수 있는 최대 사진 개수. 기본값은 `5`입니다.
    public init(
        frame: CGRect = .zero,
        titleText: String = "사진 첨부",
        titleColor: UIColor = TDColor.Neutral.neutral800,
        isRequired: Bool = false,
        maxCount: Int = 5
    ) {
        self.isRequired = isRequired
        self.maxCount = maxCount
        super.init(frame: frame)
        
        // 타이틀 설정
        title.setTitleLabel(titleText)
        title.setTitleColor(titleColor)
        
        // 필수 항목 여부에 따라 별표(*) 표시
        if isRequired {
            title.setRequiredLabel()
        }
        
        // 최대 개수 표시
        maxCounterLabel.setText("/ \(maxCount)")
        
        setLayout()
        setAction()
    }
    
    /// `NSCoder`를 사용한 초기화 이니셜라이저입니다.
    /// Interface Builder나 스토리보드에서 `TDFormPhotoView`를 사용할 수 없도록 설정되어 있습니다.
    ///
    /// - Parameter coder: 디코더 객체.
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    /// 외부에서 선택된 이미지 데이터를 받아 스택 뷰에 썸네일 이미지를 추가합니다.
    /// 기존에 추가된 이미지들은 모두 제거되고 새로 추가된 이미지들로 대체됩니다.
    ///
    /// - Parameter imagesData: 추가할 이미지 데이터 배열.
    public func addPhotos(_ imagesData: [Data]) {
        // 기존 이미지 뷰 제거
        photoStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // 새로 추가
        for data in imagesData {
            guard let image = UIImage(data: data) else {
                // TODO: Error Handling (유효하지 않은 이미지 데이터일 경우)
                continue
            }
            
            let imageView = UIImageView(image: image).then {
                $0.layer.cornerRadius = 8
                $0.contentMode = .scaleAspectFill
                $0.clipsToBounds = true
            }
            
            let containerView = UIView().then {
                $0.layer.cornerRadius = 8
                $0.layer.borderColor = TDColor.Neutral.neutral300.cgColor
                $0.layer.borderWidth = 1
            }
            
            containerView.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
                make.size.equalTo(CGSize(width: 88, height: 88))
            }
            
            photoStackView.addArrangedSubview(containerView)
        }
        
        // 현재 개수 갱신
        let currentCount = photoStackView.arrangedSubviews.count
        currentCounterLabel.setText("\(currentCount)")
    }
}

// MARK: - Layout

extension TDFormPhotoView {
    
    /// 뷰의 레이아웃을 설정합니다.
    private func setLayout() {
        addSubviews()
        setConstraints()
    }
    
    /// 서브뷰들을 추가합니다.
    private func addSubviews() {
        addSubview(title)
        addSubview(currentCounterLabel)
        addSubview(maxCounterLabel)
        addSubview(addPhotoButton)
        addSubview(photoScrollView)
        addSubview(captionLabel)
        photoScrollView.addSubview(photoStackView)
    }
    
    /// 서브뷰들의 제약조건을 설정합니다.
    private func setConstraints() {
        title.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        maxCounterLabel.snp.makeConstraints { make in
            make.centerY.equalTo(title)
            make.trailing.equalToSuperview()
        }
        
        currentCounterLabel.snp.makeConstraints { make in
            make.centerY.equalTo(maxCounterLabel)
            make.trailing.equalTo(maxCounterLabel.snp.leading).offset(-4)
        }
        
        addPhotoButton.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(12)
            make.leading.equalToSuperview()
            make.size.equalTo(88)
        }

        photoScrollView.snp.makeConstraints { make in
            make.centerY.equalTo(addPhotoButton)
            make.leading.equalTo(addPhotoButton.snp.trailing).offset(12)
            make.trailing.equalToSuperview()
            make.height.equalTo(addPhotoButton)
        }

        photoStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        captionLabel.snp.makeConstraints { make in
            make.top.equalTo(addPhotoButton.snp.bottom).offset(12)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: - Actions

extension TDFormPhotoView {
    
    /// 버튼에 대한 액션을 설정합니다.
    private func setAction() {
        addPhotoButton.addAction(UIAction { [weak self] _ in
            self?.delegate?.didTapAddPhotoButton(self)
        }, for: .touchUpInside)
    }
}
