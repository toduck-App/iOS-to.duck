import SnapKit
import TDDesign
import UIKit

final class DetailTodoView: BaseView {
    private let containerView = UIView().then {
        $0.backgroundColor = TDColor.baseWhite
    }
    
    /// 네비게이션
    private let navigationContainerView = UIView()
    let closeButton = TDBaseButton(
        image: TDImage.X.x1Medium,
        backgroundColor: TDColor.baseWhite,
        foregroundColor: TDColor.Neutral.neutral700
    )
    let titleLabel = TDLabel(
        toduckFont: TDFont.boldHeader4,
        toduckColor: TDColor.Neutral.neutral800
    )
    let alarmImageView = UIImageView().then {
        $0.image = TDImage.Bell.ringingMedium
        $0.contentMode = .scaleAspectFit
    }
    
    /// 일정 정보
    let dateLabel = TDLabel(
        toduckFont: TDFont.mediumBody2,
        toduckColor: TDColor.Neutral.neutral600
    )
    
    let editAreaView = UIView()
    let categoryImageView = TDCategoryCircleView()
    let eventTitleContainerView = UIView()
    let eventTitleLabel = TDLabel(
        toduckFont: TDFont.mediumBody2,
        toduckColor: TDColor.Neutral.neutral800
    )
    
    private let eventInfoVerticalStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = LayoutConstants.eventInfoSpacing
    }
    let timeDetailView = TDFormMoveView(type: .time, isRequired: false, isReadOnlyMode: true)
    let repeatDetailView = TDFormMoveView(type: .cycle, isRequired: false, isReadOnlyMode: true)
    let placeDetailView = TDFormMoveView(type: .place, isRequired: false, isReadOnlyMode: true)
    let lockDetailView = TDFormMoveView(type: .lock, isRequired: false, isReadOnlyMode: true)
    
    let memoHorizontalStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = LayoutConstants.memoHorizontalSpacing
    }
    let memoImageView = UIImageView().then {
        $0.image = TDImage.Memo.lineMedium
        $0.contentMode = .scaleAspectFit
    }
    let memoLabel = TDLabel(
        labelText: "메모",
        toduckFont: TDFont.mediumBody2,
        toduckColor: TDColor.Neutral.neutral800
    )
    let memoDescriptionLabel = TDLabel(
        labelText: "(최대 40자)",
        toduckFont: TDFont.mediumBody2,
        toduckColor: TDColor.Neutral.neutral600
    )
    
    let memoContentContainerView = UIView()
    let memoContentLabel = TDLabel(
        toduckFont: TDFont.mediumBody2,
        toduckColor: TDColor.Neutral.neutral800
    ).then {
        $0.numberOfLines = 0
    }
    
    private let buttonContainerHorizontalStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = LayoutConstants.buttonSpacing
        $0.distribution = .fillEqually
    }
    let deleteButton = TDBaseButton(
        title: "삭제",
        backgroundColor: TDColor.baseWhite,
        foregroundColor: TDColor.Neutral.neutral700,
        radius: LayoutConstants.buttonCornerRadius,
        font: TDFont.boldBody1.font
    ).then {
        $0.layer.borderWidth = 1
        $0.layer.borderColor = TDColor.Neutral.neutral300.cgColor
    }
    
    let delayToTomorrowButton = TDBaseButton(
        title: "내일로 미루기",
        backgroundColor: TDColor.baseWhite,
        foregroundColor: TDColor.Neutral.neutral700,
        radius: LayoutConstants.buttonCornerRadius,
        font: TDFont.boldBody1.font
    ).then {
        $0.layer.borderWidth = 1
        $0.layer.borderColor = TDColor.Neutral.neutral300.cgColor
    }
    
    override func addview() {
        addSubview(containerView)
        
        /// 네비게이션
        containerView.addSubview(navigationContainerView)
        navigationContainerView.addSubview(closeButton)
        navigationContainerView.addSubview(titleLabel)
        navigationContainerView.addSubview(alarmImageView)
        
        /// 일정 정보 (날짜, 카테고리, 제목)
        containerView.addSubview(dateLabel)
        containerView.addSubview(editAreaView)
        editAreaView.addSubview(categoryImageView)
        editAreaView.addSubview(eventTitleContainerView)
        eventTitleContainerView.addSubview(eventTitleLabel)
        
        /// 일정 내용 (시간, 반복, 장소)
        editAreaView.addSubview(eventInfoVerticalStackView)
        eventInfoVerticalStackView.addArrangedSubview(timeDetailView)
        eventInfoVerticalStackView.addArrangedSubview(repeatDetailView)
        eventInfoVerticalStackView.addArrangedSubview(placeDetailView)
        eventInfoVerticalStackView.addArrangedSubview(lockDetailView)
        
        /// 메모
        editAreaView.addSubview(memoHorizontalStackView)
        memoHorizontalStackView.addArrangedSubview(memoImageView)
        memoHorizontalStackView.addArrangedSubview(memoLabel)
        memoHorizontalStackView.addArrangedSubview(memoDescriptionLabel)
        editAreaView.addSubview(memoContentContainerView)
        memoContentContainerView.addSubview(memoContentLabel)
        
        /// 버튼
        containerView.addSubview(buttonContainerHorizontalStackView)
        buttonContainerHorizontalStackView.addArrangedSubview(deleteButton)
        buttonContainerHorizontalStackView.addArrangedSubview(delayToTomorrowButton)
    }
    
    override func layout() {
        containerView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(LayoutConstants.containerHorizontalInset)
        }
        
        navigationContainerView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(LayoutConstants.navigationTopOffset)
            $0.leading.trailing.equalToSuperview().inset(LayoutConstants.navigationHorizontalInset)
            $0.height.equalTo(LayoutConstants.navigationHeight)
        }
        closeButton.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.size.equalTo(LayoutConstants.cancelButtonSize)
        }
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(closeButton)
            $0.width.equalTo(LayoutConstants.titleLabelWidth)
        }
        alarmImageView.snp.makeConstraints {
            $0.centerY.equalTo(closeButton)
            $0.trailing.equalToSuperview()
            $0.size.equalTo(LayoutConstants.alarmImageSize)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(navigationContainerView.snp.bottom)
            $0.leading.equalToSuperview().inset(LayoutConstants.dateLeadingInset)
            $0.height.equalTo(20)
        }
        editAreaView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(LayoutConstants.categoryTopOffset)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.bottom.equalTo(buttonContainerHorizontalStackView.snp.top).offset(-12)
        }
        
        categoryImageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.size.equalTo(LayoutConstants.categorySize)
        }
        eventTitleContainerView.snp.makeConstraints {
            $0.leading.equalTo(categoryImageView.snp.trailing).offset(LayoutConstants.eventTitleLeadingOffset)
            $0.trailing.equalToSuperview()
            $0.centerY.equalTo(categoryImageView)
        }
        eventTitleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(LayoutConstants.eventTitleInsets)
        }
        
        eventInfoVerticalStackView.snp.makeConstraints {
            $0.top.equalTo(categoryImageView.snp.bottom).offset(LayoutConstants.eventInfoTopOffset)
            $0.leading.trailing.equalToSuperview()
        }
        
        memoHorizontalStackView.snp.makeConstraints {
            $0.top.equalTo(eventInfoVerticalStackView.snp.bottom).offset(LayoutConstants.memoStackTopOffset)
            $0.leading.equalToSuperview()
        }
        memoContentContainerView.snp.makeConstraints {
            $0.top.equalTo(memoHorizontalStackView.snp.bottom).offset(LayoutConstants.memoContentTopOffset)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        memoContentLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(LayoutConstants.memoContentInsets)
        }
        
        buttonContainerHorizontalStackView.snp.makeConstraints {
            $0.top.equalTo(editAreaView.snp.bottom).offset(LayoutConstants.buttonContainerTopOffset)
            $0.leading.trailing.bottom.equalToSuperview().inset(LayoutConstants.buttonContainerHorizontalInset)
            $0.height.equalTo(LayoutConstants.buttonContainerHeight)
        }
    }
    
    override func configure() {
        containerView.layer.cornerRadius = LayoutConstants.containerCornerRadius
        eventTitleContainerView.backgroundColor = TDColor.Neutral.neutral50
        eventTitleContainerView.layer.cornerRadius = LayoutConstants.eventTitleCornerRadius
        editAreaView.backgroundColor = .white
        memoContentContainerView.backgroundColor = TDColor.Neutral.neutral50
        memoContentContainerView.layer.cornerRadius = LayoutConstants.memoContentCornerRadius
    }
}

// MARK: - Layout Constants
extension DetailTodoView {
    private enum LayoutConstants {
        // Container
        static let containerHorizontalInset: CGFloat = 16
        static let containerCornerRadius: CGFloat = 28
        
        // Navigation
        static let navigationTopOffset: CGFloat = 24
        static let navigationHorizontalInset: CGFloat = 16
        static let navigationHeight: CGFloat = 40
        static let cancelButtonSize: CGFloat = 24
        static let titleLabelWidth: CGFloat = 100
        static let alarmImageSize: CGFloat = 24
        
        // Date Label
        static let dateLeadingInset: CGFloat = 16
        
        // Category
        static let categoryTopOffset: CGFloat = 10
        static let categorySize: CGFloat = 48
        
        // Event Title
        static let eventTitleLeadingOffset: CGFloat = 8
        static let eventTitleTrailingInset: CGFloat = 16
        static let eventTitleInsets: CGFloat = 16
        static let eventTitleCornerRadius: CGFloat = 12
        
        // Event Info
        static let eventInfoTopOffset: CGFloat = 24
        static let eventInfoLeadingInset: CGFloat = 16
        static let eventInfoTrailingInset: CGFloat = 18
        static let eventInfoSpacing: CGFloat = 22
        
        // Memo
        static let memoStackTopOffset: CGFloat = 22
        static let memoHorizontalSpacing: CGFloat = 8
        static let memoContentTopOffset: CGFloat = 8
        static let memoContentHorizontalInset: CGFloat = 16
        static let memoContentInsets: CGFloat = 16
        static let memoContentCornerRadius: CGFloat = 12
        
        // Buttons
        static let buttonContainerTopOffset: CGFloat = 20
        static let buttonContainerHorizontalInset: CGFloat = 16
        static let buttonContainerHeight: CGFloat = 52
        static let buttonSpacing: CGFloat = 8
        static let buttonCornerRadius: CGFloat = 12
    }
}
