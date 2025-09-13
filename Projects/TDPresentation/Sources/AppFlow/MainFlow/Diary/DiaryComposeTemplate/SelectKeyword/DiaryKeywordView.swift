import UIKit
import TDDesign

final class DiaryKeywordView: BaseView {
    // MARK: - UI Components
    
    let titleLabel = TDLabel(
        labelText: "오늘의 기분은 어땠나요?",
        toduckFont: .boldHeader4,
        toduckColor: TDColor.Neutral.neutral800
    )
    let descriptionLabel = TDLabel(
        labelText: "가장 가까운 감정 이모지를 선택해주세요",
        toduckFont: .boldBody2,
        toduckColor: TDColor.Neutral.neutral600
    )
    
    // MARK: - Common Methods
    
    override func addview() {
        [
            titleLabel,
            descriptionLabel
        ].forEach { addSubview($0) }
    }
    
    override func layout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(42)
            $0.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
    }
}
