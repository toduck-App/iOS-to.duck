import UIKit
import SnapKit
import Then
import TDDesign

final class EventMakorView: BaseView {
    // MARK: - UI Components
    private let scrollView = UIScrollView()
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
    let categoryTitleForm = TDFormMoveView(type: .category, isRequired: true)
    let categoryViewsForm = TDCategoryCollectionView()
    
    // 날짜 (일정에서만 사용됨)
    private let dataVerticalStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 16
    }
    let dateForm = TDFormMoveView(type: .date, isRequired: true)
    private let dividedLine1 = UIView.dividedLine()
    
    // 시간
    private let timeVerticalStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 16
    }
    let timeForm = TDFormMoveView(type: .time, isRequired: true)
    private let dividedLine2 = UIView.dividedLine()
    
    // 공개여부 (루틴에서만 사용됨)
    private let lockVerticalStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 16
    }
    private let lockForm = TDFormSegmentView()
    private let dividedLine3 = UIView.dividedLine()
    
    private let repeatDayForm = TDFormButtonsView(type: .repeatDay)
    private let dividedLine4 = UIView.dividedLine()
    private let alarmForm = TDFormButtonsView(type: .alarm)
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
    
    // 추천 루틴 (루틴에서만 사용됨)
    private let recommendRoutineForm = TDFormRecommendRoutine()
    
    // MARK: - Properties
    private let mode: ScheduleAndRoutineViewController.Mode
    
    // MARK: - Initialize
    init(mode: ScheduleAndRoutineViewController.Mode) {
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
        scrollView.addSubview(stackView)
        
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
        
        // 추천루틴
        if mode == .routine {
            stackView.addArrangedSubview(recommendRoutineForm)
        }
    }
    
    override func configure() {
        backgroundColor = TDColor.baseWhite
        scrollView.showsVerticalScrollIndicator = false
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
        
        // 추천루틴
        if mode == .routine {
            recommendRoutineForm.snp.makeConstraints { make in
                make.height.equalTo(100)
            }
        }
    }
}
