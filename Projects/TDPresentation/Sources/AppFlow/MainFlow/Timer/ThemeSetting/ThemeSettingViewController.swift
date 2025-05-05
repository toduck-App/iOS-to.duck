import Combine
import TDCore
import TDDesign
import TDDomain
import UIKit

final class ThemeSettingViewController: BaseViewController<ThemeSettingView> {
    private let viewModel: TimerViewModel!
    private let input = PassthroughSubject<TimerViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    private var themeState: TDTimerTheme = .toduck

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
        layoutView.exitButton.addAction(UIAction { [self] _ in
            dismiss(animated: true)
        }, for: .touchUpInside)

        layoutView.themeBbouckButton.addAction(UIAction { [self] _ in
            themeState = .toduck
            updateSelectButtonState()
        }, for: .touchUpInside)

        layoutView.themeSimpleButton.addAction(UIAction { [self] _ in
            themeState = .simple
            updateSelectButtonState()
        }, for: .touchUpInside)

        layoutView.saveButton.addAction(UIAction { [self] _ in
            input.send(.updateTimerTheme(theme: themeState))
        }, for: .touchUpInside)
    }

    override func binding() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())

        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
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
        layoutView.themeBbouckButton.isSelected = themeState == .toduck
        layoutView.themeSimpleButton.isSelected = themeState == .simple
    }
}
