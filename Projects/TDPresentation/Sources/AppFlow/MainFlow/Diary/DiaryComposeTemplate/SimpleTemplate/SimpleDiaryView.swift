import UIKit
import SnapKit
import TDDesign
import Then

final class SimpleDiaryView: BaseView {
    // MARK: - UI Components
    let scrollView = UIScrollView()
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 32
    }
    
    // 감정 선택
    private let diaryMoodVerticalStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 24
    }
    private let diaryMoodLabelContainerView = UIView()
    private let diaryMoodLabel = TDRequiredTitle()
    private let infoLabel = TDLabel(
        labelText: "* 필수 항목",
        toduckFont: .mediumBody3,
        toduckColor: TDColor.Neutral.neutral500
    )
    let diaryMoodCollectionView = DiaryMoodCollectionView()
    let divideLineView = UIView.dividedLine()
    
    // 제목
    let titleForm = TDFormTextField(
        title: "제목",
        isRequired: false,
        maxCharacter: 16,
        placeholder: "미작성 시 선택 감정에 따라 자동 입력돼요"
    )
    
    // 키워드 섹션
    private let keywordVerticalStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 12
        $0.distribution = .fill
        $0.alignment = .leading
    }
    
    private let keywordHeaderContainerView = UIView()

    private let keywordHeaderTitleView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
        $0.alignment = .center
    }
    
    private let keywordHeaderDeleteView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 0
        $0.alignment = .center
        $0.distribution = .fill
        $0.isUserInteractionEnabled = true
    }
    
    // 키워드 헤더에 있는 삭제 버튼 (오늘의 키워드 옆)
    let keywordHeaderDeleteButton = TDBaseButton(
        title: "삭제",
        backgroundColor: TDColor.baseWhite,
        foregroundColor: TDColor.Neutral.neutral600,
        font: TDFont.boldBody2.font
    )
    
    let diaryKeywordDeleteButton = TDBaseButton(
        title: "삭제",
        backgroundColor: TDColor.baseWhite,
        foregroundColor: TDColor.Neutral.neutral600,
        font: TDFont.boldBody2.font
    )
    
    private let diaryKeywordDividerView = UIView.diviedHorizontalLine(color: TDColor.Neutral.neutral600)
    
    let diaryKeywordCancelButton = TDBaseButton(
        title: "취소",
        backgroundColor: TDColor.baseWhite,
        foregroundColor: TDColor.Neutral.neutral600,
        font: TDFont.boldBody2.font
    )
    

    private let keywordIcon = UIImageView(image: TDImage.Tomato.tomatoSmallEmtpy)
    
    private let keywordTitleLabel = TDLabel(
        labelText: "오늘의 키워드",
        toduckFont: TDFont.boldBody2,
        toduckColor: TDColor.Neutral.neutral600
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

    let keywordTagListView = TodayKeywordTagListView()

    private let deleteModeLabel = TDLabel(
        labelText: "· 삭제 할 키워드를 선택해주세요",
        toduckFont: .boldBody2,
        toduckColor: TDColor.Semantic.error
    )

    // 문장 기록
    let recordTextView = TDFormTextView(
        image: TDImage.Pen.penNeutralColor,
        title: "문장 기록",
        titleFont: .boldBody2,
        titleColor: TDColor.Neutral.neutral600,
        isRequired: false,
        maxCharacter: 2000,
        placeholder: "자유롭게 내용을 작성해 주세요.",
        maxHeight: 196
    )
    
    // 사진 기록
    let formPhotoView = TDFormPhotoView(
        image: TDImage.photo,
        titleText: "사진 기록",
        titleFont: .boldBody2,
        titleColor: TDColor.Neutral.neutral600,
        isRequired: false,
        maxCount: 2
    )
    
    // 설명
    private let descriptionStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
    }
    private let descriptionLabel1 = TDLabel(
        labelText: "· 나의 하루를 되돌아보며 오늘의 실수와 감정을 정리해봐요",
        toduckFont: .mediumBody2,
        toduckColor: TDColor.Neutral.neutral500
    )
    private let descriptionLabel2 = TDLabel(
        labelText: "· 더 나은 내일을 위한 기록 습관들이기",
        toduckFont: .mediumBody2,
        toduckColor: TDColor.Neutral.neutral500
    )
    
    // 사용자 피드백 스낵바
    let noticeSnackBarView = UIView().then {
        $0.backgroundColor = TDColor.Neutral.neutral700
        $0.layer.cornerRadius = 8
    }
    let noticeSnackBarLabel = TDLabel(
        labelText: "감정선택은 필수 입력이에요!",
        toduckFont: .mediumBody3,
        toduckColor: TDColor.baseWhite
    )
    
    // 저장
    let buttonContainerView = UIView().then {
        $0.backgroundColor = TDColor.baseWhite
    }
    let buttonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.backgroundColor = TDColor.baseWhite
        $0.spacing = 10
    }
    let deleteButton = TDBaseButton(
        title: "삭제",
        backgroundColor: TDColor.baseWhite,
        foregroundColor: TDColor.Semantic.error,
        radius: 12,
        font: TDFont.boldHeader3.font,
        inset: .init(top: 1, leading: 1, bottom: 1, trailing: 1)
    )
    let saveButton = TDBaseButton(
        title: "저장",
        backgroundColor: TDColor.Primary.primary500,
        foregroundColor: TDColor.baseWhite,
        radius: 12,
        font: TDFont.boldHeader3.font,
        inset: .init(top: 1, leading: 1, bottom: 1, trailing: 1)
    )
    let dummyView = UIView()
    
    // MARK: - Property
    var noticeSnackBarBottomConstraint: Constraint?
    var isEdit: Bool = false {
        didSet {
            updateDeleteButtonVisibility()
        }
    }
    var isDeleteMode: Bool = false {
        didSet {
            updateDeleteModeUI()
        }
    }
    var selectedKeywordsForDeletion: Set<Int> = []
    
    // MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Base Method
    override func addview() {
        addSubview(scrollView)
        addSubview(noticeSnackBarView)
        addSubview(buttonContainerView)
        scrollView.addSubview(stackView)
        buttonContainerView.addSubview(buttonStackView)
        
        // 카테고리
        stackView.addArrangedSubview(diaryMoodVerticalStackView)
        diaryMoodVerticalStackView.addArrangedSubview(diaryMoodLabelContainerView)
        diaryMoodVerticalStackView.addArrangedSubview(diaryMoodCollectionView)
        diaryMoodVerticalStackView.addArrangedSubview(divideLineView)
        diaryMoodLabelContainerView.addSubview(diaryMoodLabel)
        diaryMoodLabelContainerView.addSubview(infoLabel)
        
        // 키워드
        keywordHeaderContainerView.addSubview(keywordHeaderTitleView)
        keywordHeaderContainerView.addSubview(keywordHeaderDeleteButton)
        keywordHeaderContainerView.addSubview(keywordHeaderDeleteView)

        keywordHeaderTitleView.addArrangedSubview(keywordIcon)
        keywordHeaderTitleView.addArrangedSubview(keywordTitleLabel)

        // 키워드 취소 / 삭제 뷰
        keywordHeaderDeleteView.addArrangedSubview(diaryKeywordCancelButton)
        keywordHeaderDeleteView.addArrangedSubview(diaryKeywordDividerView)
        keywordHeaderDeleteView.addArrangedSubview(diaryKeywordDeleteButton)

        // 초기에는 삭제 뷰 숨김
        keywordHeaderDeleteView.isHidden = true
        
        keywordVerticalStackView.addArrangedSubview(keywordHeaderContainerView)
        keywordVerticalStackView.addArrangedSubview(keywordAddButton)
        keywordVerticalStackView.addArrangedSubview(keywordTagListView)
        keywordVerticalStackView.addArrangedSubview(deleteModeLabel)

        // 초기에는 삭제 모드 레이블 숨김
        deleteModeLabel.isHidden = true

        // 폼 정보
        stackView.addArrangedSubview(titleForm)
        stackView.addArrangedSubview(keywordVerticalStackView)
        stackView.addArrangedSubview(recordTextView)
        stackView.addArrangedSubview(formPhotoView)
        stackView.addArrangedSubview(descriptionStackView)
        stackView.addArrangedSubview(dummyView)

        // titleForm과 keywordVerticalStackView 사이의 spacing을 32로 설정
        stackView.setCustomSpacing(32, after: titleForm)
        descriptionStackView.addArrangedSubview(descriptionLabel1)
        descriptionStackView.addArrangedSubview(descriptionLabel2)
        
        // 버튼
        noticeSnackBarView.addSubview(noticeSnackBarLabel)
    }
    
    override func layout() {
        scrollView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(buttonContainerView.snp.top)
        }

        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(LayoutConstants.horizontalInset)
            make.width.equalTo(scrollView.snp.width).offset(LayoutConstants.stackViewWidthOffset)
        }

        // 감정 선택
        diaryMoodVerticalStackView.snp.makeConstraints { make in
            make.height.equalTo(LayoutConstants.diaryMoodStackHeight)
        }

        diaryMoodCollectionView.snp.makeConstraints { make in
            make.height.equalTo(LayoutConstants.diaryMoodCollectionHeight)
        }
        diaryMoodLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
        }
        infoLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        divideLineView.snp.makeConstraints { make in
            make.height.equalTo(1)
        }

        // 제목
        titleForm.snp.makeConstraints { make in
            make.height.equalTo(LayoutConstants.titleFormHeight)
        }
        
        // 키워드
        keywordHeaderContainerView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(20)
        }
        
        keywordHeaderTitleView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }

        keywordHeaderDeleteButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(20)
        }

        keywordHeaderDeleteView.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(20)
        }

        diaryKeywordCancelButton.snp.makeConstraints { make in
            make.height.equalTo(20)
        }

        diaryKeywordDeleteButton.snp.makeConstraints { make in
            make.height.equalTo(20)
        }

        diaryKeywordDividerView.snp.makeConstraints { make in
            make.width.equalTo(1)
            make.height.equalTo(16)
        }

        keywordIcon.snp.makeConstraints { make in
            make.size.equalTo(16)
        }
        keywordAddButton.snp.makeConstraints { make in
            make.height.equalTo(32)
        }

        keywordTagListView.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }

        // 문장 기록
        recordTextView.snp.makeConstraints { make in
            make.height.equalTo(LayoutConstants.recordTextViewHeight)
        }

        // 사진 기록
        formPhotoView.snp.makeConstraints { make in
            make.height.equalTo(LayoutConstants.formPhotoViewHeight)
        }

        // 설명
        descriptionStackView.snp.makeConstraints { make in
            make.height.equalTo(LayoutConstants.descriptionStackViewHeight)
        }

        dummyView.snp.makeConstraints { make in
            make.height.equalTo(LayoutConstants.dummyViewHeight)
        }

        // 사용자 피드백 스낵바
        noticeSnackBarView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(LayoutConstants.horizontalInset)
            make.height.equalTo(LayoutConstants.snackBarHeight)
            noticeSnackBarBottomConstraint = make.bottom.equalTo(buttonContainerView.snp.top).constraint
        }
        noticeSnackBarLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(LayoutConstants.horizontalInset)
        }

        // 저장
        buttonContainerView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(LayoutConstants.buttonContainerHeight)
        }

        buttonStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(LayoutConstants.horizontalInset)
            make.height.equalTo(LayoutConstants.buttonHeight)
        }
    }
    
    override func configure() {
        backgroundColor = TDColor.baseWhite
        scrollView.showsVerticalScrollIndicator = false
        titleForm.setupFont(.regularBody4)
        diaryMoodLabel.setTitleFont(.boldHeader5)
        diaryMoodLabel.setTitleLabel("감정 선택")
        diaryMoodLabel.setRequiredLabel()
        saveButton.isEnabled = false
        keywordAddButton.setContentHuggingPriority(.required, for: .horizontal)
        keywordAddButton.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    // MARK: - Helper Method
    private func updateDeleteButtonVisibility() {
        if isEdit {
            deleteButton.layer.borderWidth = 1
            deleteButton.layer.borderColor = TDColor.Semantic.error.cgColor
            buttonStackView.addArrangedSubview(deleteButton)
            buttonStackView.addArrangedSubview(saveButton)
        } else {
            deleteButton.removeFromSuperview()
            buttonStackView.addArrangedSubview(saveButton)
        }
    }
    
    func updateDeleteModeUI() {
        if isDeleteMode {
            // 삭제 모드 진입
            keywordHeaderDeleteButton.isHidden = true
            keywordHeaderDeleteView.isHidden = false
            deleteModeLabel.isHidden = false
            diaryKeywordDeleteButton.updateBackgroundColor(backgroundColor: TDColor.baseWhite, foregroundColor: TDColor.Semantic.error)
        } else {
            // 일반 모드
            keywordHeaderDeleteButton.isHidden = false
            keywordHeaderDeleteView.isHidden = true
            deleteModeLabel.isHidden = true
            diaryKeywordDeleteButton.updateBackgroundColor(backgroundColor: TDColor.baseWhite, foregroundColor: TDColor.Neutral.neutral600)
            selectedKeywordsForDeletion.removeAll()
            keywordTagListView.updateSelectedKeywords([])
        }
    }
    
    func updateKeywordTags(keywords: [String], keywordIds: [Int] = []) {
        keywordTagListView.configure(keywords: keywords, keywordIds: keywordIds)
        if isDeleteMode {
            keywordTagListView.updateSelectedKeywords(selectedKeywordsForDeletion)
        }
    }
}

private extension SimpleDiaryView {
    // MARK: - Constants
    enum LayoutConstants {
        static let dummyViewHeight: CGFloat = 40
        static let horizontalInset: CGFloat = 16
        static let stackViewWidthOffset: CGFloat = -32
        static let diaryMoodStackHeight: CGFloat = 120
        static let diaryMoodCollectionHeight: CGFloat = 80
        static let titleFormHeight: CGFloat = 110
        static let recordTextViewHeight: CGFloat = 230
        static let formPhotoViewHeight: CGFloat = 160
        static let descriptionStackViewHeight: CGFloat = 40
        static let snackBarHeight: CGFloat = 42
        static let buttonContainerHeight: CGFloat = 112
        static let buttonHeight: CGFloat = 56
    }
}
