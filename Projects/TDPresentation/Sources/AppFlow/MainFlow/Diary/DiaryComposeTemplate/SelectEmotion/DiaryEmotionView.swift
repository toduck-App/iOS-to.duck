import UIKit
import TDDesign

final class DiaryEmotionView: BaseView {
    // MARK: - UI Components
    
    let titleLabel = TDLabel(
        labelText: "오늘의 기분은 어땠나요?",
        toduckFont: .boldHeader4,
        toduckColor: TDColor.Neutral.neutral800
    )
    let descriptionLabel = TDLabel(
        labelText: "가장 가까운 감정 이모지를 선택해주세요",
        toduckFont: .boldBody2,
        toduckColor: TDColor.Neutral.neutral600
    )
    let emotionGridView = EmotionGridView()
    let commentContainerView = UIView().then {
        $0.layer.cornerRadius = 16
        $0.backgroundColor = TDColor.Neutral.neutral50
    }
    let commentLabel = TDLabel(
        toduckFont: .mediumHeader5,
        alignment: .center,
        toduckColor: TDColor.Neutral.neutral600
    )
    let nextButton = TDBaseButton(
        title: "다음",
        backgroundColor: TDColor.Primary.primary500,
        foregroundColor: TDColor.baseWhite,
        radius: 12,
        font: TDFont.boldHeader3.font,
    ).then {
        $0.isEnabled = false
    }
    
    let simpleDiaryButton = TDBaseButton(
        title: "심플 일기 작성",
        backgroundColor: TDColor.baseWhite,
        foregroundColor: TDColor.Neutral.neutral600,
        font: TDFont.mediumHeader5.font,
    )
    
    // MARK: - Properties
    
    var onEmotionTapped: ((_ index: Int) -> Void)?
    
    // MARK: - Configuration
    
    func configureCommentLabel(_ text: String) {
        commentLabel.setText(text)
    }
    
    func setNextButtonActive(_ isActive: Bool) {
        nextButton.isEnabled = isActive
        commentContainerView.isHidden = !isActive
    }
    
    // MARK: - Common Methods
    
    override func addview() {
        [
            titleLabel,
            descriptionLabel,
            emotionGridView,
            commentContainerView,
            nextButton,
            simpleDiaryButton
        ].forEach { addSubview($0) }
        commentContainerView.addSubview(commentLabel)
    }
    
    override func layout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(42)
            $0.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        emotionGridView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(80)
            $0.leading.trailing.equalToSuperview().inset(62)
            $0.height.equalTo(emotionGridView.snp.width)
        }
        
        commentContainerView.snp.makeConstraints {
            $0.bottom.equalTo(nextButton.snp.top).offset(-28)
            $0.leading.trailing.equalToSuperview().inset(45)
            $0.height.equalTo(48)
        }
        
        commentLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(simpleDiaryButton.snp.top).offset(-16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(56)
        }
        
        simpleDiaryButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-28)
            $0.centerX.equalToSuperview()
        }
    }
    
    override func configure() {
        backgroundColor = TDColor.baseWhite
        commentContainerView.isHidden = true
        commentLabel.adjustsFontSizeToFitWidth = true
        commentLabel.minimumScaleFactor = 0.5
    }
}
