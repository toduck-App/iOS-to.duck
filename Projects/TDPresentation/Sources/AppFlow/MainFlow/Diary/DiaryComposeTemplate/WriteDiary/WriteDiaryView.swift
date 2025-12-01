import UIKit
import TDDomain
import TDDesign

final class WriteDiaryView: BaseView {
    let scrollView = UIScrollView()
    
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 0
        $0.alignment = .fill
        $0.distribution = .fill
    }
    
    let titleLabel = TDLabel(
        labelText: "오늘을 돌아보고, 내일을 준비해요",
        toduckFont: .boldHeader4,
        alignment: .center,
        toduckColor: TDColor.Neutral.neutral800
    )
    
    let descriptionLabel = TDLabel(
        labelText: "한 줄도 괜찮아요! 편하게 작성해봐요",
        toduckFont: .mediumBody2,
        alignment: .center,
        toduckColor: TDColor.Neutral.neutral600
    )
    
    let imageView = UIImageView().then {
        $0.image = TDImage.Diary.diaryThumnail
        $0.contentMode = .scaleAspectFit
    }
    
    let recordTextView = TDFormTextView(
        image: TDImage.Pen.penNeutralColor,
        title: "회고 작성",
        titleFont: .boldBody2,
        titleColor: TDColor.Neutral.neutral600,
        isRequired: true,
        maxCharacter: 2000,
        placeholder: "자유롭게 내용을 작성해 주세요.",
        maxHeight: 196
    )
    
    let formPhotoView = TDFormPhotoView(
        image: TDImage.photo,
        titleText: "사진 기록",
        titleFont: .boldBody2,
        titleColor: TDColor.Neutral.neutral600,
        isRequired: false,
        maxCount: 2
    )
    
    let buttonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.backgroundColor = TDColor.baseWhite
        $0.spacing = 10
        $0.alignment = .leading
    }
    
    let skipButton = TDBaseButton(
        title: "건너뛰기",
        backgroundColor: TDColor.baseWhite,
        foregroundColor: TDColor.Neutral.neutral700,
        radius: 12,
        font: TDFont.boldHeader3.font
    ).then {
        $0.layer.borderWidth = 1
        $0.layer.borderColor = TDColor.Neutral.neutral300.cgColor
    }
    
    let saveButton = TDBaseButton(
        title: "저장",
        backgroundColor: TDColor.Primary.primary500,
        foregroundColor: TDColor.baseWhite,
        radius: 12,
        font: TDFont.boldHeader3.font
    )

    
    // MARK: - Common Methods
    
    override func addview() {
        addSubview(scrollView)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(imageView)
        
        stackView.addArrangedSubview(recordTextView)
        stackView.addArrangedSubview(formPhotoView)
        
        stackView.setCustomSpacing(8, after: titleLabel)
        stackView.setCustomSpacing(14, after: recordTextView)

        addSubview(buttonStackView)
        buttonStackView.addArrangedSubview(skipButton)
        buttonStackView.addArrangedSubview(saveButton)
    }
    
    override func layout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(42)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
            make.width.equalTo(scrollView.snp.width).offset(-32)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
        
        imageView.snp.makeConstraints { make in
            make.size.equalTo(240)
        }
        
        recordTextView.snp.makeConstraints { make in
            make.height.equalTo(230)
        }

        formPhotoView.snp.makeConstraints { make in
            make.height.equalTo(160)
        }

        buttonStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(56)
            $0.bottom.equalToSuperview().inset(28)
        }
    }
    
    override func configure() {
        backgroundColor = TDColor.baseWhite
        saveButton.isEnabled = false
    }
}
