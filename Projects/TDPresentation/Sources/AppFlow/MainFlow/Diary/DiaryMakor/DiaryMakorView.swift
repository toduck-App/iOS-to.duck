import UIKit
import SnapKit
import TDDesign
import Then

final class DiaryMakorView: BaseView {
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 32
    }
    
    // 감정 선택
    private let diaryMoodVerticalStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 24
    }
    private let diaryMoodLabel = TDRequiredTitle()
    private let infoLabel = TDLabel(
        labelText: "* 필수 항목",
        toduckFont: .mediumBody1,
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
    
    // 문장 기록
    let memoTextView = TDFormTextView(
        image: TDImage.photo,
        title: "문장 기록",
        isRequired: false,
        maxCharacter: 40,
        placeholder: "자유롭게 내용을 작성해 주세요."
    )
    
    // 사진 기록
    private(set) var formPhotoView = TDFormPhotoView(
        titleText: "사진 기록",
        isRequired: false,
        maxCount: 2
    )
    
    // 설명
    private let descriptionStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
    }
    private let descriptionLabel1 = TDLabel(
        labelText: "나의 하루를 되돌아보며 오늘의 실수와 감정을 정리해봐요",
        toduckFont: .mediumBody2,
        toduckColor: TDColor.Neutral.neutral500
    )
    private let descriptionLabel2 = TDLabel(
        labelText: "더 나은 내일을 위한 기록 습관들이기",
        toduckFont: .mediumBody2,
        toduckColor: TDColor.Neutral.neutral500
    )
    
    // 사용자 피드백 스낵바
    let noticeSnackBarView = UIView().then {
        $0.backgroundColor = TDColor.Neutral.neutral700
        $0.layer.cornerRadius = 8
    }
    
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
        scrollView.addSubview(stackView)
        
        // 제목
        stackView.addArrangedSubview(titleForm)
        
        // 카테고리
        stackView.addArrangedSubview(diaryMoodVerticalStackView)
        diaryMoodVerticalStackView.addArrangedSubview(diaryMoodLabel)
        diaryMoodVerticalStackView.addArrangedSubview(infoLabel)
        
        stackView.addArrangedSubview(memoTextView)
        stackView.addArrangedSubview(formPhotoView)
        stackView.addArrangedSubview(descriptionStackView)
    }
    
    override func configure() {
        backgroundColor = TDColor.baseWhite
        scrollView.showsVerticalScrollIndicator = false
        diaryMoodLabel.setTitleFont(.boldHeader5)
        diaryMoodLabel.setTitleLabel("감정 선택")
    }
    
    override func layout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
            make.width.equalTo(scrollView.snp.width).offset(-32)
        }

        // 제목
        titleForm.snp.makeConstraints { make in
            make.height.equalTo(110)
        }

        // 문장 기록
        memoTextView.snp.makeConstraints { make in
            make.height.equalTo(230)
        }

        // 사진 기록
        formPhotoView.snp.makeConstraints { make in
            make.height.equalTo(120)
        }

        // 설명
        descriptionStackView.snp.makeConstraints { make in
            make.height.equalTo(32)
        }
    }
}
