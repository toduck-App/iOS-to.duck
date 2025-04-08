import UIKit
import SnapKit
import Then
import TDDesign

final class EventMakorView: BaseView {
    // MARK: - UI Components
    let scrollView = UIScrollView()
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 24
    }
    
    // 제목
    let titleForm = TDFormTextField(
        title: "일정",
        isRequired: true,
        maxCharacter: 20,
        placeholder: "일정을 입력해주세요"
    )
    
    // 카테고리
    private let categoryVerticalStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 16
    }
    let categoryTitleForm = TDFormMoveView(type: .category, isRequired: false)
    let categoryViewsForm = TDCategoryCollectionView()
    
    // 날짜 (일정에서만 사용됨)
    private let dataVerticalStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 16
    }
    let dateForm = TDFormMoveView(type: .date, isRequired: false)
    private let dividedLine1 = UIView.dividedLine()
    
    // 시간
    private let timeVerticalStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 16
    }
    let timeForm = TDFormMoveView(type: .time, isRequired: false)
    private let dividedLine2 = UIView.dividedLine()
    
    // 공개여부 (루틴에서만 사용됨)
    private let lockVerticalStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 16
    }
    let lockForm = TDFormSegmentView()
    private let dividedLine3 = UIView.dividedLine()
    
    // 반복일, 알람
    let repeatDayForm = TDFormButtonsView(type: .repeatDay)
    private let dividedLine4 = UIView.dividedLine()
    let alarmForm = TDFormButtonsView(type: .alarm)
    private let dividedLine5 = UIView.dividedLine()
    
    // 장소 (일정에서만 사용됨)
    let locationForm = TDFormTextField(
        image: TDImage.locationMedium,
        title: "장소",
        isRequired: false,
        maxCharacter: 20,
        placeholder: "장소를 입력해주세요"
    )
    
    // 메모
    let memoTextView = TDFormTextView(
        image: TDImage.Memo.lineMedium,
        title: "메모",
        isRequired: false,
        maxCharacter: 40,
        placeholder: "메모를 작성해 주세요."
    )
    
    // 사용자 피드백 스낵바
    let noticeSnackBarView = UIView().then {
        $0.backgroundColor = TDColor.Neutral.neutral700
        $0.layer.cornerRadius = 8
    }
    let noticeSnackBarLabel = TDLabel(
        labelText: "제목은 필수 입력이에요!",
        toduckFont: .mediumBody3,
        toduckColor: TDColor.baseWhite
    )
    
    // 저장
    let buttonContainerView = UIView().then {
        $0.backgroundColor = TDColor.baseWhite
    }
    let saveButton = TDBaseButton(
        title: "저장",
        backgroundColor: TDColor.Primary.primary500,
        foregroundColor: TDColor.baseWhite,
        radius: 12,
        font: TDFont.boldHeader3.font
    )
    private let dummyView = UIView()
    
    // MARK: - Properties
    private let mode: TodoViewController.Mode
    var noticeSnackBarBottomConstraint: Constraint?
    var dummyViewHeightConstraint: Constraint?
    
    // MARK: - Initialize
    init(mode: TodoViewController.Mode) {
        self.mode = mode
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        self.mode = .schedule
        super.init(coder: coder)
    }
    
    // MARK: - Base Method
    override func addview() {
        addSubview(scrollView)
        addSubview(noticeSnackBarView)
        addSubview(buttonContainerView)
        scrollView.addSubview(stackView)
        noticeSnackBarView.addSubview(noticeSnackBarLabel)
        buttonContainerView.addSubview(saveButton)
        
        // 제목
        stackView.addArrangedSubview(titleForm)
        
        // 카테고리
        stackView.addArrangedSubview(categoryVerticalStackView)
        categoryVerticalStackView.addArrangedSubview(categoryTitleForm)
        categoryVerticalStackView.addArrangedSubview(categoryViewsForm)
        
        // 날짜
        if mode == .schedule {
            stackView.addArrangedSubview(dataVerticalStackView)
            dataVerticalStackView.addArrangedSubview(dateForm)
            dataVerticalStackView.addArrangedSubview(dividedLine1)
        }
        
        // 시간
        stackView.addArrangedSubview(timeVerticalStackView)
        timeVerticalStackView.addArrangedSubview(timeForm)
        timeVerticalStackView.addArrangedSubview(dividedLine2)
        
        // 공개 여부 (Routine 모드에서만 표시)
        if mode == .routine {
            stackView.addArrangedSubview(lockVerticalStackView)
            lockVerticalStackView.addArrangedSubview(lockForm)
            lockVerticalStackView.addArrangedSubview(dividedLine3)
        }
        
        stackView.addArrangedSubview(repeatDayForm)
        stackView.addArrangedSubview(dividedLine4)
        stackView.addArrangedSubview(alarmForm)
        stackView.addArrangedSubview(dividedLine5)
        
        // 장소
        if mode == .schedule {
            stackView.addArrangedSubview(locationForm)
        }
            
        // 메모
        stackView.addArrangedSubview(memoTextView)
        stackView.addArrangedSubview(dummyView)
    }
    
    override func configure() {
        backgroundColor = TDColor.baseWhite
        scrollView.showsVerticalScrollIndicator = false
        saveButton.isEnabled = false
    }
    
    override func layout() {
        scrollView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(buttonContainerView.snp.top)
        }
        noticeSnackBarView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(42)
            noticeSnackBarBottomConstraint = make.bottom.equalTo(buttonContainerView.snp.top).offset(-16).constraint
        }
        noticeSnackBarLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
        }
        buttonContainerView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(112)
        }
        saveButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(56)
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
            make.width.equalTo(scrollView.snp.width).offset(-32)
        }
        
        // 제목
        titleForm.snp.makeConstraints { make in
            make.height.equalTo(84)
        }
        
        // 카테고리
        categoryVerticalStackView.snp.makeConstraints { make in
            make.height.equalTo(100)
        }
        
        // 날짜
        if mode == .schedule {
            dateForm.snp.makeConstraints { make in
                make.height.equalTo(24)
            }
        }
        
        // 시간
        timeForm.snp.makeConstraints { make in
            make.height.equalTo(24)
        }
        
        // 공개여부
        if mode == .routine {
            lockForm.snp.makeConstraints { make in
                make.height.equalTo(24)
            }
        }
        
        repeatDayForm.snp.makeConstraints { make in
            make.height.equalTo(80)
        }
        
        alarmForm.snp.makeConstraints { make in
            make.height.equalTo(80)
        }
        
        // 장소
        if mode == .schedule {
            locationForm.snp.makeConstraints { make in
                make.height.equalTo(84)
            }
        }
        
        // 메모
        memoTextView.snp.makeConstraints { make in
            make.height.equalTo(140)
        }
        
        dummyView.snp.makeConstraints { make in
            dummyViewHeightConstraint = make.height.equalTo(40).constraint
        }
    }
}
