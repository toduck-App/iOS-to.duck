import UIKit

final class EventMakorViewController: BaseViewController<EventMakorView> {
    // MARK: - Properties
    private let viewModel: EventMakorViewModel
    weak var coordinator: EventMakorCoordinator?
    
    // MARK: - Initializer
    init(viewModel: EventMakorViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = EventMakorViewModel()
        super.init(coder: coder)
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
