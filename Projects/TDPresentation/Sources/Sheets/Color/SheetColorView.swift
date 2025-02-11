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
        backgroundColor: TDColor.Primary.primary500,
        foregroundColor: TDColor.baseWhite,
        radius: LayoutConstants.buttonCornerRadius,
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
            $0.top.equalTo(safeAreaLayoutGuide).offset(LayoutConstants.titleTopOffset)
            $0.centerX.equalTo(self)
        }
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(LayoutConstants.descriptionTopOffset)
            $0.leading.equalTo(safeAreaLayoutGuide).offset(LayoutConstants.horizontalInset)
        }
        categoryCollectionView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(LayoutConstants.categoryTopOffset)
            $0.leading.equalTo(safeAreaLayoutGuide).offset(LayoutConstants.horizontalInset)
            $0.trailing.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(LayoutConstants.categoryHeight)
        }
        dividedView.snp.makeConstraints {
            $0.top.equalTo(categoryCollectionView.snp.bottom).offset(LayoutConstants.dividedTopOffset)
            $0.leading.equalTo(safeAreaLayoutGuide).offset(LayoutConstants.horizontalInset)
            $0.trailing.equalTo(safeAreaLayoutGuide).offset(-LayoutConstants.horizontalInset)
            $0.height.equalTo(LayoutConstants.dividerHeight)
        }
        colorPaletteView.snp.makeConstraints {
            $0.top.equalTo(dividedView.snp.bottom).offset(LayoutConstants.colorPaletteTopOffset)
            $0.leading.equalTo(safeAreaLayoutGuide).offset(LayoutConstants.horizontalInset)
            $0.trailing.equalTo(safeAreaLayoutGuide).offset(-LayoutConstants.horizontalInset)
            $0.bottom.equalTo(buttonHorizontalStackView.snp.top).offset(-LayoutConstants.buttonStackTopOffset)
        }
        buttonHorizontalStackView.snp.makeConstraints {
            $0.leading.equalTo(safeAreaLayoutGuide).offset(LayoutConstants.horizontalInset)
            $0.trailing.equalTo(safeAreaLayoutGuide).offset(-LayoutConstants.horizontalInset)
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-LayoutConstants.buttonBottomOffset)
            $0.centerX.equalTo(self)
        }
    }
    
    override func configure() {
        backgroundColor = TDColor.baseWhite
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = TDColor.Neutral.neutral300.cgColor
        
        updateSaveButtonState()
    }
    
    func updateSaveButtonState() {
        let isEnabled = categoryCollectionView.isCategorySelected()
        saveButton.isEnabled = isEnabled
        saveButton.backgroundColor = isEnabled ? TDColor.Primary.primary500 : TDColor.Neutral.neutral100
        saveButton.layer.borderWidth = 0
    }
}

// MARK: - Layout Constants
private extension SheetColorView {
    enum LayoutConstants {
        static let titleTopOffset: CGFloat = 24
        static let descriptionTopOffset: CGFloat = 40
        static let categoryTopOffset: CGFloat = 16
        static let dividedTopOffset: CGFloat = 24
        static let colorPaletteTopOffset: CGFloat = 24
        static let buttonStackTopOffset: CGFloat = 20
        static let buttonBottomOffset: CGFloat = 16
        
        static let horizontalInset: CGFloat = 16
        static let buttonSpacing: CGFloat = 10
        static let buttonCornerRadius: CGFloat = 12
        
        static let categoryHeight: CGFloat = 50
        static let dividerHeight: CGFloat = 1
    }
}
