import Foundation
import UIKit

public final class TDBadge: UIView {

    private var title: String
    private var backgroundToduckColor: UIColor
    private var foregroundToduckColor: UIColor
    private var cornerRadius: CGFloat
    private var font: TDFont
    private var label: TDLabel

    /// 투덕에서 사용되는 뱃지를 만드는 초기화 메서드입니다.
    /// - Parameters:
    ///   - frame: 프레임
    ///   - title: 뱃지의 텍스트
    ///   - font: 텍스트의 폰트
    ///   - backgroundToduckColor: 뱃지의 배경 색상
    ///   - foregroundToduckColor: 뱃지의 텍스트 색상
    ///   - cornerRadius: 뱃지의 모서리 둥글기
    public init(frame: CGRect = .zero,
                title: String,
                font: TDFont,
                backgroundToduckColor: UIColor,
                foregroundToduckColor: UIColor,
                cornerRadius: CGFloat)
    {
        self.title = title
        self.font = font
        self.backgroundToduckColor = backgroundToduckColor
        self.foregroundToduckColor = foregroundToduckColor
        self.cornerRadius = cornerRadius
        label = TDLabel(labelText: title, toduckFont: self.font, toduckColor: self.foregroundToduckColor)
        super.init(frame: .zero)

        setupBadge()
        layout()
    }
    /// 기본 색으로 지정된 뱃지를 만드는 초기화 메서드입니다.
    /// - Parameter badgeTitle: 뱃지에 표시할 텍스트
    convenience init(badgeTitle: String) {
        self.init(badgeTitle: badgeTitle, backgroundColor: TDColor.Primary.primary25, foregroundColor: TDColor.Primary.primary200)
    }

    /// 색깔을 지정할 수 있는 뱃지를 만드는 초기화 메서드입니다.
    /// - Parameters:
    ///   - badgeTitle: 뱃지의 텍스트
    ///   - backgroundColor: 뱃지의 배경 색상
    ///   - foregroundColor: 뱃지의 텍스트 색상
    convenience init(badgeTitle: String, backgroundColor: UIColor, foregroundColor: UIColor) {
        self.init(
            title: badgeTitle,
            font: .mediumCaption2,
            backgroundToduckColor: backgroundColor,
            foregroundToduckColor: foregroundColor,
            cornerRadius: 4
        )
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @available(*, deprecated, message: "Please use init(badgeTitle:backgroundToduckColor:foregroundToduckColor:) instead")
    convenience init(_ title: String, backgroundToduckColor: UIColor = TDColor.Primary.primary25, foregroundToduckColor: UIColor = TDColor.Primary.primary500) {
        self.init(badgeTitle: title, backgroundColor: backgroundToduckColor, foregroundColor: foregroundToduckColor)
    }

    private func setupBadge() {
        label.sizeToFit()
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
        backgroundColor = backgroundToduckColor
    }

    private func layout() {
        addSubview(label)

        self.snp.makeConstraints {
            $0.height.equalTo(20)
        }

        label.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.bottom.top.equalToSuperview()
        }
    }

    // MARK: - Public Methods

    /// 뱃지에 표시할 문자열을 설정합니다.
    /// - Parameter title: 뱃지에 표시할 문자열
    public func setTitle(_ title: String) {
        self.title = title
        label.setText(self.title)
        setupBadge()
    }


    /// 뱃지의 폰트를 설정합니다.
    /// - Parameter font: 뱃지의 폰트
    public func setFont(_ font: TDFont) {
        self.font = font
        label.setFont(font)
        setupBadge()
    }

    /// 뱃지의 모서리 둥글기를 설정합니다.
    /// - Parameter cornerRadius: 뱃지의 모서리 둥글기
    public func setCornerRadius(_ cornerRadius: CGFloat) {
        self.cornerRadius = cornerRadius
        layer.cornerRadius = cornerRadius
        setupBadge()
    }

    /// 뱃지의 텍스트 색상을 설정합니다.
    /// - Parameter titleColor: 뱃지의 텍스트 색상
    public func setTitleColor(_ titleColor: UIColor) {
        self.foregroundToduckColor = titleColor
        label.setColor(foregroundToduckColor)
        setupBadge()
    }


    /// 뱃지의 배경 색상을 설정합니다.
    /// - Parameter backgroundColor: 뱃지의 배경 색상
    public func setBackgroundToduckColor(_ backgroundToduckColor: UIColor) {
        self.backgroundToduckColor = backgroundToduckColor
        backgroundColor = backgroundToduckColor
        setupBadge()
    }
}
