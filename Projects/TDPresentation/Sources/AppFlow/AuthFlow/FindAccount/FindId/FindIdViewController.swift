import Combine
import UIKit
import TDCore
import TDDesign

final class FindIdViewController: BaseViewController<FindIdView> {
    private let viewModel: FindIdViewModel
    private let input = PassthroughSubject<FindIdViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    init(
        viewModel: FindIdViewModel
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
