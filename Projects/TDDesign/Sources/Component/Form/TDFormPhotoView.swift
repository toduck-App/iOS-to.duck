import SnapKit
import Then
import UIKit

public protocol TDFormPhotoDelegate: AnyObject {
    func didTapAddPhotoButton(_ view: TDFormPhotoView?)
}

public final class TDFormPhotoView: UIView {
    // MARK: - Properties
    
    public weak var delegate: TDFormPhotoDelegate?
    
    /// 최대 사진 개수
    private let maxCount: Int
    
    /// 필수 항목 여부
    private let isRequired: Bool
    
    // MARK: - UI Components
    
    private let title = TDRequiredTitle()
    
    private let currentCounterLabel = TDLabel(
        toduckFont: .regularBody2,
        toduckColor: TDColor.Neutral.neutral800
    ).then {
        $0.setText("0")
    }
    
    private let maxCounterLabel = TDLabel(
        toduckFont: .regularBody2,
        toduckColor: TDColor.Neutral.neutral600
    )
    
    private let addPhotoButton = UIButton().then {
        $0.layer.cornerRadius = 12
        $0.backgroundColor = TDColor.Neutral.neutral100
        let image = TDImage.cameraMedium.withRenderingMode(.alwaysOriginal)
            .withTintColor(TDColor.Neutral.neutral600)
        $0.setImage(image, for: .normal)
        $0.imageView?.contentMode = .scaleAspectFit
    }
    
    private let photoScrollView = UIScrollView().then {
        $0.showsHorizontalScrollIndicator = false
    }
    
    private let photoStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .center
        $0.distribution = .fill
    }

    private let captionLabel = TDLabel(
        labelText: "사진은 10MB 이하의 PNG, GIF, JPG 파일만 등록할 수 있습니다.",
        toduckFont: .regularCaption1,
        toduckColor: TDColor.Neutral.neutral500
    )

    // MARK: - Initializer
    
    /// - Parameters:
    ///   - titleText: 제목(예: "사진 첨부")
    ///   - isRequired: 필수 항목 여부 (true 시 별표 표시)
    ///   - maxCount: 최대 사진 개수 (기본값 5)
    public init(
        frame: CGRect = .zero,
        titleText: String = "사진 첨부",
        isRequired: Bool = false,
        maxCount: Int = 5
    ) {
        self.isRequired = isRequired
        self.maxCount = maxCount
        super.init(frame: frame)
        
        // 타이틀 설정
        title.setTitleLabel(titleText)
        
        // 필수 항목 여부
        if isRequired {
            title.setRequiredLabel() // 빨간 별(*) 표시 등
        }
        
        // 최대 개수 표시
        maxCounterLabel.setText("/ \(maxCount)")
        
        setLayout()
        setAction()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - [Data]를 받는 함수 & 기존 이미지 제거
    
    /// 외부에서 선택된 `Data` 배열을 받아 스택뷰에 썸네일 이미지를 표시
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
    private func setLayout() {
        addSubviews()
        setConstraints()
    }
    
    private func addSubviews() {
        addSubview(title)
        addSubview(currentCounterLabel)
        addSubview(maxCounterLabel)
        addSubview(addPhotoButton)
        addSubview(photoScrollView)
        addSubview(captionLabel)
        photoScrollView.addSubview(photoStackView)
    }
    
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
    private func setAction() {
        addPhotoButton.addAction(UIAction { [weak self] _ in
            self?.delegate?.didTapAddPhotoButton(self)
        }, for: .touchUpInside)
    }
}
