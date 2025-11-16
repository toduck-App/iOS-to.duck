import UIKit
import TDDesign

final class DiaryKeywordView: BaseView {
    let labelStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
        $0.alignment = .center
        $0.distribution = .fillProportionally
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
    
    let currentBookImageView = UIImageView(image: TDImage.BookKeyword.none)
    
    let noSelectedLabel = TDLabel(
        labelText: "키워드를 선택해 주세요",
        toduckFont: .boldBody1,
        toduckColor: TDColor.Neutral.neutral600
    )
    
    let selectedKeywordContainerView = UIView()
    
    let selectedKeywordScrollView = UIScrollView().then {
        $0.isScrollEnabled = true
        $0.alwaysBounceHorizontal = true
        $0.alwaysBounceVertical = false
        $0.showsHorizontalScrollIndicator = true
        $0.showsVerticalScrollIndicator = false
    }
    
    let selectedKeywordStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
        $0.alignment = .leading
        $0.distribution = .fill
    }
    
    let keywordCategorySegment = TDSegmentedControl(
        items: ["전체", "사람", "장소", "상황", "결과/느낌"],
        indicatorForeGroundColor: TDColor.baseWhite
    )
    
    let keywordButtonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.backgroundColor = TDColor.baseWhite
        $0.spacing = 8
        $0.alignment = .leading
        $0.distribution = .fillProportionally
    }
    
    let keywordAddButton = TDBaseButton(
        title: "키워드 추가 +",
        backgroundColor: TDColor.baseWhite,
        foregroundColor: TDColor.Neutral.neutral700,
        radius: 8,
        font: TDFont.mediumBody2.font
    ).then {
        $0.layer.borderWidth = 1
        $0.layer.borderColor = TDColor.Neutral.neutral300.cgColor
    }
    
    let keywordRemoveButton = TDBaseButton(
        title: "삭제",
        backgroundColor: TDColor.baseWhite,
        foregroundColor: TDColor.Neutral.neutral700,
        radius: 8,
        font: TDFont.mediumBody2.font
    ).then {
        $0.layer.borderWidth = 1
        $0.layer.borderColor = TDColor.Neutral.neutral300.cgColor
    }
        
    
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
    )
    
    let saveButton = TDBaseButton(
        title: "저장",
        backgroundColor: TDColor.Primary.primary500,
        foregroundColor: TDColor.baseWhite,
        radius: 12,
        font: TDFont.boldHeader3.font
    )
    
    private(set) lazy var keywordCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: LeftAlignedCollectionViewFlowLayout().then {
            $0.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            $0.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 20)
            $0.minimumLineSpacing = 10
            $0.minimumInteritemSpacing = 10
            $0.sectionInset = UIEdgeInsets(
                top: 12,
                left: 0,
                bottom: 28,
                right: 0
            )
        }
    ).then {
        $0.backgroundColor = TDColor.baseWhite
        $0.isScrollEnabled = true
        $0.register(with: DiaryKeywordCell.self)
        $0.register(
            DiaryKeywordHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: DiaryKeywordHeader.identifier
        )
    }
    
    // MARK: - Common Methods
    
    override func addview() {
        addSubview(labelStackView)
        labelStackView.addArrangedSubview(titleLabel)
        labelStackView.addArrangedSubview(descriptionLabel)
        
        addSubview(currentBookImageView)
        addSubview(noSelectedLabel)
        addSubview(selectedKeywordScrollView)
        selectedKeywordScrollView.addSubview(selectedKeywordContainerView)
        selectedKeywordContainerView.addSubview(selectedKeywordStackView)
        
        
        addSubview(keywordCategorySegment)
        addSubview(keywordButtonStackView)
        keywordButtonStackView.addArrangedSubview(keywordAddButton)
        keywordButtonStackView.addArrangedSubview(keywordRemoveButton)
        
        addSubview(buttonStackView)
        buttonStackView.addArrangedSubview(skipButton)
        buttonStackView.addArrangedSubview(saveButton)
    }
    
    override func layout() {
        
        labelStackView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(42)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        currentBookImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(labelStackView.snp.bottom)
            make.size.equalTo(240)
        }
        
        noSelectedLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(currentBookImageView.snp.bottom)
        }
        
        selectedKeywordScrollView.snp.makeConstraints { make in
            make.top.equalTo(currentBookImageView.snp.bottom)
            make.height.equalTo(48)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        selectedKeywordContainerView.snp.makeConstraints { make in
            make.edges.equalTo(selectedKeywordScrollView.contentLayoutGuide)
            make.height.equalTo(selectedKeywordScrollView.frameLayoutGuide)
        }
        
        selectedKeywordStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        keywordCategorySegment.snp.makeConstraints { make in
            make.top.equalTo(currentBookImageView.snp.bottom).offset(96)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        keywordButtonStackView.snp.makeConstraints { make in
            make.top.equalTo(keywordCategorySegment.snp.bottom).offset(12)
            make.leading.equalToSuperview().inset(16)
        }
        
        keywordAddButton.snp.makeConstraints { make in
            make.height.equalTo(32)
        }
        
        keywordRemoveButton.snp.makeConstraints { make in
            make.height.equalTo(32)
        }
        
        keywordCollectionView.snp.makeConstraints { make in
            make.top.equalTo(keywordButtonStackView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(buttonStackView.snp.top).offset(-16)
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
        skipButton.layer.borderWidth = 1
        skipButton.layer.borderColor = TDColor.Neutral.neutral300.cgColor
    }
}
