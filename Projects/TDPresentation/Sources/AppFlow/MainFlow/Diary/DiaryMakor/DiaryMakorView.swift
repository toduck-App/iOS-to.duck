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
    
    // 문장 기록
    let recordTextView = TDFormTextView(
        image: TDImage.Pen.penNeutralColor,
        title: "문장 기록",
        titleFont: .boldBody2,
        titleColor: TDColor.Neutral.neutral600,
        isRequired: false,
        maxCharacter: 200,
        placeholder: "자유롭게 내용을 작성해 주세요.",
        maxHeight: 196
    )
    
    // 사진 기록
    let formPhotoView = TDFormPhotoView(
        titleText: "사진 기록",
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
        
        // 카테고리
        stackView.addArrangedSubview(diaryMoodVerticalStackView)
        diaryMoodVerticalStackView.addArrangedSubview(diaryMoodLabelContainerView)
        diaryMoodVerticalStackView.addArrangedSubview(diaryMoodCollectionView)
        diaryMoodVerticalStackView.addArrangedSubview(divideLineView)
        diaryMoodLabelContainerView.addSubview(diaryMoodLabel)
        diaryMoodLabelContainerView.addSubview(infoLabel)
        
        // 제목
        stackView.addArrangedSubview(titleForm)
        stackView.addArrangedSubview(recordTextView)
        stackView.addArrangedSubview(formPhotoView)
        stackView.addArrangedSubview(descriptionStackView)
        descriptionStackView.addArrangedSubview(descriptionLabel1)
        descriptionStackView.addArrangedSubview(descriptionLabel2)
    }
    
    override func configure() {
        backgroundColor = TDColor.baseWhite
        scrollView.showsVerticalScrollIndicator = false
        diaryMoodLabel.setTitleFont(.boldHeader5)
        diaryMoodLabel.setTitleLabel("감정 선택")
        diaryMoodLabel.setRequiredLabel()
    }
    
    override func layout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
            make.width.equalTo(scrollView.snp.width).offset(-32)
        }
        
        // 감정 선택
        diaryMoodVerticalStackView.snp.makeConstraints { make in
            make.height.equalTo(120)
        }

        diaryMoodCollectionView.snp.makeConstraints { make in
            make.height.equalTo(80)
        }
        diaryMoodLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
        }
        infoLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        divideLineView.snp.makeConstraints { make in
            make.height.equalTo(1)
        }

        // 제목
        titleForm.snp.makeConstraints { make in
            make.height.equalTo(110)
        }

        // 문장 기록
        recordTextView.snp.makeConstraints { make in
            make.height.equalTo(230)
        }

        // 사진 기록
        formPhotoView.snp.makeConstraints { make in
            make.height.equalTo(160)
        }

        // 설명
        descriptionStackView.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
    }
}
