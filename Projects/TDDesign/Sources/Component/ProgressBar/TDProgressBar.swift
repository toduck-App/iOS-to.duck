import Foundation
import UIKit

/// 사용자 정의 프로그레스 바를 나타내는 `TDProgressBar` 클래스입니다.
/// `UIProgressView`를 상속하며, 기본 색상과 높이를 설정합니다.
public final class TDProgressBar: UIProgressView {
    
    // MARK: - Initializers
    
    /// `TDProgressBar`의 기본 이니셜라이저입니다.
    ///
    /// - Parameter frame: 뷰의 프레임.
    override public init(frame: CGRect) {
        super.init(frame: frame)
        configuration()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        configuration()
    }
    
    // MARK: - Configuration
    
    /// 프로그레스 바의 기본 설정을 구성합니다.
    private func configuration() {
        progressTintColor = TDColor.Primary.primary500
        trackTintColor = TDColor.Neutral.neutral800
        
        snp.makeConstraints {
            $0.height.equalTo(4)
        }
    }
}
