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
    
    private var isAllDay: Bool = false {
        didSet {
            layoutView.allDaySwitch.isOn = isAllDay
            handleAllDaySwitch(isOn: isAllDay)
        }
    }
    private var isAM: Bool = true {
        didSet {
            layoutView.amButton.isSelected = isAM
            layoutView.pmButton.isSelected = !isAM
        }
    }
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
        layoutView.minuteCollectionView.delegate = self
        layoutView.minuteCollectionView.dataSource = self
        
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
            self.isAllDay = switchControl.isOn
        }, for: .valueChanged)
        
        /// 오전/오후 설정
        layoutView.amButton.addAction(UIAction { [weak self] _ in
            if (self?.layoutView.pmButton.isSelected) != nil {
                self?.layoutView.pmButton.isSelected = false
            }
            self?.isAM = true
        }, for: .touchUpInside)
        
        layoutView.pmButton.addAction(UIAction { [weak self] _ in
            if (self?.layoutView.amButton.isSelected) != nil {
                self?.layoutView.amButton.isSelected = false
            }
            self?.isAM = false
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
        print("Selected: \(indexPath.row)")
        if collectionView == layoutView.hourCollectionView {
            selectedHour = indexPath.row + 1
        } else {
            selectedMinute = indexPath.row * 5
        }
        // 선택한 셀의 배경색 변경
        collectionView.reloadData()
        
        print("Selected Time: \(selectedHour ?? 0):\(selectedMinute ?? 0)")
    }
}




// MARK: - UICollectionViewDataSource
extension SheetTimeViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        12
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let reuseIdentifier = collectionView == layoutView.hourCollectionView ? "HourCell" : "MinuteCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        let text = collectionView == layoutView.hourCollectionView
        ? "\(indexPath.row + 1)"
        : String(format: "%02d", indexPath.row * 5)
        
        // 기존 서브뷰 제거
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        
        let containerView = UIView()
        containerView.layer.cornerRadius = 8
        containerView.layer.masksToBounds = true
        cell.contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let label = UILabel()
        label.text = text
        label.font = TDFont.mediumBody2.font
        label.textAlignment = .center
        containerView.addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // 선택 상태에 따라 UI 업데이트
        if (collectionView == layoutView.hourCollectionView && indexPath.row + 1 == selectedHour) ||
            (collectionView == layoutView.minuteCollectionView && indexPath.row * 5 == selectedMinute) {
            containerView.backgroundColor = TDColor.Primary.primary100
            label.textColor = TDColor.Primary.primary500
        } else {
            containerView.backgroundColor = TDColor.Neutral.neutral50
            label.textColor = TDColor.Neutral.neutral500
        }
        
        return cell
    }
    
}
