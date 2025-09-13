import UIKit
import SnapKit
import Then

final class EmotionGridView: UIView {
    
    // MARK: - UI Components
    
    private let emotionButtons: [UIButton] = (0..<9).map { index in
        return UIButton(type: .system).then {
            $0.tag = index
            $0.contentVerticalAlignment = .fill
            $0.contentHorizontalAlignment = .fill
            $0.imageView?.contentMode = .scaleAspectFit
        }
    }
    
    // MARK: - Properties
    
    var onEmotionTapped: ((_ index: Int) -> Void)?
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func configure(with items: [EmotionItem]) {
        items.enumerated().forEach { index, item in
            guard index < emotionButtons.count else { return }
            let button = emotionButtons[index]
            button.setImage(item.image, for: .normal)
        }
    }
    
    /// ViewController의 지시에 따라 버튼들의 선택 상태(투명도)를 업데이트합니다.
    /// - Parameter selectedIndex: 선택된 버튼의 인덱스. `nil`이면 모두 선택 해제됩니다.
    func updateSelectionState(selectedIndex: Int?) {
        emotionButtons.forEach { button in
            button.alpha = (selectedIndex == nil || button.tag == selectedIndex) ? 1.0 : 0.3
        }
    }
    
    private func configureUI() {
        emotionButtons.forEach {
            $0.addTarget(
                self,
                action: #selector(emotionButtonTapped),
                for: .touchUpInside
            )
        }
        
        let rows = (0..<3).map { rowIndex -> UIStackView in
            let rowStack = UIStackView().then {
                $0.axis = .horizontal
                $0.distribution = .fillEqually
                $0.spacing = 20
            }
            
            (0..<3).forEach { colIndex in
                let buttonIndex = rowIndex * 3 + colIndex
                rowStack.addArrangedSubview(emotionButtons[buttonIndex])
            }
            return rowStack
        }
        
        let mainStack = UIStackView(arrangedSubviews: rows).then {
            $0.axis = .vertical
            $0.distribution = .fillEqually
            $0.spacing = 24
        }
        
        addSubview(mainStack)
        mainStack.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    @objc
    private func emotionButtonTapped(_ sender: UIButton) {
        onEmotionTapped?(sender.tag)
    }
}
