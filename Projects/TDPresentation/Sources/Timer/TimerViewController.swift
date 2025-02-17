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
    private var theme: TDTimerTheme = .Bboduck

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

        input.send(.fetchTimerTheme)
        input.send(.fetchFocusCount)
        input.send(.fetchTimerSetting)
        input.send(.fetchTimerInitialStatus)
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
        let output: AnyPublisher<TimerViewModel.Output, Never> = viewModel.transform(input: input.eraseToAnyPublisher())

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
                case let .updatedFocusCount(count), let .fetchedFocusCount(count):
                    self?.updateFocusCount(with: count)
                case let .updatedMaxFocusCount(maxCount):
                    self?.updateMaxFocusCount(with: maxCount)
                case let .updatedTimerTheme(theme):
                    self?.updateTheme(theme: theme)
                case let .failure(code):
                    self?.handleFailure(code)
                case .updatedTimerSetting:
                    self?.updatedTimerSetting()
                default:
                    break
                }
            }
        }.store(in: &cancellables)
    }

    func setupNavigation() {
        // TODO: 캘린더 이미지 tint 사용 금지
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: layoutView.leftNavigationItem)

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            customView: layoutView.rightNavigationMenuButton
        )

        layoutView.dropDownView.delegate = self
        layoutView.dropDownView.dataSource = TimerDropDownMenuItem.allCases.map { $0.dropDownItem }

        layoutView.rightNavigationMenuButton.addAction(UIAction { _ in
            self.layoutView.dropDownView.showDropDown()
        }, for: .touchUpInside)

        navigationItem.rightBarButtonItem?.tintColor = TDColor.Primary.primary300
    }
}

extension TimerViewController {
    // TODO: 집중 타이머 횟수를 다채웠으면 어떻게 할지 물어보고 구현하기
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
        let elapsedTime: Int = setting.focusDuration - remainedTime
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
    private func updateTheme(theme _: TDTimerTheme) {}

    private func updateFocusCount(with count: Int) {
        guard let setting = viewModel.timerSetting else { return }

        layoutView.focusCountStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for i in 1 ... setting.maxFocusCount {
            if i <= count {
                layoutView.focusCountStackView.addArrangedSubview(
                    createFocusCountTomatoView())
            } else {
                layoutView.focusCountStackView.addArrangedSubview(
                    createFocusCountEmptyView())
            }
        }

        layoutView.focusCountStackView.layoutIfNeeded()
    }

    private func updateMaxFocusCount(with maxCount: Int) {
        guard let setting: TDTimerSetting = viewModel.timerSetting else { return }

        for view in layoutView.focusCountStackView.arrangedSubviews {
            layoutView.focusCountStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }

        for i in 1 ... setting.maxFocusCount {
            if i <= maxCount {
                layoutView.focusCountStackView.addArrangedSubview(
                    createFocusCountTomatoView())
            } else {
                layoutView.focusCountStackView.addArrangedSubview(
                    createFocusCountEmptyView())
            }
        }
        layoutView.focusCountStackView.layoutIfNeeded()
    }

    // TODO: 간단한 토스트 구현하면 Implement하기
    private func handleFailure(_ code: TimerViewModel.TimerViewModelError) {
        switch code {
        case .updateFailed:
            let message = "[\(code)]: 알 수 없는 오류가 발생했습니다."
            TDLogger.error("[TimerViewController]\(message)")
        case .outOfRange:
            TDLogger.error("[TimerViewController] outOfRange")
        }
    }

    private func updatedTimerSetting() {
        input.send(.fetchFocusCount)
        input.send(.fetchTimerSetting)
    }
}

// MARK: - TDDropDownDelegate

extension TimerViewController: TDDropDownDelegate {
    func dropDown(_: TDDesign.TDDropdownHoverView, didSelectRowAt indexPath: IndexPath) {
        let item = TimerDropDownMenuItem.allCases[indexPath.row]

        switch item {
        case .timerSetting:
            let timerSettingViewController = TimerSettingViewController(
                viewModel: viewModel)

            presentSheet(viewController: timerSettingViewController)
        case .themeSetting:
            let themeSettingViewController = ThemeSettingViewController(
                viewModel: viewModel)

            presentSheet(viewController: themeSettingViewController)
        case .whiteNoise:
            break
        #if DEBUG
            case .resetFocusCount:
                input.send(.resetFocusCount)
        #endif
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
        return UIImageView().then {
            $0.image = TDImage.Tomato.tomato

            $0.snp.makeConstraints {
                $0.size.equalTo(FocusCountViewLayoutConstant.size)
            }
        }
    }

    private func createFocusCountEmptyView() -> UIView {
        return UIView().then {
            $0.layer.borderColor = TDColor.Primary.primary200.cgColor
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = CGFloat(FocusCountViewLayoutConstant.size / 2)
            $0.backgroundColor = TDColor.Primary.primary25

            $0.snp.makeConstraints {
                $0.size.equalTo(FocusCountViewLayoutConstant.size)
            }
        }
    }

    private func presentSheet<view: BaseView, vc: BaseViewController<view>>(viewController: vc) {
        let sheetController = SheetViewController(
            controller: viewController,
            sizes: [.intrinsic],
            options: SheetOptions(shrinkPresentingViewController: false)
        )
        sheetController.cornerRadius = 28
        sheetController.cornerCurve = .circular
        sheetController.gripSize = .zero
        sheetController.allowPullingPastMaxHeight = false
        present(sheetController, animated: true, completion: nil)
    }
}

// MARK: - Enum

extension TimerViewController {
    enum TimerControlStackState {
        case initilize
        case playing
        case pause
    }

    enum FocusCountViewLayoutConstant {
        static let size: CGFloat = 16
    }

    enum TimerDropDownMenuItem: String, CaseIterable {
        case timerSetting = "타이머 설정"
        case themeSetting = "테마 변경"
        case whiteNoise = "백색 소음"

        #if DEBUG
            case resetFocusCount = "집중 횟수 초기화"
        #endif
        var dropDownItem: TDDropdownItem {
            return TDDropdownItem(title: rawValue, rightImage: image)
        }

        //TODO: 이미지 추가 예정
        var image: TDDropdownItem.SelectableImage {
            switch self {
            case .timerSetting:
                return (TDImage.Sort.recentEmpty, TDImage.Sort.recentFill)
            case .themeSetting:
                return (TDImage.Sort.recentEmpty, TDImage.Sort.recentFill)
            case .whiteNoise:
                return (TDImage.Sort.recentEmpty, TDImage.Sort.recentFill)
            default:
                return (TDImage.Sort.recentEmpty, TDImage.Sort.recentFill)
            }
        }
    }
}
