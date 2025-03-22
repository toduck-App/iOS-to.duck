import UIKit
import Combine
import SnapKit
import TDDesign
import Then

protocol SheetColorDelegate: AnyObject {
    func didSaveCategory()
}

final class SheetColorViewController: BaseViewController<SheetColorView> {
    // MARK: - Properties
    private let viewModel: SheetColorViewModel
    private let input = PassthroughSubject<SheetColorViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    private var selectedCategoryIndex: Int?
    weak var coordinator: SheetColorCoordinator?
    weak var delegate: SheetColorDelegate?
    
    // MARK: - Initializers
    init(viewModel: SheetColorViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        input.send(.fetchCategories)
    }
    
    // MARK: - Common Methods
    override func configure() {
        layoutView.cancelButton.addAction(UIAction { [weak self] _ in
            self?.coordinator?.finish(by: .modal)
        }, for: .touchUpInside)
        
        layoutView.saveButton.addAction(UIAction { [weak self] _ in
            self?.input.send(.saveCategory)
        }, for: .touchUpInside)
        
        layoutView.colorPaletteView.isUserInteractionEnabled = false
        layoutView.categoryCollectionView.delegate = self
        layoutView.colorPaletteView.delegate = self
    }
    
    override func binding() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .fetchedCategories:
                    self?.layoutView.categoryCollectionView.setupCategoryView(
                        colors: self?.viewModel.categories.compactMap { $0.colorHex.convertToUIColor()
                        } ?? [])
                case .updatedCategoryColor:
                    self?.coordinator?.finish(by: .sheet(completion: { [weak self] in
                        self?.delegate?.didSaveCategory()
                    }))
                }
            }.store(in: &cancellables)
    }
}

extension SheetColorViewController: TDCategoryColorPaletteViewDelegate {
    func didSelectColor(_ color: UIColor) {
        guard let index = selectedCategoryIndex else { return }
        input.send(.updateCategoryColor(index, color.convertToHexString() ?? ""))
        layoutView.categoryCollectionView.updateColor(at: index, with: color)
    }
}

extension SheetColorViewController: TDCategoryCellDelegate {
    func didTapCategoryCell(_ color: UIColor, _ image: UIImage, _ index: Int) {
        selectedCategoryIndex = index
        
        layoutView.colorPaletteView.setSelectedColor(color)
        layoutView.colorPaletteView.isUserInteractionEnabled = true
        layoutView.updateSaveButtonState()
    }
}
