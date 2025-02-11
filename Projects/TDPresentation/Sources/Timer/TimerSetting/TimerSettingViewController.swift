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
            layoutView.focusTimeField.leftButton.isEnabled = focusTime > 5
            layoutView.focusTimeField.rightButton.isEnabled = focusTime < 60
            layoutView.focusTimeField.outputLabel.text = "\(focusTime)분"
        }
    }

    private var maxFocusCount: Int = 4 {
        didSet {
            layoutView.focusCountField.leftButton.isEnabled = maxFocusCount > 1
            layoutView.focusCountField.rightButton.isEnabled = maxFocusCount < 5
            layoutView.focusCountField.outputLabel.text = "\(maxFocusCount)회"
        }
    }

    private var restTime: Int = 5 {
        didSet {
            layoutView.restTimeField.leftButton.isEnabled = restTime > 0
            layoutView.restTimeField.rightButton.isEnabled = restTime < 10
            layoutView.restTimeField.outputLabel.text = "\(restTime)분"
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

        guard let setting = viewModel.timerSetting else { return }

        focusTime = setting.focusDuration
        maxFocusCount = setting.maxFocusCount
        restTime = setting.restDuration
    }

    override func configure() {
        // focus time field
        layoutView.focusTimeField.leftButton.addAction(
            UIAction { _ in
                self.focusTime -= 5
            }, for: .touchUpInside
        )

        layoutView.focusTimeField.rightButton.addAction(
            UIAction { _ in
                self.focusTime += 5
            }, for: .touchUpInside
        )

        // focus count field
        layoutView.focusCountField.leftButton.addAction(
            UIAction { _ in
                self.maxFocusCount -= 1
            }, for: .touchUpInside
        )

        layoutView.focusCountField.rightButton.addAction(
            UIAction { _ in
                self.maxFocusCount += 1
            }, for: .touchUpInside
        )

        // rest time field
        layoutView.restTimeField.leftButton.addAction(
            UIAction { _ in
                self.restTime -= 1
            }, for: .touchUpInside
        )

        layoutView.restTimeField.rightButton.addAction(
            UIAction { _ in
                self.restTime += 1
            }, for: .touchUpInside
        )
        #if DEBUG
        // reset button
        layoutView.resetButton.addAction(UIAction { _ in
            self.input.send(.resetFocusCount)
        }, for: .touchUpInside)
        #endif
        // save button
        layoutView.saveButton.addAction(
            UIAction { _ in
                self.input.send(
                    .updateTimerSetting(
                        setting: TDTimerSetting(
                            focusDuration: self.focusTime,
                            maxFocusCount: self.maxFocusCount,
                            restDuration: self.restTime
                        )))

                self.dismiss(animated: true)
            }, for: .touchUpInside
        )

        layoutView.exitButton.addAction(
            UIAction { _ in
                self.dismiss(animated: true)
            }, for: .touchUpInside
        )
    }

    //TODO: 추후에도 필요 없다 판단되면 함수 삭제
    override func binding() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())

        output.sink { [weak self] event in
            switch event {
            default:
                break
            }
        }.store(in: &cancellables)
    }
}
