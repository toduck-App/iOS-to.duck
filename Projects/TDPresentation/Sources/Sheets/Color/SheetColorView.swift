import UIKit
import SnapKit
import TDDesign
import Then

final class SheetColorView: BaseView {
    // MARK: - UI Components
    private let titleLabel = TDLabel(
        labelText: "색상 수정",
        toduckFont: TDFont.boldHeader4,
        toduckColor: TDColor.Neutral.neutral800
    )
    private let descriptionLabel = TDLabel(
        labelText: "수정할 카테고리 선택",
        toduckFont: TDFont.mediumBody2,
        toduckColor: TDColor.Neutral.neutral800
    )
    let categoryCollectionView = TDCategoryCollectionView()
    private let dividedView = UIView.dividedLine()
    let colorPaletteView = TDCategoryColorPaletteView()
    private let buttonHorizontalStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10
    }
    let cancelButton = TDBaseButton(
        title: "취소",
        backgroundColor: TDColor.baseWhite,
        foregroundColor: TDColor.Neutral.neutral700,
        radius: 12,
        font: TDFont.boldHeader3.font
    )
    let saveButton = TDBaseButton(
        title: "저장",
        backgroundColor: TDColor.Primary.primary500,
        foregroundColor: TDColor.baseWhite,
        radius: 12,
        font: TDFont.boldHeader3.font
    )
    
    // MARK: - Common Methods
    override func addview() {
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(categoryCollectionView)
        addSubview(dividedView)
        addSubview(colorPaletteView)
        addSubview(buttonHorizontalStackView)
        buttonHorizontalStackView.addArrangedSubview(cancelButton)
        buttonHorizontalStackView.addArrangedSubview(saveButton)
    }
    
    override func layout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(24)
            $0.centerX.equalTo(self)
        }
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(40)
            $0.leading.equalTo(safeAreaLayoutGuide).offset(16)
        }
        categoryCollectionView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(16)
            $0.leading.equalTo(safeAreaLayoutGuide).offset(16)
            $0.trailing.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(50)
        }
        dividedView.snp.makeConstraints {
            $0.top.equalTo(categoryCollectionView.snp.bottom).offset(24)
            $0.leading.equalTo(safeAreaLayoutGuide).offset(16)
            $0.trailing.equalTo(safeAreaLayoutGuide).offset(-16)
            $0.height.equalTo(1)
        }
        colorPaletteView.snp.makeConstraints {
            $0.top.equalTo(dividedView.snp.bottom).offset(24)
            $0.leading.equalTo(safeAreaLayoutGuide).offset(16)
            $0.trailing.equalTo(safeAreaLayoutGuide).offset(-16)
            $0.bottom.equalTo(buttonHorizontalStackView.snp.top).offset(-20)
        }
        buttonHorizontalStackView.snp.makeConstraints {
            $0.leading.equalTo(safeAreaLayoutGuide).offset(16)
            $0.trailing.equalTo(safeAreaLayoutGuide).offset(-16)
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-16)
            $0.centerX.equalTo(self)
        }
    }
    
    override func configure() {
        backgroundColor = TDColor.baseWhite
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = TDColor.Neutral.neutral300.cgColor
        
        categoryCollectionView.delegate = self
        updateSaveButtonState()
    }
    
    private func updateSaveButtonState() {
        let isEnabled = categoryCollectionView.isCategorySelected()
        saveButton.isEnabled = isEnabled
        saveButton.backgroundColor = isEnabled ? TDColor.Primary.primary500 : TDColor.Neutral.neutral100
        saveButton.layer.borderWidth = 0
    }
}

extension SheetColorView: TDCategoryCellDelegate {
    func didTapCategoryCell(_ color: UIColor, _ image: UIImage) {
        updateSaveButtonState()
    }
}
