import UIKit
import SnapKit
import TDDesign
import Then

final class SheetTimeView: BaseView {
    // MARK: - UI Components
    let closeButton = UIButton(type: .system).then {
        $0.setImage(TDImage.X.x1Medium, for: .normal)
        $0.tintColor = TDColor.Neutral.neutral700
    }
    private let titleLabel = TDLabel(
        labelText: "날짜 선택",
        toduckFont: TDFont.boldHeader4,
        toduckColor: TDColor.Neutral.neutral800
    )
    
    private let mainStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = LayoutConstants.mainStackSpacing
    }
    
    private let allDayContainerView = UIView()
    private let allDayLabel = TDLabel(
        labelText: "종일",
        toduckFont: TDFont.mediumBody2,
        toduckColor: TDColor.Neutral.neutral800
    )
    let allDaySwitch = UISwitch().then {
        $0.onTintColor = TDColor.Primary.primary500
    }
    
    private let ampmHorizontalStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = LayoutConstants.ampmSpacing
    }
    private let ampmLabel = TDLabel(
        labelText: "시간대",
        toduckFont: TDFont.mediumBody2
    )
    private let ampmButtonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = LayoutConstants.ampmButtonSpacing
    }
    let amButton = TDSelectableButton(
        title: "오전",
        backgroundColor: TDColor.Neutral.neutral50,
        foregroundColor: TDColor.Neutral.neutral800,
        radius: LayoutConstants.buttonCornerRadius,
        font: TDFont.mediumBody2.font
    )
    let pmButton = TDSelectableButton(
        title: "오후",
        backgroundColor: TDColor.Neutral.neutral50,
        foregroundColor: TDColor.Neutral.neutral800,
        radius: LayoutConstants.buttonCornerRadius,
        font: TDFont.mediumBody2.font
    )
    
    private let hourContainerView = UIView()
    private let hourLabel = TDLabel(
        labelText: "시",
        toduckFont: TDFont.mediumBody2
    )
    lazy var hourCollectionView: UICollectionView = {
        let layout = DynamicFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = LayoutConstants.collectionViewSpacing
        layout.minimumLineSpacing = LayoutConstants.collectionViewSpacing
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }().then {
        $0.backgroundColor = .white
    }
    
    private let minuteContainerView = UIView()
    private let minLabel = TDLabel(
        labelText: "분",
        toduckFont: TDFont.mediumBody2
    )
    lazy var minuteCollectionView: UICollectionView = {
        let layout = DynamicFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = LayoutConstants.collectionViewSpacing
        layout.minimumLineSpacing = LayoutConstants.collectionViewSpacing
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }().then {
        $0.backgroundColor = .white
    }
    
    private let buttonHorizontalStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = LayoutConstants.buttonSpacing
    }
    let cancelButton = TDBaseButton(
        title: "취소",
        backgroundColor: TDColor.baseWhite,
        foregroundColor: TDColor.Neutral.neutral700,
        radius: LayoutConstants.buttonCornerRadius,
        font: TDFont.boldHeader3.font
    )
    let saveButton = TDBaseButton(
        title: "저장",
        backgroundColor: TDColor.Neutral.neutral100,
        foregroundColor: TDColor.Neutral.neutral700,
        radius: LayoutConstants.buttonCornerRadius,
        font: TDFont.boldHeader3.font
    )
    
    override func addview() {
        addSubview(closeButton)
        addSubview(titleLabel)
        addSubview(mainStackView)
        addSubview(buttonHorizontalStackView)
        
        mainStackView.addArrangedSubview(allDayContainerView)
        allDayContainerView.addSubview(allDayLabel)
        allDayContainerView.addSubview(allDaySwitch)
        
        mainStackView.addArrangedSubview(ampmHorizontalStackView)
        ampmHorizontalStackView.addSubview(ampmLabel)
        ampmHorizontalStackView.addSubview(ampmButtonStackView)
        ampmButtonStackView.addArrangedSubview(amButton)
        ampmButtonStackView.addArrangedSubview(pmButton)
        
        mainStackView.addArrangedSubview(hourContainerView)
        hourContainerView.addSubview(hourLabel)
        hourContainerView.addSubview(hourCollectionView)
        
        mainStackView.addArrangedSubview(minuteContainerView)
        minuteContainerView.addSubview(minLabel)
        minuteContainerView.addSubview(minuteCollectionView)
        
        buttonHorizontalStackView.addArrangedSubview(cancelButton)
        buttonHorizontalStackView.addArrangedSubview(saveButton)
    }
    
    override func layout() {
        closeButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(LayoutConstants.closeButtonTopOffset)
            $0.leading.equalToSuperview().inset(LayoutConstants.horizontalInset)
            $0.size.equalTo(LayoutConstants.closeButtonSize)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(closeButton)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(LayoutConstants.titleHeight)
        }
        
        mainStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(LayoutConstants.mainStackTopOffset)
            $0.leading.trailing.equalToSuperview().inset(LayoutConstants.horizontalInset)
            $0.bottom.equalTo(buttonHorizontalStackView.snp.top).offset(-LayoutConstants.buttonStackTopOffset)
        }
        
        /// All Day Switch
        allDayContainerView.snp.makeConstraints {
            $0.height.equalTo(LayoutConstants.allDayHeight)
        }
        
        allDayLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(LayoutConstants.horizontalInset)
        }
        
        allDaySwitch.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(LayoutConstants.horizontalInset)
        }
        
        /// AM/PM Button StackView
        ampmHorizontalStackView.snp.makeConstraints {
            $0.height.equalTo(LayoutConstants.ampmHeight)
        }
        
        ampmLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.width.equalTo(LayoutConstants.ampmLabelWidth)
        }
        
        ampmButtonStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(ampmLabel.snp.trailing)
            $0.trailing.equalToSuperview()
        }
        
        /// Hour CollectionView
        hourContainerView.snp.makeConstraints {
            $0.height.equalTo(LayoutConstants.collectionViewHeight)
        }
        
        hourLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.width.equalTo(LayoutConstants.labelWidth)
        }
        
        hourCollectionView.snp.makeConstraints {
            $0.top.bottom.trailing.equalToSuperview()
            $0.leading.equalTo(hourLabel.snp.trailing)
        }
        
        /// Minute CollectionView
        minuteContainerView.snp.makeConstraints {
            $0.height.equalTo(LayoutConstants.collectionViewHeight)
        }
        
        minLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.width.equalTo(LayoutConstants.labelWidth)
        }
        
        minuteCollectionView.snp.makeConstraints {
            $0.top.bottom.trailing.equalToSuperview()
            $0.leading.equalTo(minLabel.snp.trailing)
        }
        
        buttonHorizontalStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(LayoutConstants.horizontalInset)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(LayoutConstants.buttonBottomOffset)
            $0.height.equalTo(LayoutConstants.buttonHeight)
        }
    }
    
    override func configure() {
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = TDColor.Neutral.neutral300.cgColor
    }
}

// MARK: - Layout Constants
private extension SheetTimeView {
    enum LayoutConstants {
        static let closeButtonSize: CGFloat = 24
        static let titleHeight: CGFloat = 24
        static let horizontalInset: CGFloat = 16
        static let mainStackSpacing: CGFloat = 24
        static let mainStackTopOffset: CGFloat = 16
        static let closeButtonTopOffset: CGFloat = 16
        static let allDayHeight: CGFloat = 50
        static let ampmHeight: CGFloat = 50
        static let ampmSpacing: CGFloat = 8
        static let ampmButtonSpacing: CGFloat = 10
        static let ampmLabelWidth: CGFloat = 68
        static let collectionViewHeight: CGFloat = 110
        static let collectionViewSpacing: CGFloat = 8
        static let labelWidth: CGFloat = 68
        static let buttonSpacing: CGFloat = 10
        static let buttonCornerRadius: CGFloat = 12
        static let buttonStackTopOffset: CGFloat = 36
        static let buttonBottomOffset: CGFloat = 16
        static let buttonHeight: CGFloat = 56
    }
}
