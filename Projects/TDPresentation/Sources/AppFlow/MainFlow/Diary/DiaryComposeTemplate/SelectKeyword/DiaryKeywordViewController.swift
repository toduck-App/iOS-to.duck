import UIKit
import TDDomain
import Combine
import TDDesign

enum DiaryKeywordViewType {
    case navigation
    case sheet
}

final class DiaryKeywordViewController: BaseViewController<DiaryKeywordView> {
    typealias KeywordSection = UserKeywordCategory
    typealias KeywordItem = UserKeyword
    
    // MARK: - UI Components
    private var dataSource: UICollectionViewDiffableDataSource<KeywordSection, KeywordItem>!
    
    let navigationProgressView = NavigationProgressView()
    
    let pageLabel = TDLabel(
        labelText: "2 / 3",
        toduckFont: .mediumHeader4,
        toduckColor: TDColor.Neutral.neutral600
    )
    
    // MARK: - Properties
    private let viewModel: DiaryKeywordViewModel
    private let input = PassthroughSubject<DiaryKeywordViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    weak var coordinator: DiaryKeywordCoordinator?
    var onKeywordsSelected: (([UserKeyword]) -> Void)?
    private let viewType: DiaryKeywordViewType
    
    // MARK: - Initializer
    init(viewModel: DiaryKeywordViewModel, viewType: DiaryKeywordViewType = .navigation) {
        self.viewModel = viewModel
        self.viewType = viewType
        super.init()
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        input.send(.fetchKeywords)
    }
    
    override func configure() {
        super.configure()
        configureDataSource()
        
        switch viewType {
        case .navigation:
            configurePagingNavigationBar(currentPage: 2, totalPages: 3)
        case .sheet:
            navigationItem.hidesBackButton = true
        }
        
        layoutView.configure(for: viewType)
        layoutView.keywordCollectionView.delegate = self
        setupButtonAction()
    }
    
    // MARK: - Diffable DataSource
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource(
            collectionView: layoutView.keywordCollectionView
        ) { [weak self] collectionView, indexPath, item in
            
            guard
                let self,
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: DiaryKeywordCell.identifier,
                    for: indexPath
                ) as? DiaryKeywordCell
            else {
                return UICollectionViewCell()
            }
            
            switch viewModel.currentMode {
            case .normal:
                let isSelected = viewModel.selectedKeywords.contains { $0.id == item.id }
                cell.configure(mode: .normal, keyword: item.name, isSelected: isSelected)
                
            case .remove:
                let isSelected = viewModel.removedKeywords.contains { $0.id == item.id }
                cell.configure(mode: .remove, keyword: item.name, isSelected: isSelected)
            }
            
            return cell
        }
        
        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let self else { return nil }
            
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: DiaryKeywordHeader.identifier,
                for: indexPath
            ) as? DiaryKeywordHeader else {
                return nil
            }
            
            header.configure(title: section.title, image: section.image)
            return header
        }
    }
    
    // MARK: - Binding
    override func binding() {
        super.binding()
        
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self else { return }
                switch event {
                case .updateKeywords(let keywords):
                    applySnapshot(keywords)
                case .updateSelection:
                    updateSelection()
                    layoutView.removeKeywordRemoveButton.isEnabled = !viewModel.removedKeywords.isEmpty
                case .updateSelectedKeywords(let keywords):
                    layoutView.updateSelectedKeywords(keywords)
                    // 키워드가 변경되면 콜백 호출 (시트 모드일 때만)
                    if viewType == .sheet {
                        onKeywordsSelected?(keywords)
                    }
                case .failure(let desc):
                    showErrorAlert(errorMessage: desc)
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupButtonAction() {
        layoutView.keywordCategorySegment.addTarget(self, action: #selector(categoryChanged), for: .valueChanged)
        
        layoutView.keywordAddButton.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            let vc = CreateKeywordPopupViewController()
            vc.onCreateHandler = {
                self.input.send(.fetchKeywords)
            }
            self.presentPopup(with: vc)
        }, for: .touchUpInside)
        
        // 삭제 모드 진입
        layoutView.keywordRemoveButton.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            layoutView.setRemoveMode()
            input.send(.changeMode(.remove))
        }, for: .touchUpInside)
        
        // 삭제 모드 취소
        layoutView.removeKeywordCancelButton.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            layoutView.setNormalMode()
            input.send(.changeMode(.normal))
            input.send(.clearDeleteKeywords)
        }, for: .touchUpInside)
        
        // 삭제 실행
        layoutView.removeKeywordRemoveButton.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            layoutView.setNormalMode()
            input.send(.deleteKeywords)
            input.send(.changeMode(.normal))
        }, for: .touchUpInside)
        
        layoutView.skipButton.addAction(
            UIAction { [weak self] _ in
                guard let self else { return }
                self.handleSkipButton()
            },
            for: .touchUpInside
        )
        
        layoutView.saveButton.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            self.handleSaveButton()
        }, for: .touchUpInside)
        
        let longPress = UILongPressGestureRecognizer(
            target: self,
            action: #selector(handleBookLongPress)
        )
        longPress.minimumPressDuration = 0.6
        layoutView.currentBookImageView.isUserInteractionEnabled = true
        layoutView.currentBookImageView.addGestureRecognizer(longPress)
    }
    
    // MARK: - Snapshot helpers
    private func applySnapshot(_ data: DiaryKeywordDictionary) {
        var snapshot = NSDiffableDataSourceSnapshot<KeywordSection, KeywordItem>()
        for category in UserKeywordCategory.allCases {
            guard let items = data[category] else { continue }
            snapshot.appendSections([category])
            snapshot.appendItems(items, toSection: category)
        }
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    /// 선택 상태 / 모드만 바뀌었을 때 snapshot 내 아이템을 reload
    private func updateSelection() {
        guard var snapshot = dataSource?.snapshot() else { return }
        let items = snapshot.itemIdentifiers
        snapshot.reloadItems(items)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    // MARK: - Actions
    @objc
    private func handleBookLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else { return }
        HapticManager.impact(.medium)
        input.send(.clearKeywords)
    }
    
    private func handleSkipButton() {
        switch viewType {
        case .sheet:
            onKeywordsSelected?([])
            dismiss(animated: true)
        case .navigation:
            guard let coordinator = coordinator,
                  let selectedMood = viewModel.selectedMood,
                  let selectedDate = viewModel.selectedDate else { return }
            coordinator.showWriteDiaryCompose(
                selectedMood: selectedMood,
                selectedDate: selectedDate,
                selectedKeywords: []
            )
        }
    }
    
    private func handleSaveButton() {
        switch viewType {
        case .sheet:
            onKeywordsSelected?(viewModel.selectedKeywords)
            dismiss(animated: true)
        case .navigation:
            guard let coordinator = coordinator,
                  let selectedMood = viewModel.selectedMood,
                  let selectedDate = viewModel.selectedDate else { return }
            coordinator.showWriteDiaryCompose(
                selectedMood: selectedMood,
                selectedDate: selectedDate,
                selectedKeywords: viewModel.selectedKeywords
            )
        }
    }
}

// MARK: - UICollectionViewDelegate
extension DiaryKeywordViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        input.send(.toggleKeyword(item))
    }
    
    @objc
    private func categoryChanged(sender: TDSegmentedControl) {
        let index = sender.selectedIndex
        
        if index == 0 {
            input.send(.selectCategory(nil))
        } else {
            let category = UserKeywordCategory.allCases[index - 1]
            input.send(.selectCategory(category))
        }
        
        if let layout = layoutView.keywordCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.invalidateLayout()
        }
    }
}

// MARK: - PagingNavigationBarConfigurable
extension DiaryKeywordViewController: PagingNavigationBarConfigurable { }
