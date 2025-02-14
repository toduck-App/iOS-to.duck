import Combine
import TDCore
import TDDesign
import TDDomain
import UIKit

final class ThemeSettingViewController: BaseViewController<ThemeSettingView> {
    private let viewModel: TimerViewModel!
    private let input = PassthroughSubject<TimerViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    private var themeState: TDTimerTheme = .Bboduck

    init(viewModel: TimerViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    required init?(coder: NSCoder) {
        viewModel = nil
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        input.send(.fetchTimerTheme)
    }

    override func configure() {
        layoutView.exitButton.addAction(UIAction { _ in
            self.dismiss(animated: true)
        }, for: .touchUpInside)

        layoutView.themeBbouckButton.addAction(UIAction { [self] _ in
            TDLogger.debug("bboduck button clicked")
            themeState = .Bboduck
            updateSelectButtonState()
        }, for: .touchUpInside)

        layoutView.themeSimpleButton.addAction(UIAction { [self] _ in
            TDLogger.debug("simple button clicked")
            themeState = .Simple
            updateSelectButtonState()
        }, for: .touchUpInside)

        layoutView.saveButton.addAction(UIAction { [self] _ in
            input.send(.updateTimerTheme(theme: themeState))
        }, for: .touchUpInside)
    }

    override func binding() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())

        output.sink { [weak self] event in
            switch event {
            case let .fetchedTimerTheme(theme):
                self?.fetchedTimerTheme(theme: theme)
            case .updatedTimerTheme:
                self?.updatedTimerTheme()
            default:
                break
            }

        }.store(in: &cancellables)
    }
}

extension ThemeSettingViewController {
    private func fetchedTimerTheme(theme: TDTimerTheme) {
        self.themeState = theme
        updateSelectButtonState()
    }

    private func updatedTimerTheme() {
        dismiss(animated: true)
    }

    private func updateSelectButtonState() {
        layoutView.themeBbouckButton.isSelected = themeState == .Bboduck
        layoutView.themeSimpleButton.isSelected = themeState == .Simple
    }
}
