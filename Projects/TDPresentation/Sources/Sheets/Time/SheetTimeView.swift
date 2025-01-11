import UIKit
import SnapKit
import TDDesign
import Then

final class SheetTimeView: BaseView {
    // MARK: - UI Components
    let cancelButton = UIButton(type: .system).then {
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
        $0.spacing = 24
    }
    private let allDayContainerView = UIView()
    private let allDayLabel = TDLabel(
        labelText: "종일",
        toduckFont: TDFont.mediumBody2
    )
    private let allDaySwitch = UISwitch().then {
        $0.onTintColor = TDColor.Primary.primary500
    }
    
    private let ampmHorizontalStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
    }
    private let ampmLabel = TDLabel(
        labelText: "오전/오후",
        toduckFont: TDFont.mediumBody2
    )
    private let ampmButtonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10
    }
    private let amButton = TDSelectableButton(
        title: "오전",
        backgroundColor: TDColor.Neutral.neutral50,
        foregroundColor: TDColor.Neutral.neutral700,
        radius: 8,
        font: TDFont.mediumBody2.font
    )
    private let pmButton = TDSelectableButton(
        title: "오후",
        backgroundColor: TDColor.Neutral.neutral50,
        foregroundColor: TDColor.Neutral.neutral700,
        radius: 8,
        font: TDFont.mediumBody2.font
    )
    
    private let hourContainerView = UIView()
    private let hourLabel = TDLabel(
        labelText: "시",
        toduckFont: TDFont.mediumBody2
    )
    let hourCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.itemSize = CGSize(width: 50, height: 50)
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    private let minuteContainerView = UIView()
    private let minLabel = TDLabel(
        labelText: "분",
        toduckFont: TDFont.mediumBody2
    )
    let minuteCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 6
        layout.minimumLineSpacing = 6
        layout.itemSize = CGSize(width: 50, height: 50)
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    let saveButton = TDBaseButton(
        title: "저장",
        backgroundColor: TDColor.Primary.primary500,
        foregroundColor: TDColor.baseWhite,
        radius: 12,
        font: TDFont.boldHeader3.font
    )
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Common Method
    override func configure() {
        backgroundColor = TDColor.baseWhite
    }
    
    override func addview() {
        addSubview(cancelButton)
        addSubview(titleLabel)
        addSubview(mainStackView)
        addSubview(saveButton)
        
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
    }
    
    override func layout() {
        cancelButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().inset(16)
            $0.width.height.equalTo(24)
        }
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(cancelButton)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(24)
        }
        
        mainStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(saveButton.snp.top).offset(-36)
        }
        
        /// All Day Switch
        allDayContainerView.snp.makeConstraints {
            $0.height.equalTo(50)
        }
        allDayLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
        }
        allDaySwitch.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
        }
        
        /// AM/PM Button StackView
        ampmHorizontalStackView.snp.makeConstraints {
            $0.height.equalTo(50)
        }
        ampmLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        ampmButtonStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(ampmLabel.snp.trailing).offset(16)
            $0.trailing.equalToSuperview()
        }
        
        /// Hour CollectionView
        hourContainerView.snp.makeConstraints {
            $0.height.equalTo(100)
        }
        hourLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        hourCollectionView.snp.makeConstraints {
            $0.top.bottom.trailing.equalToSuperview()
            $0.leading.equalTo(hourLabel.snp.trailing).offset(16)
        }
        
        /// Minute CollectionView
        minuteContainerView.snp.makeConstraints {
            $0.height.equalTo(100)
        }
        minLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        minuteCollectionView.snp.makeConstraints {
            $0.top.bottom.trailing.equalToSuperview()
            $0.leading.equalTo(minLabel.snp.trailing).offset(16)
        }
        
        saveButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(16)
            $0.height.equalTo(56)
        }
    }
}

}
