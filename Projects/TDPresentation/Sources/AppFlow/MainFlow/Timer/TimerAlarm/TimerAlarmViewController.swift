import UIKit
import TDCore
import Combine

final class TimerAlarmViewController: BaseViewController<TimerAlarmView> {
    private let viewModel: TimerViewModel!
    private let input = PassthroughSubject<TimerViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()

    init(viewModel: TimerViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    required init?(coder: NSCoder) {
        viewModel = nil
        super.init(coder: coder)
    }

    override func configure() {
        let buttons = [
            layoutView.muteAlarmButton,
            layoutView.soundAlarmButton,
            layoutView.vibrationAlarmButton,
            layoutView.systemAlarmButton
        ]

        buttons.forEach { button in
            button.addAction(UIAction { _ in
                button.isSelected = true
                buttons.filter({ $0 != button}).forEach { otherButton in
                    otherButton.isSelected = false
                }
            }, for: .touchUpInside)
        }

        layoutView.exitButton.addAction(UIAction { [self] _ in
            dismiss(animated: true)
        }, for: .touchUpInside)

        layoutView.saveButton.addAction(UIAction { [self] _ in 
            //input.send(.decreaseMaxFocusCount)
        }, for: .touchUpInside)
    }
}
