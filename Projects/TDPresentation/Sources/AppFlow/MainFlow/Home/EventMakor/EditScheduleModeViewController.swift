import UIKit
import SnapKit
import Then
import TDDesign

protocol EditScheduleModeDelegate: AnyObject {
    func didTapTodayScheduleApply()
    func didTapAllScheduleApply()
}

final class EditScheduleModeViewController: BaseViewController<BaseView> {
    private let titleLabel = TDLabel(
        labelText: "일정 수정",
        toduckFont: TDFont.boldHeader4,
        alignment: .center,
        toduckColor: TDColor.Neutral.neutral800
    )
    
    private let labelVerticalStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 12
        $0.alignment = .fill
    }
    private let todayScheduleApplyContainerView = UIView()
    private let todayScheduleApplyLabel = TDLabel(
        labelText: "오늘 일정에 적용",
        toduckFont: TDFont.mediumHeader5,
        toduckColor: TDColor.Neutral.neutral600
    )
    private let allScheduleApplyContainerView = UIView()
    private let allScheduleApplyLabel = TDLabel(
        labelText: "모든 일정에 적용",
        toduckFont: TDFont.mediumHeader5,
        toduckColor: TDColor.Neutral.neutral600
    )
    
    weak var delegate: EditScheduleModeDelegate?
    
    private let cancelButton = TDBaseButton(
        title: "취소",
        backgroundColor: TDColor.baseWhite,
        foregroundColor: TDColor.Neutral.neutral700,
        radius: 12,
        font: TDFont.boldHeader3.font
    ).then {
        $0.layer.borderWidth = 1
        $0.layer.borderColor = TDColor.Neutral.neutral300.cgColor
    }
    
    override func addView() {
        view.addSubview(titleLabel)
        view.addSubview(labelVerticalStackView)
        labelVerticalStackView.addArrangedSubview(todayScheduleApplyContainerView)
        labelVerticalStackView.addArrangedSubview(allScheduleApplyContainerView)
        todayScheduleApplyContainerView.addSubview(todayScheduleApplyLabel)
        allScheduleApplyContainerView.addSubview(allScheduleApplyLabel)
        view.addSubview(cancelButton)
    }
    
    override func layout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.centerX.equalToSuperview()
        }
        
        labelVerticalStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        todayScheduleApplyContainerView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(52)
        }
        todayScheduleApplyLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
        }
        
        allScheduleApplyContainerView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(52)
        }
        allScheduleApplyLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
        }
        
        cancelButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.height.equalTo(56)
        }
    }
    
    override func configure() {
        view.backgroundColor = .white
        todayScheduleApplyContainerView.layer.cornerRadius = 12
        allScheduleApplyContainerView.layer.cornerRadius = 12
        setupGestureRecognizers()
    }

    private func setupGestureRecognizers() {
        let todayTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleTodayTap(_:)))
        todayTapGesture.minimumPressDuration = 0
        todayScheduleApplyContainerView.addGestureRecognizer(todayTapGesture)

        let allTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleAllTap(_:)))
        allTapGesture.minimumPressDuration = 0
        allScheduleApplyContainerView.addGestureRecognizer(allTapGesture)
    }
    
    @objc private func handleTodayTap(_ gesture: UILongPressGestureRecognizer) {
        handleTapGesture(
            gesture,
            containerView: todayScheduleApplyContainerView,
            label: todayScheduleApplyLabel,
            action: { [weak self] in
                self?.delegate?.didTapTodayScheduleApply()
                self?.dismiss(animated: true)
            }
        )
    }

    @objc private func handleAllTap(_ gesture: UILongPressGestureRecognizer) {
        handleTapGesture(
            gesture,
            containerView: allScheduleApplyContainerView,
            label: allScheduleApplyLabel,
            action: { [weak self] in
                self?.delegate?.didTapAllScheduleApply()
                self?.dismiss(animated: true)
            }
        )
    }

    private func handleTapGesture(
        _ gesture: UILongPressGestureRecognizer,
        containerView: UIView,
        label: TDLabel,
        action: () -> Void
    ) {
        switch gesture.state {
        case .began, .changed:
            containerView.backgroundColor = TDColor.Primary.primary50
            label.setColor(TDColor.Primary.primary500)
        case .ended:
            containerView.backgroundColor = .clear
            label.setColor(TDColor.Neutral.neutral600)
            action()
        case .cancelled, .failed:
            containerView.backgroundColor = .clear
            label.setColor(TDColor.Neutral.neutral600)
        default:
            break
        }
    }
}
