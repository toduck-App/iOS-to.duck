import Combine
import FittedSheets
import TDCore
import TDDesign
import TDDomain
import UIKit

final class TimerViewController: BaseViewController<TimerView>, TDToastPresentable {
    private let viewModel: TimerViewModel
    private let input = PassthroughSubject<TimerViewModel.Input, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    private var theme: TDTimerTheme = .toduck
    private var focusCount: Int = 0 // 테마 변경시 stack 토마토를 그릴 수 있게 하기 위한 임시 변수
    private var isTimerRunning: Bool = false
    weak var coordinator: TimerCoordinator?
    
    // MARK: - Initializer
    
    init(viewModel: TimerViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        input.send(.fetchFocusAllSetting)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        applyNavigationAppearance(for: theme)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        if isTimerRunning,
           let selectedVC = tabBarController?.selectedViewController,
           selectedVC != self.navigationController {
            input.send(.didTapPauseTimerButton)
            isTimerRunning = false
            updateTimerRunning(false)
            layoutView.leftNavigationItem.isUserInteractionEnabled = true
            showToast(
                type: .orange,
                title: "집중 타이머를 잠시 멈췄어요",
                message: "20초 안에 재시작하면 집중시간이 이어집니다",
                duration: 20
            )
        }
    }
    
    // MARK: - Common Methods
    
    override func configure() {
        setupNavigation()
        setupButtonActions()
        setupNotification()
    }
    
    override func binding() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case let .updateTime(remainedTime):
                    self?.updateTimer(remainedTime)
                case let .updatedTimerRunning(isRunning):
                    self?.updateTimerRunning(isRunning)
                case .finishedTimerOneCycle:
                    self?.finishedTimerOneCycle()
                case let .updatedFocusCount(count), let .fetchedFocusCount(count):
                    self?.updateFocusCount(with: count)
                case let .updatedMaxFocusCount(maxCount):
                    self?.updateMaxFocusCount(with: maxCount)
                case let .updatedTimerTheme(theme), let .fetchedTimerTheme(theme):
                    self?.updateTheme(theme: theme)
                case .fetchedTimerSetting:
                    self?.updateFocusCount(with: 0)
                case .stoppedTimer:
                    TDLogger.debug("Timer Stopped")
                case .startTimer:
                    TDLogger.debug("Timer Started")
                case .finishedFocusTimer:
                    HapticManager.impact(.soft)
                    self?.updateTimerRunning(false)
                    self?.showToast(
                        type: .orange,
                        title: "집중 성공 🧚‍♀️",
                        message: "잘했어요 ! 이대로 집중하는 습관을 천천히 길러봐요 !",
                        duration: nil
                    )
                    self?.layoutView.dropDownView.dataSource = TimerDropDownMenuItem.allCases.map { $0.dropDownItem }
                case .finishedRestTimer:
                    HapticManager.impact(.soft)
                    self?.isTimerRunning = true
                    self?.showToast(
                        type: .orange,
                        title: "휴식 시간 끝 💡️",
                        message: "집중할 시간이에요 ! 자리에 앉아볼까요?",
                        duration: nil
                    )
                case .successFinishedTimer:
                    self?.updateFocusCount(with: 0)
                    self?.handleControlStack(.initilize)
                case let .failure(message):
                    self?.showErrorAlert(errorMessage: message)
                }
            }.store(in: &cancellables)
    }
    
    private func setupNavigation() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: layoutView.leftNavigationItem)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: layoutView.rightNavigationMenuButton)
        
        layoutView.dropDownView.delegate = self
        layoutView.dropDownView.dataSource = TimerDropDownMenuItem.allCases.map { $0.dropDownItem }
        
        layoutView.leftNavigationItem.addAction(UIAction { [weak self] _ in
            self?.coordinator?.didTapCalendarButton()
        }, for: .touchUpInside)
        
        layoutView.rightNavigationMenuButton.addAction(UIAction { [weak self] _ in
            self?.layoutView.dropDownView.showDropDown()
        }, for: .touchUpInside)
        
        navigationItem.rightBarButtonItem?.tintColor = TDColor.Primary.primary300
    }
    
    private func applyNavigationAppearance(for theme: TDTimerTheme) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = theme.navigationBarBackgroundColor
        appearance.titleTextAttributes = [.foregroundColor: theme.navigationColor]
        appearance.shadowColor = .clear
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.tintColor = theme.navigationColor
    }
    
    private func setupButtonActions() {
        layoutView.playButton.addAction(UIAction { [weak self] _ in
            HapticManager.impact(.soft)
            self?.didTapStartTimerButton()
        }, for: .touchUpInside)
        
        layoutView.pauseButton.addAction(UIAction { [weak self] _ in
            HapticManager.impact(.soft)
            self?.didTapPauseTimerButton()
        }, for: .touchUpInside)
        
        layoutView.resetButton.addAction(UIAction { [weak self] _ in
            HapticManager.impact(.soft)
            self?.didTapResetTimerButton()
        }, for: .touchUpInside)
        
        layoutView.stopButton.addAction(UIAction { [weak self] _ in
            HapticManager.impact(.soft)
            self?.didTapStopTimerButton()
        }, for: .touchUpInside)
    }
    
    private func didTapStartTimerButton() {
        input.send(.didTapStartTimerButton)
        isTimerRunning = true
        dismissToast()
        updateTimerRunning(true)
        layoutView.dropDownView.dataSource = TimerDropDownMenuItem.allCases.filter { $0 != .timerSetting }.map { $0.dropDownItem }
        layoutView.leftNavigationItem.isUserInteractionEnabled = false
    }
    
    private func didTapPauseTimerButton() {
        input.send(.didTapPauseTimerButton)
        isTimerRunning = false
        updateTimerRunning(false)
        showToast(
            type: .orange,
            title: "집중 타이머를 잠시 멈췄어요",
            message: "20초 안에 재시작하면 집중시간이 이어집니다",
            duration: 20
        )
        layoutView.leftNavigationItem.isUserInteractionEnabled = true
    }
    
    private func didTapResetTimerButton() {
        let timerCautionPopupViewController = TimerCautionPopupViewController(popupMode: .reset)
        timerCautionPopupViewController.onAction = { [weak self] in
            self?.input.send(.didTapResetTimerButton)
            self?.updateTimerRunning(false)
            self?.updateTimer(self?.viewModel.timerSetting?.toFocusDurationMinutes() ?? 0)
        }
        presentPopup(with: timerCautionPopupViewController)
    }
    
    private func didTapStopTimerButton() {
        isTimerRunning = false
        let timerCautionPopupViewController = TimerCautionPopupViewController(popupMode: .stop)
        timerCautionPopupViewController.onAction = { [weak self] in
            self?.input.send(.didTapStopTimerButton)
            self?.dismissToast()
            self?.layoutView.dropDownView.dataSource = TimerDropDownMenuItem.allCases.map { $0.dropDownItem }
            self?.layoutView.leftNavigationItem.isUserInteractionEnabled = true
        }
        presentPopup(with: timerCautionPopupViewController)
    }
    
    private func setupNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleAppDidEnterBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
    }
    
    @objc
    private func handleAppDidEnterBackground() {
        if isTimerRunning {
            didTapPauseTimerButton()
        }
    }
    
    private func finishedTimerOneCycle() {
        handleControlStack(.pause)
    }
    
    private func updateTimer(_ remainedTime: Int) {
        guard let setting: TDTimerSetting = viewModel.timerSetting else { return }
        let elapsedTime = setting.toFocusDurationMinutes() - remainedTime
        
        // Label 업데이트
        let second = remainedTime % 60
        let minute = (remainedTime / 60) % 60
        let hour = minute / 60
        
        layoutView.remainedFocusTimeLabel.setText(
            hour >= 1
            ? String(format: "%d:%02d:%02d", hour, minute, second)
            : String(format: "%02d:%02d", minute, second)
        )
        
        // progress 업데이트
        layoutView.simpleTimerView.progress = CGFloat(elapsedTime) / CGFloat(setting.toFocusDurationMinutes())
        layoutView.bboduckTimerView.progress = CGFloat(elapsedTime) / CGFloat(setting.toFocusDurationMinutes())
    }
    
    private func updateTimerRunning(_ isRunning: Bool?) {
        guard let isRunning else {
            handleControlStack(.initilize)
            layoutView.bboduckTimerView.pause()
            layoutView.simpleTimerView.pause()
            return
        }
        
        layoutView.bboduckTimerView.isRunning = isRunning
        layoutView.simpleTimerView.isRunning = isRunning
        
        if isRunning {
            handleControlStack(.playing)
            isTimerRunning = true
        } else {
            handleControlStack(.pause)
            isTimerRunning = false
        }
    }
    
    private func updateTheme(theme: TDTimerTheme) {
        self.theme = theme
        
        layoutView.simpleTimerView.isHidden = theme == .toduck
        layoutView.bboduckTimerView.isHidden = theme == .simple
        
        // button theme
        layoutView.playButton.configuration?.baseBackgroundColor = theme.buttonCenterBackgroundColor
        layoutView.playButton.configuration?.baseForegroundColor = theme.buttonCenterForegroundColor
        
        layoutView.pauseButton.configuration?.baseBackgroundColor = theme.buttonCenterBackgroundColor
        layoutView.pauseButton.configuration?.baseForegroundColor = theme.buttonCenterForegroundColor
        
        layoutView.resetButton.configuration?.baseForegroundColor = theme.buttonForegroundColor
        layoutView.stopButton.configuration?.baseForegroundColor = theme.buttonForegroundColor
        
        // background theme
        layoutView.backgroundColor = theme.backgroundColor
        
        // navigation theme
        navigationItem.rightBarButtonItem?.customView?.subviews.forEach { view in
            view.tintColor = theme.navigationColor
        }
        
        var index = 0
        navigationItem.leftBarButtonItem?.customView?.subviews.forEach { view in
            if view is UIImageView {
                if index == 0 {
                    (view as! UIImageView).image = theme.navigationImage
                } else {
                    view.tintColor = theme.navigationColor
                }
            }
            index += 1
        }
        
        // stack theme
        updateFocusCount(with: focusCount)
        applyNavigationAppearance(for: theme)
        layoutView.layoutIfNeeded()
    }
    
    private func updateFocusCount(with count: Int) {
        guard let setting = viewModel.timerSetting else { return }
        focusCount = count
        var newCount = 0
        if count != 0 {
            newCount = count % setting.focusCountLimit == 0 ? setting.focusCountLimit : count % setting.focusCountLimit
        }
        
        layoutView.focusCountStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for i in 1...setting.focusCountLimit {
            if i <= newCount {
                layoutView.focusCountStackView.addArrangedSubview(createFocusCountTomatoView())
            } else {
                layoutView.focusCountStackView.addArrangedSubview(createFocusCountEmptyView())
            }
        }
        
        layoutView.focusCountStackView.layoutIfNeeded()
    }
    
    private func updateMaxFocusCount(with maxCount: Int) {
        guard let setting = viewModel.timerSetting else { return }
        
        for view in layoutView.focusCountStackView.arrangedSubviews {
            layoutView.focusCountStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        for i in 1...setting.focusCountLimit {
            if i <= maxCount {
                layoutView.focusCountStackView.addArrangedSubview(createFocusCountTomatoView())
            } else {
                layoutView.focusCountStackView.addArrangedSubview(createFocusCountEmptyView())
            }
        }
        layoutView.focusCountStackView.layoutIfNeeded()
    }
    
    // TODO: initStack -> anyStack으로 바뀌면 레이아웃이 뭉개짐
    private func handleControlStack(_ state: TimerControlStackState) {
        let initStack = [layoutView.playButton]
        let playingStack = [
            layoutView.resetButton, layoutView.pauseButton, layoutView.stopButton,
        ]
        let pauseStack = [
            layoutView.resetButton, layoutView.playButton, layoutView.stopButton,
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
            $0.layer.borderColor = theme.counterStackBorderColor.cgColor
            $0.layer.borderWidth = theme.counterStackBorderWidth
            $0.layer.cornerRadius = CGFloat(FocusCountViewLayoutConstant.size / 2)
            $0.backgroundColor = theme.counterStackBackgroundColor
            
            $0.snp.makeConstraints {
                $0.size.equalTo(FocusCountViewLayoutConstant.size)
            }
        }
    }
}

// MARK: - TDDropDownDelegate

extension TimerViewController: TDDropDownDelegate {
    func dropDown(_: TDDesign.TDDropdownHoverView, didSelectRowAt indexPath: IndexPath) {
        let currentItems = TimerDropDownMenuItem.allCases.filter { menuItem in
            layoutView.dropDownView.dataSource.contains(where: { $0.title == menuItem.dropDownItem.title })
        }
        let item = currentItems[indexPath.row]
        
        switch item {
        case .timerSetting:
            let timerSettingViewController = TimerSettingViewController(viewModel: viewModel)
            presentSheet(viewController: timerSettingViewController)
        case .themeSetting:
            let themeSettingViewController = ThemeSettingViewController(viewModel: viewModel)
            presentSheet(viewController: themeSettingViewController)
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
    private enum TimerControlStackState {
        case initilize
        case playing
        case pause
    }
    
    private enum FocusCountViewLayoutConstant {
        static let size: CGFloat = 16
    }
    
    enum TimerDropDownMenuItem: String, CaseIterable {
        case timerSetting = "타이머 설정"
        case themeSetting = "테마 변경"
        
        var dropDownItem: TDDropdownItem {
            return TDDropdownItem(title: rawValue, leftImage: image)
        }
        
        var image: TDDropdownItem.SelectableImage {
            switch self {
            case .timerSetting:
                return (TDImage.Sort.recentEmpty, TDImage.Sort.recentFill)
            case .themeSetting:
                return (TDImage.Tomato.tomatoSmallEmtpy, TDImage.Tomato.tomatoSmallFill)
            }
        }
    }
}

// MARK: - Theme Enum

private extension TDTimerTheme {
    var buttonForegroundColor: UIColor {
        switch self {
        case .simple:
            return TDColor.Neutral.neutral400
        case .toduck:
            return TDColor.Primary.primary100
        }
    }
    
    var buttonCenterBackgroundColor: UIColor {
        switch self {
        case .simple:
            return .clear
        case .toduck:
            return TDColor.Primary.primary200
        }
    }
    
    var buttonCenterForegroundColor: UIColor {
        switch self {
        case .simple:
            return TDColor.Neutral.neutral600
        case .toduck:
            return .white
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .simple:
            return UIColor(red: 1.00, green: 1.00, blue: 0.99, alpha: 1.00)
        case .toduck:
            return TDColor.Primary.primary100
        }
    }
    
    var navigationColor: UIColor {
        switch self {
        case .simple:
            return TDColor.Neutral.neutral500
        case .toduck:
            return TDColor.Primary.primary300
        }
    }

    var navigationBarBackgroundColor: UIColor {
        switch self {
        case .simple:
            return .white
        case .toduck:
            return TDColor.Primary.primary100
        }
    }
    
    var navigationImage: UIImage {
        switch self {
        case .simple:
            return TDImage.Calendar.top2Medium
        case .toduck:
            return TDImage.Calendar.top2MediumOrange
        }
    }
    
    var counterStackBorderWidth: CGFloat {
        switch self {
        case .simple:
            return 0
        case .toduck:
            return 1
        }
    }
    
    var counterStackBackgroundColor: UIColor {
        switch self {
        case .simple:
            return TDColor.Neutral.neutral200
        case .toduck:
            return TDColor.Primary.primary25
        }
    }
    
    var counterStackBorderColor: UIColor {
        switch self {
        case .simple:
            return .clear
        case .toduck:
            return TDColor.Primary.primary200
        }
    }
}
