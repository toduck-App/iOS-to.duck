import TDDesign
import UIKit

final class TimerSettingView: BaseView {
    let recommandView = TimerRecommendView()
    let exitButton: TDBaseButton = TDBaseButton(image: TDImage.X.x1Medium, backgroundColor: .clear,foregroundColor: TDColor.Neutral.neutral700)
    let timerSettingTitleLabel = TDLabel(
        labelText: "타이머 설정", toduckFont: .boldHeader4, alignment: .center,
        toduckColor: TDColor.Neutral.neutral800
    )
    
    let focusCountField = TimerSettingFieldControl(state: .focusCount)
    let focusTimeField = TimerSettingFieldControl(state: .focusTime)
    let restTimeField = TimerSettingFieldControl(state: .restTime)
    
    let fieldStack = UIStackView().then {
        $0.spacing = 28
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.alignment = .fill
    }
    
    let saveButton: TDButton = .init(title: "저장", size: .large)
    
    // MARK: - Common Methods
    
    override func configure() {
        backgroundColor = .white
    }
    
    override func addview() {
        addSubview(exitButton)
        addSubview(timerSettingTitleLabel)
        addSubview(recommandView)
        
        for item in [focusCountField, focusTimeField, restTimeField] {
            fieldStack.addArrangedSubview(item)
        }
        
        addSubview(fieldStack)
        addSubview(saveButton)
    }
    
    override func layout() {
        exitButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(24)
            make.size.equalTo(24)
        }
        
        timerSettingTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(exitButton.snp.centerY)
        }
        
        recommandView.snp.makeConstraints { make in
            make.height.equalTo(53)
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(exitButton.snp.bottom).offset(44)
        }
        
        fieldStack.snp.makeConstraints { make in
            make.leading.equalTo(recommandView.snp.leading)
            make.trailing.equalTo(recommandView.snp.trailing)
            make.top.equalTo(recommandView.snp.bottom).offset(24)
        }
        
        saveButton.snp.makeConstraints { make in
            make.leading.equalTo(recommandView.snp.leading)
            make.trailing.equalTo(recommandView.snp.trailing)
            make.height.equalTo(56)
            make.top.equalTo(fieldStack.snp.bottom).offset(36)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(16).priority(750)
        }
        
        for field in [focusTimeField, focusCountField, restTimeField] {
            field.snp.makeConstraints { make in
                make.height.equalTo(24)
            }
        }
    }
}

extension TimerSettingView {
    // MARK: - TimerSettingFieldState
    
    public enum TimerSettingFieldState: String {
        case focusTime = "집중 시간"
        case restTime = "휴식 시간"
        case focusCount = "집중 횟수"
        
        var timeFormat: String {
            switch self {
            case .focusCount:
                return "회"
            case .focusTime, .restTime:
                return "분"
            }
        }
    }
}
