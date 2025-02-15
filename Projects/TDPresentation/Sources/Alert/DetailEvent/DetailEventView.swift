import SnapKit
import TDDesign
import UIKit

final class DetailEventView: BaseView {
    private let containerView = UIView().then {
        $0.backgroundColor = TDColor.baseWhite
    }
    
    /// 네비게이션
    private let navigationContainerView = UIView()
    let cancelButton = TDBaseButton(
        image: TDImage.X.x1Medium,
        backgroundColor: TDColor.baseWhite
    )
    let titleLabel = TDLabel(
        toduckFont: TDFont.boldHeader4,
        toduckColor: TDColor.Neutral.neutral800
    )
    private let alarmImageView = UIImageView().then {
        $0.image = TDImage.Bell.ringingMedium
        $0.contentMode = .scaleAspectFit
    }
    
    /// 일정 정보
    let dateLabel = TDLabel(
        toduckFont: TDFont.mediumBody2,
        toduckColor: TDColor.Neutral.neutral600
    )
    let categoryImageView = TDCategoryCircleView()
    let eventTitleLabel = TDLabel(
        toduckFont: TDFont.mediumBody2,
        toduckColor: TDColor.Neutral.neutral800
    )
    
    let timeDetailView = TDFormMoveView(type: .time, isRequired: false, isReadOnlyMode: true)
    let repeatDetailView = TDFormMoveView(type: .cycle, isRequired: false, isReadOnlyMode: true)
    let locationDetailView = TDFormMoveView(type: .location, isRequired: false, isReadOnlyMode: true)
    
    private let buttonContainerHorizontalStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.distribution = .fillEqually
    }
    let deleteButton = TDBaseButton(
        title: "삭제",
        backgroundColor: TDColor.baseWhite,
        foregroundColor: TDColor.Neutral.neutral700,
        radius: 12,
        font: TDFont.boldBody1.font
    ).then {
        $0.layer.borderWidth = 1
        $0.layer.borderColor = TDColor.Neutral.neutral300.cgColor
    }
    
    let delayToTomorrowButton = TDBaseButton(
        title: "내일로 미루기",
        backgroundColor: TDColor.baseWhite,
        foregroundColor: TDColor.Neutral.neutral700,
        radius: 12,
        font: TDFont.boldBody1.font
    ).then {
        $0.layer.borderWidth = 1
        $0.layer.borderColor = TDColor.Neutral.neutral300.cgColor
    }
    
    override func addview() {
        addSubview(containerView)
        containerView.addSubview(navigationContainerView)
        navigationContainerView.addSubview(cancelButton)
        navigationContainerView.addSubview(titleLabel)
        navigationContainerView.addSubview(alarmImageView)
        
        containerView.addSubview(dateLabel)
        containerView.addSubview(categoryImageView)
        containerView.addSubview(eventTitleLabel)
        
        containerView.addSubview(timeDetailView)
        containerView.addSubview(repeatDetailView)
        containerView.addSubview(locationDetailView)
        
        containerView.addSubview(buttonContainerHorizontalStackView)
        buttonContainerHorizontalStackView.addArrangedSubview(deleteButton)
        buttonContainerHorizontalStackView.addArrangedSubview(delayToTomorrowButton)
    }
    
    override func layout() {
        containerView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        navigationContainerView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        cancelButton.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.width.height.equalTo(24)
        }
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(cancelButton)
            $0.width.equalTo(100)
        }
        alarmImageView.snp.makeConstraints {
            $0.centerY.equalTo(cancelButton)
            $0.trailing.equalToSuperview()
            $0.width.height.equalTo(24)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(navigationContainerView.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(22)
        }
        categoryImageView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(10)
            $0.leading.equalTo(dateLabel)
            $0.width.height.equalTo(48)
        }
        eventTitleLabel.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(10)
            $0.leading.equalTo(categoryImageView.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(18)
        }
        
        timeDetailView.snp.makeConstraints {
            $0.top.equalTo(categoryImageView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
        }
        repeatDetailView.snp.makeConstraints {
            $0.top.equalTo(timeDetailView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
        }
        locationDetailView.snp.makeConstraints {
            $0.top.equalTo(repeatDetailView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
        }
        
        buttonContainerHorizontalStackView.snp.makeConstraints {
            $0.top.equalTo(locationDetailView.snp.bottom).offset(12)
            $0.leading.trailing.bottom.equalToSuperview().inset(16)
            $0.height.equalTo(52)
        }
    }
    
    override func configure() {
        containerView.layer.cornerRadius = 28
    }
}
