import UIKit
import Combine
import SnapKit
import TDDesign
import Then

final class SheetTimeViewController: BaseViewController<SheetTimeView> {
    // MARK: - Properties
    private let viewModel: SheetTimeViewModel
    private let input = PassthroughSubject<SheetTimeViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    weak var coordinator: SheetTimeCoordinator?
    
    private var selectedHour: Int?
    private var selectedMinute: Int?

    // MARK: - Initializers
    init(viewModel: SheetTimeViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }
    
    // MARK: - Setup Bindings
    private func setupBindings() {
        layoutView.hourCollectionView.delegate = self
        layoutView.minuteCollectionView.delegate = self
    }
    
    override func configure() {
        layoutView.cancelButton.addAction(UIAction { [weak self] _ in
            self?.coordinator?.finishDelegate?.didFinish(childCoordinator: (self?.coordinator)!)
            self?.dismiss(animated: true)
        }, for: .touchUpInside)
        
        layoutView.saveButton.addAction(UIAction { [weak self] _ in
            guard let hour = self?.selectedHour, let minute = self?.selectedMinute else { return }
            print("Selected Time: \(hour):\(minute)")
            self?.input.send(.saveButtonTapped)
        }, for: .touchUpInside)
    }
    
    override func binding() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .saved:
                    print("Saved successfully")
                }
            }.store(in: &cancellables)
    }
}

// MARK: - UICollectionViewDelegate
extension SheetTimeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == layoutView.hourCollectionView {
            selectedHour = indexPath.row + 1 // Set selected hour
            print("Selected Hour: \(selectedHour!)")
        } else if collectionView == layoutView.minuteCollectionView {
            selectedMinute = indexPath.row * 5 // Set selected minute
            print("Selected Minute: \(selectedMinute!)")
        }
    }
}
