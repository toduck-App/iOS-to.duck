import UIKit
import TDDomain
import Combine
import TDDesign

final class DiaryKeywordViewController: BaseViewController<DiaryKeywordView> {
    
    typealias KeywordSection = DiaryKeywordCategory
    typealias KeywordItem = DiaryKeyword
    // MARK: - UI Components
    private var dataSource: UICollectionViewDiffableDataSource<KeywordSection, KeywordItem>!

    let navigationProgressView = NavigationProgressView()
    
    let pageLabel = TDLabel(
        labelText: "2 / 3",
        toduckFont: .mediumHeader4,
        toduckColor: TDColor.Neutral.neutral600,
    )
    
    // MARK: - Properties
    
    private let viewModel: DiaryKeywordViewModel
    private let input = PassthroughSubject<DiaryKeywordViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    weak var coordinator: DiaryKeywordCoordinator?
    
    // MARK: - Initializer
    
    init(viewModel: DiaryKeywordViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        input.send(.fetchKeywords)
    }
    
    // MARK: - Life Cycle
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // MARK: - Common Methods
    
    override func configure() {
        configureDataSource()
        configurePagingNavigationBar(currentPage: 2, totalPages: 3)
        layoutView.keywordCollectionView.delegate = self
        layoutView.keywordCategorySegment.addTarget(self, action: #selector(categoryChanged), for: .valueChanged)
        layoutView.keywordAddButton.addAction(UIAction { [weak self] _ in
            print("Add Keyword Button Tapped")
        }, for: .touchUpInside)
        
        layoutView.keywordRemoveButton.addAction(UIAction { [weak self] _ in
            print("Remove Keyword Button Tapped")
        }, for: .touchUpInside)
        
        layoutView.skipButton.addAction(
            UIAction { [weak self] _ in
                guard let self else { return }
                coordinator?.showWriteDiaryCompose(
                    selectedMood: viewModel.selectedMood,
                    selectedDate: viewModel.selectedDate,
                    selectedKeywords: []
                )
            },
            for: .touchUpInside)
        
        layoutView.saveButton.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            coordinator?.showWriteDiaryCompose(
                selectedMood: viewModel.selectedMood,
                selectedDate: viewModel.selectedDate,
                selectedKeywords: viewModel.selectedKeywords
            )
        }, for: .touchUpInside)
        
        let longPress = UILongPressGestureRecognizer(
            target: self,
            action: #selector(handleBookLongPress)
        )
        longPress.minimumPressDuration = 0.6
        layoutView.currentBookImageView.isUserInteractionEnabled = true
        layoutView.currentBookImageView.addGestureRecognizer(longPress)
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource(
            collectionView: layoutView.keywordCollectionView
        ) { [weak self] collectionView, indexPath, item in
            
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: DiaryKeywordCell.identifier,
                for: indexPath
            ) as? DiaryKeywordCell else { return UICollectionViewCell() }
            
            let isSelected = self?.viewModel.selectedKeywords.contains { $0.id == item.id} ?? false
            cell.configure(keyword: item.name, isSelected: isSelected)
            return cell
        }
        
        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let self else { return nil }
            
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]

            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: DiaryKeywordHeader.identifier,
                for: indexPath
            ) as? DiaryKeywordHeader else { return nil }
            
            header.configure(title: section.rawValue, image: section.image)
            return header
        }
    }


    
    override func binding() {
        super.binding()
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self else { return }
                switch event {
                case .updateKeywords(let keywords):
                    self.applySnapshot(keywords)
                case .updateSelection:
                    self.updateSelection()
                case .failure(let desc):
                    self.showErrorAlert(errorMessage: desc)
                }
            }.store(in: &cancellables)

    }
    
    private func applySnapshot(_ data: DiaryKeywordDictionary) {
        var snapshot = NSDiffableDataSourceSnapshot<KeywordSection, KeywordItem>()
        for category in DiaryKeywordCategory.allCases {
            guard let items = data[category] else { continue }
            snapshot.appendSections([category])
            snapshot.appendItems(items, toSection: category)
        }
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func updateSelection() {
        guard var snapshot = dataSource?.snapshot() else { return }
        snapshot.reloadItems(snapshot.itemIdentifiers)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    @objc private func handleBookLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else { return }
        HapticManager.impact(.medium)
        layoutView.removeAllKeywordsFromStackView()
        input.send(.clearKeywords)
    }
}

extension DiaryKeywordViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        input.send(.toggleKeyword(item))
        if viewModel.selectedKeywords.contains(where: { $0.id == item.id }) {
            layoutView.addKeywordToStackView(keyword: item)
        } else {
            layoutView.removeKeywordFromStackView(keyword: item)
        }
    }
    
    @objc
    private func categoryChanged(sender: TDSegmentedControl) {
        let index = sender.selectedIndex
        guard let layout = layoutView.keywordCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        if index == 0 {
            input.send(.selectCategory(nil))
        
        } else {
            let category = DiaryKeywordCategory.allCases[index - 1]
            input.send(.selectCategory(category))
        }
        
        layout.invalidateLayout()
    }
}

// MARK: - PagingNavigationBarConfigurable

extension DiaryKeywordViewController: PagingNavigationBarConfigurable { }
