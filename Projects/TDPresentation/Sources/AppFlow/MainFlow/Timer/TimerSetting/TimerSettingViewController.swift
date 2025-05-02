import Combine
import TDCore
import TDDomain
import UIKit

final class TimerSettingViewController: BaseViewController<TimerSettingView> {
    // MARK: - Properties

    private let viewModel: TimerViewModel
    private let input = PassthroughSubject<TimerViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()

    private var focusTime: Int = 25 {
        didSet {
            layoutView.focusTimeField.leftButton.isEnabled = focusTime > TDTimerSetting.minFocusDuration
            layoutView.focusTimeField.rightButton.isEnabled = focusTime < TDTimerSetting.maxFocusDuration
            layoutView.focusTimeField.outputLabel.setText("\(focusTime)분")
        }
    }

    private var focusCountLimit: Int = 4 {
        didSet {
            layoutView.focusCountField.leftButton.isEnabled = focusCountLimit > TDTimerSetting.minFocusCountLimit
            layoutView.focusCountField.rightButton.isEnabled = focusCountLimit < TDTimerSetting.maxFocusCountLimit
            layoutView.focusCountField.outputLabel.setText("\(focusCountLimit)회")
        }
    }

    private var restTime: Int = 5 {
        didSet {
            layoutView.restTimeField.leftButton.isEnabled = restTime > TDTimerSetting.minRestDuration
            layoutView.restTimeField.rightButton.isEnabled = restTime < TDTimerSetting.maxRestDuration
            layoutView.restTimeField.outputLabel.setText(restTime == 0 ? "휴식 없음" : "\(restTime)분")
        }
    }

    // MARK: - initializers

    init(viewModel: TimerViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        input.send(.fetchTimerSetting)
    }

    // MARK: - Common Methods
    
    override func configure() {
        // 토덕의 추천 설정
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(recommendSettingTapped))
        layoutView.recommandView.addGestureRecognizer(tapGesture)
        
        // focus time field
        layoutView.focusTimeField.leftButton.addAction(UIAction { [weak self] _ in
            self?.layoutView.recommandView.updateForegroundColorForSelected(isSelected: false)
            self?.focusTime -= 5
        }, for: .touchUpInside)

        layoutView.focusTimeField.rightButton.addAction(UIAction { [weak self] _ in
            self?.layoutView.recommandView.updateForegroundColorForSelected(isSelected: false)
            self?.focusTime += 5
        }, for: .touchUpInside)

        // focus count field
        layoutView.focusCountField.leftButton.addAction(UIAction { [weak self] _ in
            self?.layoutView.recommandView.updateForegroundColorForSelected(isSelected: false)
            self?.focusCountLimit -= 1
        }, for: .touchUpInside)

        layoutView.focusCountField.rightButton.addAction(UIAction { [weak self] _ in
            self?.layoutView.recommandView.updateForegroundColorForSelected(isSelected: false)
            self?.focusCountLimit += 1
        }, for: .touchUpInside)

        // rest time field
        layoutView.restTimeField.leftButton.addAction(UIAction { [weak self] _ in
            self?.layoutView.recommandView.updateForegroundColorForSelected(isSelected: false)
            self?.restTime -= 5
        }, for: .touchUpInside)

        layoutView.restTimeField.rightButton.addAction(UIAction { [weak self] _ in
            self?.layoutView.recommandView.updateForegroundColorForSelected(isSelected: false)
            self?.restTime += 5
        }, for: .touchUpInside)

        // save button (unchanged)
        layoutView.saveButton.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            let setting = TDTimerSetting(
                focusDuration: focusTime,
                focusCountLimit: focusCountLimit,
                restDuration: restTime
            )
            input.send(.updateTimerSetting(setting: setting))
            dismiss(animated: true)
        }, for: .touchUpInside)

        // exit button
        layoutView.exitButton.addAction(UIAction { [weak self] _ in
            self?.layoutView.recommandView.updateForegroundColorForSelected(isSelected: false)
            self?.dismiss(animated: true)
        }, for: .touchUpInside)
    }

    override func binding() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())

        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case let .fetchedTimerSetting(setting):
                    self?.fetchedTimerSetting(setting: setting)
                default:
                    break
                }
            }.store(in: &cancellables)
    }
    
    @objc
    private func recommendSettingTapped() {
        recommendSetting()
        layoutView.recommandView.updateForegroundColorForSelected(isSelected: true)
    }
    
    private func recommendSetting() {
        focusCountLimit = 4
        focusTime = 25
        restTime = 5
    }

    private func fetchedTimerSetting(setting: TDTimerSetting) {
        focusTime = setting.focusDuration
        focusCountLimit = setting.focusCountLimit
        restTime = setting.restDuration
    }
}
