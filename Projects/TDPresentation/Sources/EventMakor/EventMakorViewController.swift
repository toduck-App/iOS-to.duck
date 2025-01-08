import UIKit
import TDDesign
import TDCore

final class EventMakorViewController: BaseViewController<BaseView> {
    // MARK: - Properties
    private let mode: ScheduleAndRoutineViewController.Mode
    private let viewModel: EventMakorViewModel
    private let eventMakorView: EventMakorView
    weak var coordinator: EventMakorCoordinator?
    
    // MARK: - UI Components
    private lazy var registerButton = UIBarButtonItem(
        title: "저장",
        primaryAction: UIAction {
            [weak self] _ in
            self?.didTapRegisterButton()
        }).then {
            $0.tintColor = TDColor.Neutral.neutral700
    }
    
    // MARK: - Initializer
    init(
        mode: ScheduleAndRoutineViewController.Mode,
        viewModel: EventMakorViewModel
    ) {
        self.mode = mode
        self.viewModel = viewModel
        self.eventMakorView = EventMakorView(mode: mode)
        super.init()
    }
    
    required init?(coder: NSCoder) {
        self.mode = .schedule
        self.viewModel = EventMakorViewModel()
        self.eventMakorView = EventMakorView(mode: mode)
        super.init(coder: coder)
    }
    
    // MARK: - Life Cycle
    override func loadView() {
        super.loadView()
        view = eventMakorView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func configure() {
        navigationItem.rightBarButtonItem = registerButton
        eventMakorView.categoryTitleForm.delegate = self
        eventMakorView.dateForm.delegate = self
        eventMakorView.timeForm.delegate = self
    }
    
    private func didTapRegisterButton() {
        // TODO: - 저장 버튼 클릭
    }
}

extension EventMakorViewController: TDFormMoveViewDelegate {
    func didTapMoveView(_ view: TDFormMoveView, type: TDFormMoveViewType) {
        switch type {
        case .category:
            TDLogger.debug("카테고리 색상수정 클릭")
        case .date:
            coordinator?.didTapMoveView(view, type: type)
        case .time:
            TDLogger.debug("시간 클릭")
        }
    }
}
