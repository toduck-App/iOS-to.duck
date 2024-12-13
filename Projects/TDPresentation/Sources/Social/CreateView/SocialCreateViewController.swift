import Combine
import TDDesign
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func configure() {
        layoutView.socialSelectCategoryView.categorySelectView.chipDelegate = self
        layoutView.socialSelectCategoryView.categorySelectView.setChips(viewModel.chips)
    }

    override func binding() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
    }
}

extension SocialCreateViewController: TDChipCollectionViewDelegate {
    func chipCollectionView(_ collectionView: TDDesign.TDChipCollectionView, didSelectChipAt index: Int, chipText: String) {
        input.send(.chipSelect(at: index))
    }
}
