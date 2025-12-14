import UIKit
import TDDomain
import TDDesign

final class DiaryKeywordView: BaseView {
    var selectedKeywords: [UserKeyword] = []
    private var viewType: DiaryKeywordViewType = .navigation

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
    
    // 시트 모드용 헤더
    private let sheetHeaderStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .center
    }
    
    private let sheetHeaderIcon = UIImageView(image: TDImage.Tomato.tomatoSmallEmtpy).then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let sheetHeaderLabel = TDLabel(
        labelText: "오늘의 키워드",
        toduckFont: .boldHeader4,
        toduckColor: TDColor.Neutral.neutral800
    )
    
    let keywordCategorySegment = TDSegmentedControl(
        items: ["전체"] + UserKeywordCategory.allCases.map { $0.title },
        indicatorForeGroundColor: TDColor.baseWhite
    )
    
    let keywordButtonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.backgroundColor = TDColor.baseWhite
        $0.spacing = 8
        $0.alignment = .leading
        $0.distribution = .fillProportionally
    }
    
    // 삭제 모드용 레이블
    private let deleteModeLabel = TDLabel(
        labelText: "· 삭제 할 키워드를 선택해주세요",
        toduckFont: .boldBody2,
        toduckColor: TDColor.Semantic.error
    )
    
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
    
    /// 삭제 모드 일때 보여주는 버튼 뷰
    let removeKeywordbuttonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.backgroundColor = TDColor.baseWhite
        $0.spacing = 10
        $0.alignment = .leading
    }
    
    let removeKeywordCancelButton = TDBaseButton(
        title: "취소",
        backgroundColor: TDColor.baseWhite,
        foregroundColor: TDColor.Neutral.neutral700,
        radius: 12,
        font: TDFont.boldHeader3.font
    )
    
    let removeKeywordRemoveButton = TDBaseButton(
        title: "삭제",
        backgroundColor: TDColor.Semantic.error,
        foregroundColor: TDColor.baseWhite,
        radius: 12,
        font: TDFont.boldHeader3.font
    ).then {
        $0.isEnabled = false
    }
    
    private(set) lazy var keywordCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: LeftAlignedCollectionViewFlowLayout().then {
            $0.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            $0.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 20)
            $0.minimumLineSpacing = 12
            $0.minimumInteritemSpacing = 8
            $0.sectionInset = UIEdgeInsets(
                top: 16,
                left: 0,
                bottom: 32,
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
        // 시트 모드용 헤더
        sheetHeaderStackView.addArrangedSubview(sheetHeaderIcon)
        sheetHeaderStackView.addArrangedSubview(sheetHeaderLabel)
        addSubview(sheetHeaderStackView)
        
        addSubview(keywordCategorySegment)
        addSubview(keywordButtonStackView)
        keywordButtonStackView.addArrangedSubview(keywordAddButton)
        keywordButtonStackView.addArrangedSubview(keywordRemoveButton)
        
        addSubview(deleteModeLabel)
        
        addSubview(keywordCollectionView)
        
        addSubview(buttonStackView)
        buttonStackView.addArrangedSubview(skipButton)
        buttonStackView.addArrangedSubview(saveButton)
        
        addSubview(removeKeywordbuttonStackView)
        removeKeywordbuttonStackView.addArrangedSubview(removeKeywordCancelButton)
        removeKeywordbuttonStackView.addArrangedSubview(removeKeywordRemoveButton)
        
        // 네비게이션 모드일 때만 추가 UI 요소들 추가
        addSubview(labelStackView)
        labelStackView.addArrangedSubview(titleLabel)
        labelStackView.addArrangedSubview(descriptionLabel)
        
        addSubview(currentBookImageView)
        addSubview(noSelectedLabel)
        addSubview(selectedKeywordScrollView)
        selectedKeywordScrollView.addSubview(selectedKeywordContainerView)
        selectedKeywordContainerView.addSubview(selectedKeywordStackView)
    }
    
    override func layout() {
        // viewType이 설정되지 않았으면 기본값으로 navigation 모드 레이아웃 설정
        if viewType == .navigation {
            layoutForNavigationMode()
        } else {
            layoutForSheetMode()
        }
    }
    
    private func layoutForSheetMode() {
        sheetHeaderStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.leading.equalToSuperview().inset(16)
        }
        
        sheetHeaderIcon.snp.makeConstraints { make in
            make.size.equalTo(24)
        }
        
        keywordCategorySegment.snp.makeConstraints { make in
            make.top.equalTo(sheetHeaderStackView.snp.bottom).offset(16)
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
        
        buttonStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(56)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(28)
        }
        
        removeKeywordbuttonStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(56)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(28)
        }
        
        keywordCollectionView.snp.makeConstraints { make in
            make.top.equalTo(keywordButtonStackView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(buttonStackView.snp.top).offset(-16)
        }
    }
    
    private func layoutForNavigationMode() {
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
            make.height.equalTo(70)
            make.horizontalEdges.equalToSuperview().inset(50)
        }
        
        selectedKeywordContainerView.snp.makeConstraints { make in
            make.edges.equalTo(selectedKeywordScrollView.contentLayoutGuide)
            make.height.equalTo(selectedKeywordScrollView.frameLayoutGuide.snp.height)
        }

        selectedKeywordStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalToSuperview()
        }

        keywordCategorySegment.snp.makeConstraints { make in
            make.top.equalTo(currentBookImageView.snp.bottom).offset(56)
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
        
        deleteModeLabel.snp.makeConstraints { make in
            make.top.equalTo(keywordCategorySegment.snp.bottom).offset(12)
            make.leading.equalToSuperview().inset(16)
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
        
        removeKeywordbuttonStackView.snp.makeConstraints {
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
        removeKeywordCancelButton.layer.borderWidth = 1
        removeKeywordCancelButton.layer.borderColor = TDColor.Neutral.neutral300.cgColor
        removeKeywordbuttonStackView.isHidden = true
        deleteModeLabel.isHidden = true
    }
    
    func configure(for viewType: DiaryKeywordViewType) {
        self.viewType = viewType

        switch viewType {
        case .sheet:
            sheetHeaderStackView.isHidden = false
            labelStackView.isHidden = true
            currentBookImageView.isHidden = true
            noSelectedLabel.isHidden = true
            selectedKeywordScrollView.isHidden = true
            skipButton.isHidden = false
            skipButton.updateTitle("취소")
        case .navigation:
            sheetHeaderStackView.isHidden = true
            labelStackView.isHidden = false
            currentBookImageView.isHidden = false
            selectedKeywordScrollView.isHidden = false
            skipButton.isHidden = false
            skipButton.updateTitle("건너뛰기")
        }

        // 제약조건 업데이트
        updateLayoutConstraints()
    }
    
    private func updateLayoutConstraints() {
        // 기존 제약조건 제거
        snp.removeConstraints()
        keywordCategorySegment.snp.removeConstraints()
        keywordButtonStackView.snp.removeConstraints()
        keywordAddButton.snp.removeConstraints()
        keywordRemoveButton.snp.removeConstraints()
        keywordCollectionView.snp.removeConstraints()
        buttonStackView.snp.removeConstraints()
        removeKeywordbuttonStackView.snp.removeConstraints()
        sheetHeaderStackView.snp.removeConstraints()
        sheetHeaderIcon.snp.removeConstraints()
        labelStackView.snp.removeConstraints()
        currentBookImageView.snp.removeConstraints()
        noSelectedLabel.snp.removeConstraints()
        selectedKeywordScrollView.snp.removeConstraints()
        selectedKeywordContainerView.snp.removeConstraints()
        selectedKeywordStackView.snp.removeConstraints()
        
        // 새로운 제약조건 설정
        switch viewType {
        case .sheet:
            layoutForSheetMode()
        case .navigation:
            layoutForNavigationMode()
        }
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    func updateSelectedKeywords(_ keywords: [UserKeyword]) {
        selectedKeywords = keywords
        
        selectedKeywordStackView.arrangedSubviews.forEach { view in
            selectedKeywordStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        // 시트 모드에서는 noSelectedLabel을 항상 숨김
        if viewType == .sheet {
            noSelectedLabel.isHidden = true
        } else {
            // 네비게이션 모드에서만 noSelectedLabel 표시/숨김 처리
            if keywords.isEmpty {
                noSelectedLabel.isHidden = false
            } else {
                noSelectedLabel.isHidden = true
            }
        }
        
        if !keywords.isEmpty {
            for keyword in keywords {
                let tagContainer = makeKeywordView(keyword: keyword.name)
                selectedKeywordStackView.addArrangedSubview(tagContainer)
            }
            
            DispatchQueue.main.async {
                self.selectedKeywordScrollView.flashScrollIndicators()
            }
        }
        
        updateBookImage()
    }
    
    func makeKeywordView(keyword: String) -> UIView {
        let tagContainer = UIView().then {
            $0.layer.borderWidth = 1
            $0.layer.borderColor = TDColor.Neutral.neutral300.cgColor
            $0.backgroundColor = TDColor.baseWhite
            $0.layer.cornerRadius = 8
        }
        let tagLabel = TDLabel(
            toduckFont: .mediumBody2,
            toduckColor: TDColor.Neutral.neutral700
        ).then {
            $0.numberOfLines = 1
            $0.setContentHuggingPriority(.required, for: .horizontal)
            $0.setContentCompressionResistancePriority(.required, for: .horizontal)
            $0.setText(keyword)
        }
        
        tagContainer.addSubview(tagLabel)
        tagContainer.snp.makeConstraints { make in
            make.height.equalTo(32)
        }
        tagLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(12)
            make.top.bottom.equalToSuperview().inset(6)
            make.centerY.equalToSuperview()
        }
        return tagContainer
    }
    
    func setRemoveMode() {
        // 텍스트 변경
        titleLabel.setText("삭제 할 키워드를 선택해주세요")
        descriptionLabel.setText("필요없는 키워드를 삭제해요")
        
        // 버튼 숨김 및 레이블 표시
        keywordButtonStackView.isHidden = true
        deleteModeLabel.isHidden = false
        
        removeKeywordbuttonStackView.isHidden = false
        buttonStackView.isHidden = true
        currentBookImageView.alpha = 0.3
        selectedKeywordContainerView.alpha = 0.3
        currentBookImageView.isUserInteractionEnabled = false
        
        // CollectionView의 top constraint 재설정
        keywordCollectionView.snp.remakeConstraints { make in
            make.top.equalTo(deleteModeLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(buttonStackView.snp.top).offset(-16)
        }
    }
    
    func setNormalMode() {
        // 텍스트 원복
        titleLabel.setText("하루를 키워드로 정리해 볼까요?")
        descriptionLabel.setText("책을 꾹 누르면 선택 키워드가 초기화 돼요")
        
        // 버튼 표시 및 레이블 숨김
        keywordButtonStackView.isHidden = false
        deleteModeLabel.isHidden = true
        
        removeKeywordbuttonStackView.isHidden = true
        buttonStackView.isHidden = false
        currentBookImageView.alpha = 1
        selectedKeywordContainerView.alpha = 1
        currentBookImageView.isUserInteractionEnabled = true
        
        // CollectionView의 top constraint 재설정
        keywordCollectionView.snp.remakeConstraints { make in
            make.top.equalTo(keywordButtonStackView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(buttonStackView.snp.top).offset(-16)
        }
    }
    
    private func updateBookImage() {
        let categoryCount = Set(selectedKeywords.map { $0.category }).count
        switch categoryCount {
        case 1:
            currentBookImageView.image = TDImage.BookKeyword.one
        case 2:
            currentBookImageView.image = TDImage.BookKeyword.two
        case 3:
            currentBookImageView.image = TDImage.BookKeyword.three
        case 4:
            currentBookImageView.image = TDImage.BookKeyword.four
        default:
            currentBookImageView.image = TDImage.BookKeyword.none
        }
    }
}
