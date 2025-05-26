import SnapKit
import TDDesign
import TDDomain
import UIKit

final class SocialRoutineView: UIView {
    var onTapperRoutine: (() -> Void)?
    
    private let categoryImageContainerView = UIView()
    private let categoryImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private var stackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .equalSpacing
        $0.spacing = 4
    }
    
    private var routineTitleLabel = TDLabel(toduckFont: .boldBody2, toduckColor: TDColor.Neutral.neutral800).then {
        $0.numberOfLines = 2
    }
    
    private var dateContainerView = UIView()
    
    private var timerImage = UIImageView().then {
        $0.image = TDImage.clockMedium.withRenderingMode(.alwaysOriginal).withTintColor(TDColor.Neutral.neutral600)
        $0.contentMode = .scaleAspectFit
    }
    
    private var routineContentLabel = TDLabel(toduckFont: .mediumCaption1, toduckColor: TDColor.Neutral.neutral600).then {
        $0.numberOfLines = 0
    }
    
    private var routineDateLabel = TDLabel(toduckFont: .mediumCaption1, toduckColor: TDColor.Neutral.neutral600)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    // TODO: Presentation Model
    convenience init(with routine: Routine) {
        self.init()
        setupUI()
        setupLayout()
        setupRecognizer()
        categoryImage.image = routine.categoryIcon
        categoryImageContainerView.backgroundColor = TDColor.reversedOpacityBackPair[ColorValue(color: routine.categoryColor)]
        routineTitleLabel.setText(routine.title)
        
        if let memo = routine.memo, !memo.isEmpty {
            stackView.addArrangedSubview(routineContentLabel)
            routineContentLabel.setText(memo)
        }
        
        if let routineDate = routine.time {
            dateContainerView.snp.makeConstraints { make in
                make.height.equalTo(18)
            }
            dateContainerView.addSubview(timerImage)
            dateContainerView.addSubview(routineDateLabel)
            timerImage.snp.makeConstraints { make in
                make.leading.equalToSuperview()
                make.centerY.equalToSuperview()
                make.size.equalTo(16)
            }
            routineDateLabel.snp.makeConstraints { make in
                make.leading.equalTo(timerImage.snp.trailing).offset(4)
                make.trailing.equalToSuperview()
                make.centerY.equalToSuperview()
            }
            stackView.addArrangedSubview(dateContainerView)
            routineDateLabel.setText(routineDate)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
}

// MARK: Layout

private extension SocialRoutineView {
    func setupUI() {
        backgroundColor = .white
        layer.borderColor = TDColor.Neutral.neutral300.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 16
        clipsToBounds = true
        
        categoryImageContainerView.layer.cornerRadius = 18
    }
    
    func setupLayout() {
        addSubview(categoryImageContainerView)
        categoryImageContainerView.addSubview(categoryImage)
        addSubview(stackView)
        
        stackView.addArrangedSubview(routineTitleLabel)
        
        categoryImageContainerView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(36)
        }
        
        categoryImage.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        
        stackView.snp.makeConstraints { make in
            make.leading.equalTo(categoryImageContainerView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(16)
        }
    }
    
    func setupRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapRoutine))
        addGestureRecognizer(tapGesture)
    }
}

// MARK: Action

extension SocialRoutineView {
    @objc private func didTapRoutine() {
        onTapperRoutine?()
    }
}
