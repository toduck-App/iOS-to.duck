import SnapKit
import TDDesign
import Then
import UIKit

protocol SocialRoutineInputDelegate: AnyObject {
    func didTapRoutineInputView(_ view: SocialRoutineInputView?)
}

final class SocialRoutineInputView: UIView {
    // MARK: - Properties

    weak var delegate: SocialRoutineInputDelegate?

    private let title = TDRequiredTitle().then {
        $0.setTitleLabel("루틴 공유하기")
    }

    private let routineSelectView = UIView().then {
        $0.layer.cornerRadius = 8
        $0.layer.borderColor = TDColor.Neutral.neutral300.cgColor
        $0.layer.borderWidth = 1
    }
    
    private let routineSelectLabel = TDLabel(
        labelText: "공유할 루틴을 선택해주세요",
        toduckFont: .regularBody2,
        toduckColor: TDColor.Neutral.neutral800
    ).then {
        $0.numberOfLines = 1
    }
    
    private let downArrowImageView = UIImageView().then {
        $0.image = TDImage.downMedium
    }
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
        setActions()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setLayout()
        setActions()
    }
    
    // MARK: - Public Method
    
    public func setRoutine(string: String) {
        routineSelectLabel.setText(string)
    }
}

extension SocialRoutineInputView {
    // MARK: - Private Methods

    private func setLayout() {
        addSubviews()
        setConstraints()
    }
    
    private func addSubviews() {
        addSubview(title)
        addSubview(routineSelectView)
        routineSelectView.addSubview(routineSelectLabel)
        routineSelectView.addSubview(downArrowImageView)
    }
    
    private func setConstraints() {
        title.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        routineSelectView.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(14)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(48)
        }
        
        routineSelectLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalTo(downArrowImageView.snp.leading)
            make.centerY.equalToSuperview()
        }
        
        downArrowImageView.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
    }
    
    private func setActions() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapRoutineSelectView))
        routineSelectView.isUserInteractionEnabled = true
        routineSelectView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func didTapRoutineSelectView() {
        delegate?.didTapRoutineInputView(self)
    }
}
