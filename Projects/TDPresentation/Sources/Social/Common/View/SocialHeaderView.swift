import Kingfisher
import SnapKit
import TDDesign
import UIKit

protocol SocialHeaderViewDelegate: AnyObject {
    func didTapNickname(_ view: UIStackView)
    func didTapMore(_ view: UIStackView)
}

final class SocialHeaderView: UIStackView {
    weak var delegate: SocialHeaderViewDelegate?
    
    private var headerLeftStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .leading
        $0.spacing = 10
        $0.distribution = .equalSpacing
    }
    
    private var headerRightStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.spacing = 10
        $0.distribution = .equalSpacing
    }

    private var titleBagde = TDBadge(badgeTitle: "", backgroundColor: TDColor.Primary.primary25, foregroundColor: TDColor.Primary.primary500)
    
    private var nicknameLabel = TDLabel(toduckFont: .mediumBody2, toduckColor: TDColor.Neutral.neutral700)
    
    private var dateLabel = TDLabel(toduckFont: .regularBody2, toduckColor: TDColor.Neutral.neutral500)
    
    private var dotIconView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = TDImage.Dot.vertical2Small
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
        setupRecognizer()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupLayout()
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
        axis = .horizontal
        alignment = .leading
        distribution = .equalSpacing
        spacing = 10
    }
    
    func setupLayout() {
        [headerLeftStackView, headerRightStackView].forEach {
            addArrangedSubview($0)
        }
        
        [titleBagde, nicknameLabel, dateLabel].forEach {
            headerLeftStackView.addArrangedSubview($0)
        }

        headerRightStackView.addArrangedSubview(dotIconView)
    }
    
    func setupConstraints() {
        snp.makeConstraints { make in
            make.height.equalTo(24)
            make.leading.trailing.equalToSuperview()
        }
        dotIconView.snp.makeConstraints { make in
            make.size.equalTo(24)
        }
    }
    
    func setupRecognizer() {
        let nicknameTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapNickname))
        nicknameLabel.isUserInteractionEnabled = true
        nicknameLabel.addGestureRecognizer(nicknameTapGesture)
        
        let dotIconTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapMore))
        dotIconView.isUserInteractionEnabled = true
        dotIconView.addGestureRecognizer(dotIconTapGesture)
    }
}

// MARK: Action

extension SocialHeaderView {
    @objc private func didTapNickname() {
        delegate?.didTapNickname(self)
    }
    
    @objc private func didTapMore() {
        delegate?.didTapMore(self)
    }
}
