import Combine
import FittedSheets
import TDCore
import TDDesign
import TDDomain
import UIKit

final class TimerViewController: BaseViewController<TimerView>, TDToastPresentable {
    weak var coordinator: TimerCoordinator?
    private let viewModel: TimerViewModel!
    private let input = PassthroughSubject<TimerViewModel.Input, Never>()

    private var cancellables = Set<AnyCancellable>()
    private var theme: TDTimerTheme?

    // MARK: - Initializer

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

        // 아래의 함수들 configure에 넣으면 작동이 안함

        input.send(.fetchFocusCount)
        input.send(.fetchTimerSetting)
        input.send(.fetchTimerInitialStatus)
        updateMaxFocusCount()
        updateFocusCount()
    }

    override func configure() {
        setupNavigation()

        // timer buttons
        layoutView.playButton.addAction(
            UIAction { _ in
                self.input.send(.startTimer)
            }, for: .touchUpInside
        )

        layoutView.pauseButton.addAction(
            UIAction { _ in
                self.input.send(.stopTimer)
            }, for: .touchUpInside
        )

        layoutView.resetButton.addAction(
            UIAction { _ in
                self.input.send(.resetTimer)
            }, for: .touchUpInside
        )

        layoutView.restartButton.addAction(
            UIAction { _ in
                self.input.send(.restartTimer)
            }, for: .touchUpInside
        )
    }

    override func binding() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())

        // TODO: 각 케이스 함수로 빼기
        output.sink { [weak self] event in
            TDLogger.debug("[TimerViewController] revice event: \(event)")
            DispatchQueue.main.async {
                switch event {
                case let .updatedTimer(remainedTime):
                    self?.updateTimer(remainedTime)
                case let .updatedTimerRunning(isRunning):
                    self?.updateTimerRunning(isRunning)
                case .finishedTimer:
                    self?.finishedTimer()
                case .increasedFocusCount, .resetedFocusCount, .fetchedFocusCount:
                    self?.updateFocusCount()
                    self?.updateMaxFocusCount()
                case .increasedMaxFocusCount, .decreasedMaxFocusCount:
                    self?.updateMaxFocusCount()
                }
            }
        }.store(in: &cancellables)
    }

    func setupNavigation() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: TDImage.Calendar.top2Medium)

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: TDImage.Dot.verticalMedium,
            primaryAction: UIAction { _ in
                let timerSettingViewController = TimerSettingViewController(
                    viewModel: self.viewModel)

                let sheetController = SheetViewController(
                    controller: timerSettingViewController, sizes: [.intrinsic],
                    options: SheetOptions(
                        shrinkPresentingViewController: false
                    )
                )
                sheetController.cornerCurve = .circular
                sheetController.gripSize = .zero
                sheetController.allowPullingPastMaxHeight = false
                self.present(sheetController, animated: true, completion: nil)
            }
        )

        navigationItem.leftBarButtonItem?.tintColor = TDColor.Primary.primary300
        navigationItem.rightBarButtonItem?.tintColor = TDColor.Primary.primary300
    }
}

extension TimerViewController {
    private func finishedTimer() {
        handleControlStack(.pause)
        showToast(type: .orange, title: "휴식 시간 끝 💡️", message: "집중할 시간이에요 ! 자리에 앉아볼까요?")

        input.send(.increaseFocusCount)
    }

    private func updateTimer(_ remainedTime: Int) {
        guard let setting = viewModel.timerSetting else { return }
        let imageStep = 5

        // 이미지 업데이트
        let timePerImage = setting.focusDuration / imageStep
        let elapsedTime = setting.focusDuration - remainedTime
        let imageIndex = min(elapsedTime / timePerImage, imageStep - 1)

        _ = "focus_0\(imageIndex + 1)" // 임시 코드

        // Label 업데이트
        let second = remainedTime % 60
        let minute = (remainedTime / 60) % 60
        let hour = minute / 60

        layoutView.remainedFocusTimeLabel.text =
            hour >= 1
                ? String(format: "%d:%02d:%02d", hour, minute, second)
                : String(format: "%02d:%02d", minute, second)
    }

    private func updateTimerRunning(_ isRunning: Bool?) {
        guard let isRunning = isRunning else {
            handleControlStack(.initilize)
            return
        }
        if isRunning {
            handleControlStack(.playing)
        } else {
            handleControlStack(.pause)
        }
    }

    // TODO: Theme 설정
    private func updateTheme(_: TDTimerTheme) {}

    private func updateFocusCount() {
        guard let setting = viewModel.timerSetting else { return }
        TDLogger.debug(
            "[TimerViewController] \(viewModel.focusCount)/\(setting.focusCount)")

        layoutView.focusCountStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for i in 1 ... setting.focusCount {
            if i <= viewModel.focusCount {
                layoutView.focusCountStackView.addArrangedSubview(
                    createFocusCountTomatoView())
            } else {
                layoutView.focusCountStackView.addArrangedSubview(
                    createFocusCountEmptyView())
            }
        }
    }

    private func updateMaxFocusCount() {
        guard let setting = viewModel.timerSetting else { return }

        for view in layoutView.focusCountStackView.arrangedSubviews {
            layoutView.focusCountStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }

        // 1부터 setting.focusCount까지 반복하면서,
        // 현재 포커스 카운트(viewModel.focusCount) 이하이면 토마토뷰, 아니면 empty 뷰 추가
        for i in 1 ... setting.focusCount {
            if i <= viewModel.focusCount {
                layoutView.focusCountStackView.addArrangedSubview(
                    createFocusCountTomatoView())
            } else {
                layoutView.focusCountStackView.addArrangedSubview(
                    createFocusCountEmptyView())
            }
        }
    }
}

extension TimerViewController {
    // MARK: - private methods

    private func handleControlStack(_ state: TimerControlStackState) {
        let initStack = [layoutView.playButton]
        let playingStack = [
            layoutView.restartButton, layoutView.pauseButton, layoutView.resetButton,
        ]
        let pauseStack = [
            layoutView.restartButton, layoutView.playButton, layoutView.resetButton,
        ]

        layoutView.controlStack.arrangedSubviews.forEach { $0.removeFromSuperview() }

        switch state {
        case .initilize:
            initStack.forEach { layoutView.controlStack.addArrangedSubview($0) }
        case .playing:
            playingStack.forEach { layoutView.controlStack.addArrangedSubview($0) }
        case .pause:
            pauseStack.forEach { layoutView.controlStack.addArrangedSubview($0) }
        }
        layoutView.layoutIfNeeded()
    }

    // MARK: - create views

    private func createFocusCountTomatoView() -> UIImageView {
        let size = 16
        return UIImageView().then {
            $0.image = TDImage.Tomato.tomato

            $0.snp.makeConstraints {
                $0.size.equalTo(size)
            }
        }
    }

    private func createFocusCountEmptyView() -> UIView {
        let size = 16
        return UIView().then {
            $0.layer.borderColor = TDColor.Primary.primary200.cgColor
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = CGFloat(size / 2)
            $0.backgroundColor = TDColor.Primary.primary25

            $0.snp.makeConstraints {
                $0.size.equalTo(size)
            }
        }
    }
}

extension TimerViewController {
    enum TimerControlStackState {
        case initilize
        case playing
        case pause
    }
}
