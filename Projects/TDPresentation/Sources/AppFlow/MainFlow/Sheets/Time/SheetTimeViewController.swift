import UIKit
import Combine
import SnapKit
import TDDesign
import Then

protocol SheetTimeDelegate: AnyObject {
    func didTapSaveButton(isAllDay: Bool, isAM: Bool, hour: Int, minute: Int)
}

final class SheetTimeViewController: BaseViewController<SheetTimeView> {
    // MARK: - Properties
    private var isAllDay: Bool = false {
        didSet {
            layoutView.allDaySwitch.setOn(isAllDay, animated: true)
            handleAllDaySwitch(isOn: isAllDay)
            updateSaveButtonState()
        }
    }
    private var isAM: Bool = true {
        didSet {
            layoutView.amButton.isSelected = isAM
            layoutView.pmButton.isSelected = !isAM
            layoutView.hourCollectionView.reloadData()
            updateSaveButtonState()
        }
    }
    private var selectedHour: Int? {
        didSet {
            updateSaveButtonState()
        }
    }
    private var selectedMinute: Int? {
        didSet {
            updateSaveButtonState()
        }
    }
    weak var coordinator: SheetTimeCoordinator?
    weak var delegate: SheetTimeDelegate?
    
    // MARK: - Setup & Configuration
    override func configure() {
        layoutView.backgroundColor = TDColor.baseWhite
        layoutView.saveButton.isUserInteractionEnabled = false
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
        /// 취소 버튼
        layoutView.closeButton.addAction(UIAction { [weak self] _ in
            self?.coordinator?.finish(by: .modal)
        }, for: .touchUpInside)
        
        /// 종일 설정
        layoutView.allDaySwitch.addAction(UIAction { [weak self] action in
            guard let switchControl = action.sender as? UISwitch else { return }
            self?.isAllDay = switchControl.isOn
        }, for: .valueChanged)
        
        /// 오전/오후 설정
        layoutView.amButton.addAction(UIAction { [weak self] _ in
            self?.isAllDay = false
            self?.isAM = true
        }, for: .touchUpInside)

        layoutView.pmButton.addAction(UIAction { [weak self] _ in
            self?.isAllDay = false
            self?.isAM = false
        }, for: .touchUpInside)
        
        /// 취소/저장 버튼
        layoutView.cancelButton.addAction(UIAction { [weak self] _ in
            self?.coordinator?.finish(by: .modal)
        }, for: .touchUpInside)
        
        layoutView.saveButton.addAction(UIAction { [weak self] _ in
            guard let self = self else { return }
            if self.layoutView.saveButton.isEnabled {
                let hour = self.selectedHour ?? 0
                let minute = self.selectedMinute ?? 0
                let finalHour = self.convertedHour(from: hour, isAM: self.isAM)
                
                self.delegate?.didTapSaveButton(
                    isAllDay: self.isAllDay,
                    isAM: self.isAM,
                    hour: finalHour,
                    minute: minute
                )
            }
            self.coordinator?.finish(by: .modal)
        }, for: .touchUpInside)
    }
    
    private func convertedHour(from hour: Int, isAM: Bool) -> Int {
        if hour == 12 {
            return isAM ? 0 : 12
        } else {
            return isAM ? hour : hour + 12
        }
    }
    
    // MARK: - Action Handlers
    private func handleAllDaySwitch(isOn: Bool) {
        // 오전/오후 설정
        layoutView.amButton.alpha = isOn ? 0.5 : 1.0
        layoutView.pmButton.alpha = isOn ? 0.5 : 1.0
        
        // 시간 설정
        layoutView.hourCollectionView.alpha = isOn ? 0.5 : 1.0
        layoutView.minuteCollectionView.alpha = isOn ? 0.5 : 1.0
        
        if isOn {
            selectedHour = nil
            selectedMinute = nil
            deselectAllItems(in: layoutView.hourCollectionView)
            deselectAllItems(in: layoutView.minuteCollectionView)
        }
    }
    
    private func deselectAllItems(in collectionView: UICollectionView) {
        layoutView.amButton.isSelected = false
        layoutView.pmButton.isSelected = false
        for indexPath in collectionView.indexPathsForSelectedItems ?? [] {
            collectionView.deselectItem(at: indexPath, animated: true)
        }
        collectionView.reloadData()
    }
    
    private func updateSaveButtonState() {
        // 저장 버튼 활성화 조건: 종일이 눌러져 있거나, 오전/오후, 시간, 분이 모두 선택된 경우
        let isSaveEnabled = isAllDay || (selectedHour != nil && selectedMinute != nil && layoutView.amButton.isSelected != layoutView.pmButton.isSelected)
        
        layoutView.saveButton.isUserInteractionEnabled = isSaveEnabled
        layoutView.saveButton.layer.borderWidth = 0
        
        var configuration = layoutView.saveButton.configuration ?? UIButton.Configuration.filled()
        configuration.baseBackgroundColor = isSaveEnabled ? TDColor.Primary.primary500 : TDColor.Neutral.neutral100
        configuration.baseForegroundColor = isSaveEnabled ? TDColor.baseWhite : TDColor.Neutral.neutral700
        layoutView.saveButton.configuration = configuration
    }
}

// MARK: - UICollectionViewDelegate
extension SheetTimeViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        if isAllDay {
            isAllDay = false
        }
        
        if collectionView == layoutView.hourCollectionView {
            selectedHour = indexPath.row + 1
        } else {
            selectedMinute = indexPath.row * 5
        }

        collectionView.reloadData()
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
        
        let isHourCollection = collectionView == layoutView.hourCollectionView
        let text = isHourCollection
            ? "\(indexPath.row + 1)"
            : String(format: "%02d", indexPath.row * 5)
        
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        
        let containerView = UIView()
        containerView.layer.cornerRadius = 8
        containerView.layer.masksToBounds = true
        cell.contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let label = TDLabel(
            labelText: text,
            toduckFont: .mediumBody2,
            alignment: .center
        )
        
        let isSelected =
            (isHourCollection && indexPath.row + 1 == selectedHour) ||
            (!isHourCollection && indexPath.row * 5 == selectedMinute)
        
        // MARK: - Hour Cell
        if isHourCollection {
            let hour = indexPath.row + 1
            
            if hour == 12 {
                if isSelected && (layoutView.amButton.isSelected || layoutView.pmButton.isSelected) {
                    // 12시 + 선택됨: 해/달 이미지 + 이미지 위에 텍스트
                    containerView.backgroundColor = isAM ? TDColor.SunMoon.moon : TDColor.SunMoon.sun
                    
                    let imageView = UIImageView()
                    imageView.image = isAM ? TDImage.SunMoon.moon : TDImage.SunMoon.sun
                    imageView.contentMode = .scaleAspectFit
                    containerView.addSubview(imageView)
                    
                    let imageSize: CGFloat = isAM ? 28 : 32
                    imageView.snp.makeConstraints { make in
                        make.center.equalToSuperview()
                        make.width.height.equalTo(imageSize)
                    }
                    
                    containerView.addSubview(label)
                    label.snp.makeConstraints { make in
                        make.center.equalToSuperview()
                    }
                    
                    label.setColor(TDColor.Neutral.neutral800)
                } else {
                    // 12시 + 선택 안 됨: 일반 셀처럼 표시
                    containerView.addSubview(label)
                    label.snp.makeConstraints { make in
                        make.edges.equalToSuperview()
                    }
                    
                    if isSelected {
                        containerView.backgroundColor = TDColor.Primary.primary100
                        label.setColor(TDColor.Primary.primary500)
                    } else {
                        containerView.backgroundColor = TDColor.Neutral.neutral50
                        label.setColor(TDColor.Neutral.neutral800)
                    }
                }
            } else {
                // 1~11시
                containerView.addSubview(label)
                label.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
                
                if isSelected {
                    containerView.backgroundColor = TDColor.Primary.primary100
                    label.setColor(TDColor.Primary.primary500)
                } else {
                    containerView.backgroundColor = TDColor.Neutral.neutral50
                    label.setColor(TDColor.Neutral.neutral800)
                }
            }
        }
        
        // MARK: - Minute Cell
        else {
            containerView.addSubview(label)
            label.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            if isSelected {
                containerView.backgroundColor = TDColor.Primary.primary100
                label.setColor(TDColor.Primary.primary500)
            } else {
                containerView.backgroundColor = TDColor.Neutral.neutral50
                label.setColor(TDColor.Neutral.neutral800)
            }
        }
        
        return cell
    }
}
