import UIKit
import TDDesign

final class HideUserView: UIView {
    let lockImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = TDImage.Lock.profile
    }
    
    let titleLabel = TDLabel(labelText: "비공개 설정된 유저의 글이에요", toduckFont: .boldBody1, toduckColor: TDColor.Neutral.neutral800)
    
    let descriptionLabel = TDLabel(labelText: "공개 설정된 유저의 글만 읽을 수 있어요",toduckFont: .boldBody3, toduckColor: TDColor.Neutral.neutral500)
    
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(lockImageView)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        
        lockImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(96)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(lockImageView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.centerX.equalToSuperview()
        }
    }
}
