import SnapKit
import Then
import UIKit

public enum TDFormButtonsViewType {
    case repeatDay
    case alarm
}

public final class TDFormButtonsView: UIView {
    // MARK: - UI Components
    private let containerVerticalStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.spacing = 12
    }
    
    private let titleHorizontalStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .center
    }
    private var titleImageView: UIImageView?
    private let titleLabel = TDLabel(toduckFont: .boldBody1)
    
    private let buttonHorizontalStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .fill
        $0.distribution = .fillEqually
    }
    private var buttons = [TDSelectableButton]()
    
    // MARK: - Properties
    private let type: TDFormButtonsViewType
    
    // MARK: - Initialize
    public init(type: TDFormButtonsViewType) {
        self.type = type
        super.init(frame: .zero)
        setupView()
        setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupView() {
        configureTitle()
        configureButtons()
    }
    
    private func configureTitle() {
        switch type {
        case .repeatDay:
            titleImageView = UIImageView(image: TDImage.Repeat.cycleMedium)
            titleLabel.setText("반복")
        case .alarm:
            titleImageView = UIImageView(image: TDImage.Bell.ringingMedium)
            titleLabel.setText("알람")
        }
        
        titleImageView?.contentMode = .scaleAspectFit
    }
    
    private func configureButtons() {
        let buttonTitles: [String] = {
            switch type {
            case .repeatDay:
                return ["월", "화", "수", "목", "금", "토", "일"]
            case .alarm:
                return ["10분 전", "30분 전", "1시간 전"]
            }
        }()
        
        buttons = buttonTitles.map {
            TDSelectableButton(
                title: $0,
                backgroundColor: TDColor.Neutral.neutral50,
                foregroundColor: TDColor.Neutral.neutral800,
                font: TDFont.mediumBody2.font
            )
        }
    }
    
    private func setupLayout() {
        addSubview(containerVerticalStackView)
        containerVerticalStackView.addArrangedSubview(titleHorizontalStackView)
        containerVerticalStackView.addArrangedSubview(buttonHorizontalStackView)
        
        // 전체 스택 뷰
        containerVerticalStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        // 제목 스택 뷰
        titleHorizontalStackView.snp.makeConstraints {
            $0.height.equalTo(24)
        }
        
        // 버튼 스택 뷰
        buttonHorizontalStackView.snp.makeConstraints {
            $0.height.equalTo(32)
            $0.leading.trailing.equalToSuperview()
        }
        
        // 제목 이미지와 라벨
        if let titleImageView = titleImageView {
            titleHorizontalStackView.addArrangedSubview(titleImageView)
            titleImageView.snp.makeConstraints {
                $0.size.equalTo(20)
            }
        }
        titleHorizontalStackView.addArrangedSubview(titleLabel)
        
        // 버튼 추가
        buttons.forEach { buttonHorizontalStackView.addArrangedSubview($0) }
    }
}
