import UIKit
import TDDesign

final class DiaryKeywordView: BaseView {
    // MARK: - UI Components
    
    let scrollView = UIScrollView()
    let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 0
    }
    
    let labelStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
        $0.alignment = .center
    }
    let titleLabel = TDLabel(
        labelText: "하루를 키워드로 정리해 볼까요?",
        toduckFont: .boldHeader4,
        toduckColor: TDColor.Neutral.neutral800
    )
    let descriptionLabel = TDLabel(
        labelText: "책을 꾹 누르면 선택 키워드가 초기화 돼요",
        toduckFont: .boldBody2,
        toduckColor: TDColor.Neutral.neutral600
    )
    
    let keywordContentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 0
        $0.alignment = .center
    }
    let currentBookImageView = UIImageView(image: TDImage.BookKeyword.none)
    let noSelectedLabel = TDLabel(
        labelText: "키워드를 선택해 주세요",
        toduckFont: .boldBody1,
        toduckColor: TDColor.Neutral.neutral600
    )
    
    let keywordCategorySegment = TDSegmentedControl(items: ["전체", "사람", "장소", "상황", "결과/느낌"])
    
    let buttonContainerView = UIView().then {
        $0.backgroundColor = TDColor.baseWhite
    }
    let buttonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.backgroundColor = TDColor.baseWhite
        $0.spacing = 10
    }
    let skipButton = TDBaseButton(
        title: "건너뛰기",
        backgroundColor: TDColor.baseWhite,
        foregroundColor: TDColor.Neutral.neutral700,
        radius: 12,
        font: TDFont.boldHeader3.font
    )
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
        addSubview(buttonContainerView)
        scrollView.addSubview(stackView)
        
        stackView.addArrangedSubview(labelStackView)
        labelStackView.addArrangedSubview(titleLabel)
        labelStackView.addArrangedSubview(descriptionLabel)
        
        stackView.addArrangedSubview(keywordContentStackView)
        keywordContentStackView.addArrangedSubview(currentBookImageView)
        keywordContentStackView.addArrangedSubview(noSelectedLabel)
        
        stackView.addArrangedSubview(keywordCategorySegment)
        
        buttonContainerView.addSubview(buttonStackView)
        buttonStackView.addArrangedSubview(skipButton)
        buttonStackView.addArrangedSubview(saveButton)
    }
    
    override func layout() {
        scrollView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(buttonContainerView.snp.top)
        }
        stackView.snp.makeConstraints {
            $0.top.equalTo(scrollView.contentLayoutGuide).offset(40)
            $0.leading.trailing.bottom.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        currentBookImageView.snp.makeConstraints {
            $0.size.equalTo(240)
        }

        stackView.setCustomSpacing(60, after: keywordContentStackView)
        
        keywordCategorySegment.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(44)
        }
        
        buttonContainerView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(112)
        }
        buttonStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(56)
        }
    }
    
    override func configure() {
        backgroundColor = TDColor.baseWhite
        skipButton.layer.borderWidth = 1
        skipButton.layer.borderColor = TDColor.Neutral.neutral300.cgColor
    }
}
