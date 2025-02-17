import SnapKit
import UIKit

/// 필수 입력 항목을 나타내는 제목 레이블과 별표(*)를 표시하는 `TDRequiredTitle` 클래스입니다.
/// 주로 폼 입력 필드의 제목 옆에 필수 입력임을 표시할 때 사용됩니다.
public final class TDRequiredTitle: UIView {
    
    // MARK: - Properties
    
    /// 제목을 표시하는 레이블입니다.
    private let label = TDLabel(
        toduckFont: .boldBody1,
        toduckColor: TDColor.Neutral.neutral800
    )
    
    /// 필수 입력임을 나타내는 별표(*) 레이블입니다.
    private let requiredLabel = TDLabel(
        labelText: "*",
        toduckFont: .boldBody1,
        alignment: .left,
        toduckColor: TDColor.Primary.primary500
    )

    // MARK: - Initializers
    
    /// `TDRequiredTitle`의 기본 이니셜라이저입니다.
    /// 초기화 후 별도의 설정 없이 빈 뷰를 생성합니다.
    public init() {
        super.init(frame: .zero)
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Public Methods
    
    /// 제목 레이블의 텍스트 폰트를 설정합니다.
    /// - Parameter font: 폰트로 설정할 `UIFont` 객체.
    public func setTitleFont(_ font: TDFont) {
        label.setFont(font)
    }
    
    /// 제목 레이블의 텍스트를 설정하고 레이아웃을 구성합니다.
    ///
    /// - Parameter title: 제목으로 표시할 문자열.
    public func setTitleLabel(_ title: String) {
        label.setText(title)
        addSubview(label)
        
        label.snp.updateConstraints { make in
            make.height.equalTo(20)
            make.leading.top.bottom.equalToSuperview()
        }
    }
    
    /// 필수 입력을 나타내는 별표(*) 레이블을 추가하고 레이아웃을 구성합니다.
    /// 이 메서드는 `setTitleLabel(_:)` 호출 후에 사용해야 합니다.
    public func setRequiredLabel() {
        addSubview(requiredLabel)
        
        requiredLabel.snp.updateConstraints { make in
            make.leading.equalTo(label.snp.trailing).offset(4)
            make.height.equalTo(20)
            make.centerY.equalTo(label)
        }
    }
}
