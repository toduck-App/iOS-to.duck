import Kingfisher
import SnapKit
import TDCore
import TDDesign
import UIKit

final class SocialHeaderView: UIView {
    var onNicknameTapped: (() -> Void)?
    var onReportTapped: (() -> Void)?
    var onBlockTapped: (() -> Void)?
    var onEditTapped: (() -> Void)?
    var onDeleteTapped: (() -> Void)?
    
    private var isMyPost: Bool = false
    private var isComment: Bool = false
    
    private var titleBagde = TDBadge(badgeTitle: "", backgroundColor: TDColor.Primary.primary25, foregroundColor: TDColor.Primary.primary500).then {
        $0.isHidden = true // MARK: 아직 미구현 상태
    }
    
    private var nicknameLabel = TDLabel(toduckFont: .mediumBody2, toduckColor: TDColor.Neutral.neutral700)
    
    private var dateLabel = TDLabel(toduckFont: .regularCaption1, toduckColor: TDColor.Neutral.neutral500)
    
    private var dotIconView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = TDImage.Dot.vertical2Small
    }
    
    private(set) lazy var dropDownHoverView = TDDropdownHoverView(
        anchorView: dotIconView,
        layout: .trailing,
        width: 110
    ).then {
        $0.delegate = self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupRecognizer()
    }
    
    convenience init(style: SocialPostStyle, isComment: Bool = false) {
        self.init(frame: .zero)
        switch style {
        case .list:
            break
        case .detail:
            dotIconView.isHidden = true
            dropDownHoverView.isHidden = true
        }
        self.isComment = isComment
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupRecognizer()
    }
    
    func configure(titleBadge: String, nickname: String, date: Date, isMyPost: Bool) {
        self.isMyPost = isMyPost
        if isMyPost {
            if isComment {
                dropDownHoverView.dataSource = [SocialFeedMoreType.delete.dropdownItem]
            } else {
                dropDownHoverView.dataSource = [SocialFeedMoreType.edit.dropdownItem, SocialFeedMoreType.delete.dropdownItem]
            }
        } else {
            dropDownHoverView.dataSource = [SocialFeedMoreType.report.dropdownItem, SocialFeedMoreType.block.dropdownItem]
        }
        titleBagde.setTitle(titleBadge)
        nicknameLabel.setText(nickname)
        dateLabel.setText(date.convertRelativeTime())
    }
}

// MARK: Layout

private extension SocialHeaderView {
    func setupUI() {
        setupLayout()
        setupConstraints()
    }
    
    func setupLayout() {
//        addSubview(titleBagde)
        addSubview(nicknameLabel)
        addSubview(dateLabel)
        addSubview(dropDownHoverView)
    }
    
    func setupConstraints() {
        nicknameLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.height.equalTo(21)
        }
//        
//        titleBagde.snp.makeConstraints { make in
//            make.centerY.equalTo(nicknameLabel)
//            make.leading.equalTo(nicknameLabel.snp.trailing).offset(10)
//        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(2)
            make.leading.equalTo(nicknameLabel.snp.leading)
            make.height.equalTo(12)
        }
        
        dotIconView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(self)
            make.width.height.equalTo(24)
        }
    }
    
    func setupRecognizer() {
        let nicknameTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapNickname))
        nicknameLabel.isUserInteractionEnabled = true
        nicknameLabel.addGestureRecognizer(nicknameTapGesture)
    }
}

// MARK: Action

extension SocialHeaderView: TDDropDownDelegate {
    func dropDown(_ dropDownView: TDDesign.TDDropdownHoverView, didSelectRowAt indexPath: IndexPath) {
        if isMyPost {
            if isComment {
                if indexPath.row == 0 {
                    onDeleteTapped?()
                }
            } else {
                if indexPath.row == 0 {
                    onEditTapped?()
                } else {
                    onDeleteTapped?()
                }
            }
        } else {
            if indexPath.row == 0 {
                onReportTapped?()
            } else {
                onBlockTapped?()
            }
        }
    }
    
    @objc private func didTapNickname() {
        onNicknameTapped?()
    }
}
