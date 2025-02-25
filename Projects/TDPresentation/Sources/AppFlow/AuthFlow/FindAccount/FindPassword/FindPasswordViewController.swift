import Combine
import UIKit
import TDCore
import TDDesign

final class FindPasswordViewController: BaseViewController<FindPasswordView> {
    private let viewModel: FindPasswordViewModel
    private let input = PassthroughSubject<FindPasswordViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    init(
        viewModel: FindPasswordViewModel
    ) {
        self.viewModel = viewModel
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
    }
}
