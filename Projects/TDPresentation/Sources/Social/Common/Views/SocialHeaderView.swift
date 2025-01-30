import Kingfisher
import SnapKit
import TDDesign
import UIKit

protocol SocialHeaderViewDelegate: AnyObject {
    func didTapNickname(_ view: UIView)
    func didTapReport(_ view: UIView)
    func didTapBlock(_ view: UIView)
}

final class SocialHeaderView: UIView {
    weak var delegate: SocialHeaderViewDelegate?

    private var titleBagde = TDBadge(badgeTitle: "", backgroundColor: TDColor.Primary.primary25, foregroundColor: TDColor.Primary.primary500)
    
    private var nicknameLabel = TDLabel(toduckFont: .mediumBody2, toduckColor: TDColor.Neutral.neutral700)
    
    private var dateLabel = TDLabel(toduckFont: .regularBody2, toduckColor: TDColor.Neutral.neutral500)
    
    private var dotIconView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = TDImage.Dot.vertical2Small
    }
    
    private(set) lazy var dropDownHoverView = TDDropdownHoverView(
        anchorView: dotIconView,
        layout: .trailing,
        width: 110
    ).then{
        $0.dataSource = SocialFeedMoreType.allCases.map { $0.dropdownItem }
        $0.delegate = self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupRecognizer()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupRecognizer()
    }
    
    func configure(titleBadge: String, nickname: String, date: Date) {
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
        [titleBagde, nicknameLabel, dateLabel, dropDownHoverView].forEach {
            addSubview($0)
        }
    }
    
    func setupConstraints() {
        titleBagde.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(titleBagde)
            make.leading.equalTo(titleBagde.snp.trailing).offset(10)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(titleBagde)
            make.leading.equalTo(nicknameLabel.snp.trailing).offset(10)
        }
        
        dotIconView.snp.makeConstraints { make in
            make.centerY.equalTo(titleBagde)
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
        let type = SocialFeedMoreType.allCases[indexPath.row]
        switch type {
        case .report:
            delegate?.didTapReport(self)
        case .block:
            delegate?.didTapBlock(self)
        }
    }
    
    @objc private func didTapNickname() {
        delegate?.didTapNickname(self)
    }
}
