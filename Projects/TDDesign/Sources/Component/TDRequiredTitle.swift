import SnapKit
import UIKit

public final class TDRequiredTitle: UIView {
    private let label = TDLabel(
        toduckFont: .boldBody1,
        toduckColor: TDColor.Neutral.neutral800
    )
    
    private let requiredLabel = TDLabel(
        labelText: "*",
        toduckFont: .boldBody1,
        alignment: .left,
        toduckColor: TDColor.Primary.primary500
    )

    public init() {
        super.init(frame: .zero)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setTitleLabel(_ title: String) {
        label.setText(title)
        addSubview(label)
        
        label.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
        }
    }
    
    public func setRequiredLabel() {
        addSubview(requiredLabel)
        
        requiredLabel.snp.makeConstraints { make in
            make.leading.equalTo(label.snp.trailing).offset(4)
            make.centerY.equalTo(label)
        }
    }
}
