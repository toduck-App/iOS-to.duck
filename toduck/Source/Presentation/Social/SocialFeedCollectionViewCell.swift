//
//  SocialFeedCollectionViewCell.swift
//  toduck
//
//  Created by 승재 on 8/3/24.
//
import SnapKit
import Then
import Foundation
import Kingfisher
import UIKit

class SocialFeedCollectionViewCell: UICollectionViewCell {
    private let containerView = UIView()
    
    private var verticalStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 14
        $0.distribution = .fill
    }
    private var headerStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.spacing = 10
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private var headerLeftStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.spacing = 10
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    
    private var headerRightStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.spacing = 10
        $0.distribution = .equalSpacing
    }
    
    private var bodyStackView = UIStackView().then{
        $0.axis = .vertical
        $0.spacing = 10
        $0.alignment = .fill
        $0.distribution = .fill
    }
    
    private var footerView = UIView()
    
    lazy var dotIconView = UIImageView().then {
        $0.tintColor = TDColor.Neutral.neutral500
        $0.contentMode = .scaleAspectFit
        $0.image = TDImage.Dot.horizontalMedium
    }
    
    
    
    lazy var likeIconView = UIImageView().then {
        $0.tintColor = TDColor.Neutral.neutral500
        $0.contentMode = .scaleAspectFit
        $0.image = TDImage.likeMedium
    }
    
    lazy var commentIconView = UIImageView().then {
        $0.tintColor = TDColor.Neutral.neutral500
        $0.contentMode = .scaleAspectFit
        $0.image = TDImage.commentMedium
    }
    
    lazy var shareIconView = UIImageView().then {
        $0.tintColor = TDColor.Neutral.neutral500
        $0.contentMode = .scaleAspectFit
        $0.image = TDImage.Repeat.arrowMedium
    }
    
    lazy var avatarView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 20
        $0.backgroundColor = TDColor.Neutral.neutral100
    }
    
    private var titleLabel = TDLabel(labelText:  "", toduckFont: .mediumCaption2, toduckColor: TDColor.Primary.primary500).then{
        $0.backgroundColor = TDColor.Primary.primary50
    }
    private var nicknameLabel = TDLabel(toduckFont: .mediumBody2, toduckColor: TDColor.Neutral.neutral700)
    private var dateLabel = TDLabel(toduckFont: .regularBody2, toduckColor: TDColor.Neutral.neutral500)
    
    private var contentLabel = TDLabel(toduckFont: .mediumBody2, toduckColor: TDColor.Neutral.neutral800).then {
        $0.numberOfLines = 0
    }
    
    private var likeLabel = TDLabel(toduckFont: .regularBody2, toduckColor: TDColor.Neutral.neutral600)
    private var commentLabel = TDLabel(toduckFont: .regularBody2, toduckColor: TDColor.Neutral.neutral600)
    private var shareLabel = TDLabel(toduckFont: .regularBody2, toduckColor: TDColor.Neutral.neutral600)
    
    private var routineView = UIView().then{
        $0.backgroundColor = TDColor.Neutral.neutral100
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    
    // Semibold가 없어요
    private var routineTitleLabel = TDLabel(toduckFont: .boldBody1, toduckColor: TDColor.Neutral.neutral800).then {
        $0.numberOfLines = 0
    }
    
    private var routineContentLabel = TDLabel(toduckFont: .regularBody2, toduckColor: TDColor.Neutral.neutral800).then{
        $0.numberOfLines = 0
    }
    
    private var routineDateLabel = TDLabel(toduckFont: .mediumBody2, toduckColor: TDColor.Neutral.neutral500)
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    func configure(with item: Post) {
        titleLabel.setText(item.user.title)
        nicknameLabel.setText(item.user.name)
        dateLabel.setText(Date.relatveTimeFromDate(item.timestamp))
        contentLabel.setText(item.contentText)
        likeLabel.setText("\(item.likeCount ?? 0)")
        commentLabel.setText("\(item.commentCount ?? 0)")
        
        guard let url = URL(string: item.user.icon) else { return }
        // lloadImage 수정 필요
        loadImages(url: url)
        
        if let shareCount = item.shareCount, shareCount > 0 {
            shareLabel.setText("\(shareCount)")
        } else {
            shareIconView.isHidden = true
            shareLabel.isHidden = true
        }
        
        if let routine = item.routine {
            bodyStackView.addArrangedSubview(routineView)
            routineTitleLabel.setText(routine.title)
            routineContentLabel.setText(routine.memo ?? "sdf")
            if let routineDate = routine.dateAndTime {
                routineDateLabel.setText(Date.stringFromDate(routineDate, formatType: .time12HourEnglish))
            }
            setupRoutineView()
        }
    }
}
private extension SocialFeedCollectionViewCell {
    
    func setupUI() {
        setupLayout()
    }
    
    func loadImages(url: URL) {
        avatarView.image = TDImage.Profile.medium
    }
    
    func setupLayout() {
        addSubview(containerView)
        [titleLabel,nicknameLabel,dateLabel].forEach{
            headerLeftStackView.addArrangedSubview($0)
        }
        
        headerRightStackView.addArrangedSubview(dotIconView)
        
        [headerLeftStackView,headerRightStackView].forEach{
            headerStackView.addArrangedSubview($0)
        }
        
        bodyStackView.addArrangedSubview(contentLabel)
        
        [avatarView, verticalStackView].forEach{
            containerView.addSubview($0)
        }
        
        [headerStackView, bodyStackView, footerView].forEach{
            verticalStackView.addArrangedSubview($0)
        }
        
        [likeIconView, likeLabel, commentIconView, commentLabel, shareIconView, shareLabel].forEach{
            footerView.addSubview($0)
        }
        
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-20)
            make.leading.trailing.equalToSuperview()
        }
        
        
        avatarView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.size.equalTo(36)
        }
        
        [titleLabel, nicknameLabel, dateLabel, dotIconView, likeIconView,likeLabel,commentIconView,commentLabel,shareIconView,shareLabel].forEach {
            $0.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
            }
        }
        
        verticalStackView.snp.makeConstraints { make in
            make.leading.equalTo(avatarView.snp.trailing).offset(10)
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        headerStackView.snp.makeConstraints { make in
            make.height.equalTo(24)
        }
        footerView.snp.makeConstraints { make in
            make.height.equalTo(24)
        }
        
        dotIconView.snp.makeConstraints { make in
            make.size.equalTo(24)
        }
        likeIconView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.size.equalTo(24)
        }
        
        likeLabel.snp.makeConstraints { make in
            make.leading.equalTo(likeIconView.snp.trailing).offset(2)
            make.centerY.equalTo(likeIconView)
        }
        
        commentIconView.snp.makeConstraints { make in
            make.leading.equalTo(likeLabel.snp.trailing).offset(10)
            make.size.equalTo(24)
        }
        
        commentLabel.snp.makeConstraints { make in
            make.leading.equalTo(commentIconView.snp.trailing).offset(2)
            make.centerY.equalTo(commentIconView)
        }
        
        shareIconView.snp.makeConstraints { make in
            make.leading.equalTo(commentLabel.snp.trailing).offset(10)
            make.size.equalTo(24)
        }
        
        shareLabel.snp.makeConstraints { make in
            make.leading.equalTo(shareIconView.snp.trailing).offset(2)
            make.centerY.equalTo(shareIconView)
        }
        
    }
    
    
    func setupRoutineView() {
        
        bodyStackView.addArrangedSubview(routineView)
        routineView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(114)
        }
        routineView.addSubview(routineTitleLabel)
        routineView.addSubview(routineContentLabel)
        routineView.addSubview(routineDateLabel)
        routineTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        routineContentLabel.snp.makeConstraints { make in
            make.top.equalTo(routineTitleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalTo(routineTitleLabel)
            
        }
        
        routineDateLabel.snp.makeConstraints { make in
            make.top.equalTo(routineContentLabel.snp.bottom).offset(18)
            make.leading.trailing.equalTo(routineTitleLabel)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
}
