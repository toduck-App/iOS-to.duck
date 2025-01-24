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
    
    // MARK: - Setup & Configuration
    override func configure() {
        layoutView.backgroundColor = TDColor.baseWhite
        setupActions()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        layoutView.hourCollectionView.delegate = self
        layoutView.hourCollectionView.dataSource = self
        layoutView.hourCollectionView.allowsMultipleSelection = false

        layoutView.minuteCollectionView.delegate = self
        layoutView.minuteCollectionView.dataSource = self
        layoutView.minuteCollectionView.allowsMultipleSelection = false
        
        layoutView.hourCollectionView.register(
            UICollectionViewCell.self,
            forCellWithReuseIdentifier: "HourCell"
        )
        layoutView.minuteCollectionView.register(
            UICollectionViewCell.self,
            forCellWithReuseIdentifier: "MinuteCell"
        )
    }
    
    private func setupActions() {
        /// 종일 설정
        layoutView.allDaySwitch.addAction(UIAction { [weak self] action in
            guard let self = self, let switchControl = action.sender as? UISwitch else { return }
            self.handleAllDaySwitch(isOn: switchControl.isOn)
        }, for: .valueChanged)
        
        /// 오전/오후 설정
        layoutView.amButton.addAction(UIAction { [weak self] _ in
            if ((self?.layoutView.pmButton.isSelected) != nil) {
                self?.layoutView.pmButton.isSelected = false
            }
            print("Selected Time: AM")
        }, for: .touchUpInside)
        
        layoutView.pmButton.addAction(UIAction { [weak self] _ in
            if (self?.layoutView.amButton.isSelected) != nil {
                self?.layoutView.amButton.isSelected = false
            }
        }, for: .touchUpInside)
        
        /// 취소/저장 버튼
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
    
    // MARK: - Action Handlers
    private func handleAllDaySwitch(isOn: Bool) {
        // 오전/오후 설정
        layoutView.amButton.isUserInteractionEnabled = !isOn
        layoutView.pmButton.isUserInteractionEnabled = !isOn
        layoutView.amButton.alpha = isOn ? 0.5 : 1.0
        layoutView.pmButton.alpha = isOn ? 0.5 : 1.0
        
        // 시간 설정
        layoutView.hourCollectionView.isUserInteractionEnabled = !isOn
        layoutView.minuteCollectionView.isUserInteractionEnabled = !isOn
        layoutView.hourCollectionView.alpha = isOn ? 0.5 : 1.0
        layoutView.minuteCollectionView.alpha = isOn ? 0.5 : 1.0
    }
    
    private func deselectAllItems(in collectionView: UICollectionView) {
        for indexPath in collectionView.indexPathsForSelectedItems ?? [] {
            collectionView.deselectItem(at: indexPath, animated: true)
        }
    }
}

// MARK: - UICollectionViewDelegate
extension SheetTimeViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        if collectionView == layoutView.hourCollectionView {
            selectedHour = indexPath.row + 1
        } else {
            selectedMinute = indexPath.row * 5
        }
        print("Selected Time: \(selectedHour ?? 0):\(selectedMinute ?? 0)")
    }
}




// MARK: - UICollectionViewDataSource
extension SheetTimeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == layoutView.hourCollectionView {
            return 12 // 1 ~ 12
        } else {
            return 12 // 00, 05, ..., 55
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reuseIdentifier = collectionView == layoutView.hourCollectionView ? "HourCell" : "MinuteCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        let text = collectionView == layoutView.hourCollectionView
            ? "\(indexPath.row + 1)"
            : String(format: "%02d", indexPath.row * 5)
        
        let isSelected = (collectionView == layoutView.hourCollectionView && indexPath.row + 1 == selectedHour) ||
                         (collectionView == layoutView.minuteCollectionView && indexPath.row * 5 == selectedMinute)
        
        let backgroundColor = isSelected ? TDColor.Primary.primary500 : TDColor.Neutral.neutral50
        let textColor = isSelected ? TDColor.baseWhite : TDColor.Neutral.neutral500
        
        let selectableButton = TDSelectableButton(
            title: text,
            backgroundColor: backgroundColor,
            foregroundColor: textColor,
            radius: 8,
            font: TDFont.mediumBody2.font
        )
        
        cell.contentView.subviews.forEach { $0.removeFromSuperview() } // 기존 뷰 제거
        cell.contentView.addSubview(selectableButton)
        selectableButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        return cell
    }
}
