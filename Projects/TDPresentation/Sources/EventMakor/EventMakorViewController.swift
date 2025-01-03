import UIKit

final class EventMakorViewController: BaseViewController<BaseView> {
    // MARK: - Properties
    private let mode: ScheduleAndRoutineViewController.Mode
    private let viewModel: EventMakorViewModel
    private let eventMakorView: EventMakorView
    weak var coordinator: EventMakorCoordinator?
    
    // MARK: - Initializer
    init(
        mode: ScheduleAndRoutineViewController.Mode,
        viewModel: EventMakorViewModel
    ) {
        self.mode = mode
        self.viewModel = viewModel
        self.eventMakorView = EventMakorView()
        super.init()
    }
    
    required init?(coder: NSCoder) {
        self.mode = .schedule
        self.viewModel = EventMakorViewModel()
        self.eventMakorView = EventMakorView()
        super.init(coder: coder)
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
