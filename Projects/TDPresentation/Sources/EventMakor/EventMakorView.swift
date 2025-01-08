import UIKit
import SnapKit
import Then
import TDDesign

final class EventMakorView: BaseView {
    // MARK: - UI Properties
    
    private let scrollView = UIScrollView()
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 24
    }
    
    // 제목
    private let titleForm = TDFormTextField(
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
    private let categoryTitleForm = TDFormMoveView(type: .category)
    private let categoryViewsForm = TDFormCategoryView()
    
    // 날짜 (일정에서만 사용됨)
    private let dataVerticalStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 16
    }
    private let dateForm = TDFormMoveView(type: .date)
    private let dividedLine1 = UIView.dividedLine()
    
    // 시간
    private let timeVerticalStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 16
    }
    private let timeForm = TDFormMoveView(type: .time)
    private let dividedLine2 = UIView.dividedLine()
    
    // 공개여부 (루틴에서만 사용됨)
    private let lockStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .center
    }
    private let lockImageView = UIImageView(image: TDImage.Lock.medium)
    private let lockLabel = TDLabel(labelText: "공개여부", toduckFont: TDFont.mediumHeader5)
    private let lockSegmentedControl = UISegmentedControl(items: ["공개", "비공개"]).then {
        $0.selectedSegmentIndex = 0
    }
    private let dividedLine3 = UIView.dividedLine()
    
    private let repeatDayForm = TDFormButtonsView(type: .repeatDay)
    private let dividedLine4 = UIView.dividedLine()
    private let alarmForm = TDFormButtonsView(type: .alarm)
    private let dividedLine5 = UIView.dividedLine()
    
    // 장소 (일정에서만 사용됨)
    private let locationForm = TDFormTextField(
        image: TDImage.locationMedium,
        title: "장소",
        isRequired: false,
        maxCharacter: 20,
        placeholder: "장소를 입력해주세요"
    )
    
    // 메모
    private let memoTextView = TDFormTextView(
        image: TDImage.Memo.lineMedium,
        title: "메모",
        isRequired: false,
        maxCharacter: 40,
        placeholder: "메모를 작성해 주세요."
    )
    
    // MARK: - Properties
    private let mode: ScheduleAndRoutineViewController.Mode
    
    // MARK: - Initialize
    init(mode: ScheduleAndRoutineViewController.Mode) {
        self.mode = mode
        super.init(frame: .zero)
        
        categoryViewsForm.setupCategoryView(
            categories: [
                (TDColor.Schedule.back2, TDImage.Category.food),
                (TDColor.Schedule.back3, TDImage.Category.heart),
                (TDColor.Schedule.back1, TDImage.Category.medicine),
                (TDColor.Schedule.back4, TDImage.Category.none),
                (TDColor.Schedule.back5, TDImage.Category.pencil),
                (TDColor.Schedule.back6, TDImage.Category.people),
                (TDColor.Schedule.back7, TDImage.Category.power),
                (TDColor.Schedule.back8, TDImage.Category.sleep),
                (TDColor.Schedule.back9, TDImage.Category.redBook),
                (TDColor.Schedule.back10, TDImage.Category.yellowBook)
            ]
        )
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
        stackView.addArrangedSubview(dataVerticalStackView)
        dataVerticalStackView.addArrangedSubview(dateForm)
        dataVerticalStackView.addArrangedSubview(dividedLine1)
        
        // 시간
        stackView.addArrangedSubview(timeVerticalStackView)
        timeVerticalStackView.addArrangedSubview(timeForm)
        timeVerticalStackView.addArrangedSubview(dividedLine2)
        
        // 공개 여부 (Routine 모드에서만 표시)
        if mode == .routine {
            stackView.addArrangedSubview(lockStackView)
            lockStackView.addArrangedSubview(lockImageView)
            lockStackView.addArrangedSubview(lockLabel)
            lockStackView.addArrangedSubview(lockSegmentedControl)
            stackView.addArrangedSubview(dividedLine3)
        }
        
        stackView.addArrangedSubview(repeatDayForm)
        stackView.addArrangedSubview(dividedLine4)
        stackView.addArrangedSubview(alarmForm)
        stackView.addArrangedSubview(dividedLine5)
        
        // 장소
        stackView.addArrangedSubview(locationForm)
        
        // 메모
        stackView.addArrangedSubview(memoTextView)
    }
    
    override func configure() {
        backgroundColor = TDColor.baseWhite
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
        
        // 날짜 & 시간
        dateForm.snp.makeConstraints { make in
            make.height.equalTo(24)
        }
        timeForm.snp.makeConstraints { make in
            make.height.equalTo(24)
        }
        
        // 공개여부
        if mode == .routine {
            lockStackView.snp.makeConstraints { make in
                make.height.equalTo(56)
            }
            lockSegmentedControl.snp.makeConstraints { make in
                make.width.equalTo(120)
            }
        }
        
        repeatDayForm.snp.makeConstraints { make in
            make.height.equalTo(80)
        }
        
        alarmForm.snp.makeConstraints { make in
            make.height.equalTo(80)
        }
        
        // 장소
        locationForm.snp.makeConstraints { make in
            make.height.equalTo(84)
        }
        
        // 메모
        memoTextView.snp.makeConstraints { make in
            make.height.equalTo(140)
        }
    }
}
