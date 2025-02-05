import SnapKit
import TDDesign
import TDDomain
import UIKit

final class SocialRoutineView: UIView {
    var onTapperRoutine: (() -> Void)?
    
    private let categoryImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private var routineTitleLabel = TDLabel(toduckFont: .boldBody1, toduckColor: TDColor.Neutral.neutral800).then {
        $0.numberOfLines = 2
    }
    
    private var routineContentLabel = TDLabel(toduckFont: .regularBody2, toduckColor: TDColor.Neutral.neutral800).then {
        $0.numberOfLines = 0
    }
    
    private var routineDateLabel = TDLabel(toduckFont: .mediumBody2, toduckColor: TDColor.Neutral.neutral500)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    // TODO: Presentation Model
    convenience init(with routine: Routine) {
        self.init()
        categoryImage.image = routine.categoryIcon
        routineTitleLabel.setText(routine.title)
        routineContentLabel.setText(routine.memo ?? "")
        if let routineDate = routine.date {
            routineDateLabel.setText(routineDate.convertToString(formatType: .time12HourEnglish))
        }
        setupUI()
        setupLayout()
        setupRecognizer()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
}

// MARK: Layout

private extension SocialRoutineView {
    func setupUI() {
        backgroundColor = TDColor.Neutral.neutral100
        layer.cornerRadius = 8
        clipsToBounds = true
    }
    
    func setupLayout() {
        addSubview(categoryImage)
        addSubview(routineTitleLabel)
        addSubview(routineContentLabel)
        addSubview(routineDateLabel)
        
        categoryImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.leading.equalToSuperview().inset(20)
            make.size.equalTo(24)
        }
        
        routineTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.leading.equalTo(categoryImage.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(24)
        }
        
        routineContentLabel.snp.makeConstraints { make in
            make.top.equalTo(routineTitleLabel.snp.bottom).offset(10)
            make.leading.equalTo(categoryImage)
            make.trailing.equalTo(routineTitleLabel)
        }
        
        routineDateLabel.snp.makeConstraints { make in
            make.top.equalTo(routineContentLabel.snp.bottom).offset(18)
            make.trailing.leading.equalTo(routineContentLabel)
            make.bottom.equalToSuperview().inset(14)
            make.height.equalTo(24)
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
