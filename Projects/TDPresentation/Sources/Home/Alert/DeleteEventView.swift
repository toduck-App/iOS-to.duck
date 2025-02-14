import UIKit
import TDDesign

final class DeleteEventView: BaseView {
    private let containerView = UIView().then {
        $0.backgroundColor = TDColor.baseWhite
    }
    
    private let deleteImageView = UIImageView().then {
        $0.image = TDImage.Alert.deleteEvent
        $0.contentMode = .scaleAspectFit
    }
    private let deleteLabel = TDLabel(
        labelText: "앗 !! 정말 삭제하시겠어요?",
        toduckFont: .boldHeader4,
        toduckColor: TDColor.Neutral.neutral800
    )
    private let descriptionLabel = TDLabel(
        labelText: "한번 삭제한 내용은 다시 복구할 수 없어요",
        toduckFont: .mediumHeader5,
        toduckColor: TDColor.Neutral.neutral800
    )
    
    /// 버튼 스택뷰
    private let buttonContainerHorizontalStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 12
    }
    let currentEventDeleteButton = TDBaseButton(
        title: "이 일정만 삭제",
        backgroundColor: TDColor.Semantic.error,
        foregroundColor: TDColor.baseWhite,
        radius: 12,
        font: TDFont.boldBody1.font
    )
    
    private let afterEventContainer = UIView()
    let afterEventDeleteButton = TDBaseButton(
        title: "이후 일정 모두 삭제",
        backgroundColor: TDColor.baseWhite,
        foregroundColor: TDColor.Neutral.neutral700,
        radius: 12,
        font: TDFont.boldBody1.font
    ).then {
        $0.layer.borderWidth = 1
        $0.layer.borderColor = TDColor.Neutral.neutral300.cgColor
    }
    private let dummyView = UIView()
    
    let cancelButton = TDBaseButton(
        title: "취소",
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
        containerView.addSubview(deleteImageView)
        containerView.addSubview(deleteLabel)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(buttonContainerHorizontalStackView)
        
        buttonContainerHorizontalStackView.addArrangedSubview(currentEventDeleteButton)
        buttonContainerHorizontalStackView.addArrangedSubview(afterEventContainer)
        buttonContainerHorizontalStackView.addArrangedSubview(cancelButton)
        
        afterEventContainer.addSubview(afterEventDeleteButton)
        afterEventContainer.addSubview(dummyView)
    }
    
    override func layout() {
        containerView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        deleteImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(96)
        }
        
        deleteLabel.snp.makeConstraints {
            $0.top.equalTo(deleteImageView.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(deleteLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        buttonContainerHorizontalStackView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().offset(-16)
        }
        
        cancelButton.snp.makeConstraints {
            $0.height.equalTo(52)
        }
        
        afterEventContainer.snp.makeConstraints {
            $0.height.equalTo(62)
        }
        afterEventDeleteButton.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(dummyView.snp.top)
        }
        dummyView.snp.makeConstraints {
            $0.height.equalTo(10)
        }
        
        currentEventDeleteButton.snp.makeConstraints {
            $0.height.equalTo(52)
        }
    }
    
    override func configure() {
        containerView.layer.cornerRadius = 28
    }
}
