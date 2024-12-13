import Combine
import UIKit

final class SocialCreateViewController: BaseViewController<SocialCreateView> {
    weak var coordinator: SocialCreateCoordinator?
    private let input = PassthroughSubject<SocialCreateViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    let viewModel: SocialCreateViewModel!

    init(viewModel: SocialCreateViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    required init?(coder: NSCoder) {
        self.viewModel = nil
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configure() {
        
    }
    
    override func binding() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
    }
}
