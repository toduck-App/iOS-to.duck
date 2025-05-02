import UIKit

public final class TDToast: UIView {
    let toastView: TDToastView
    
    public convenience init(
        toastType: TDToastType,
        titleText: String,
        contentText: String
    ) {
        self.init(
            foregroundColor: toastType.color,
            tomatoImage: toastType.tomato,
            titleText: titleText,
            contentText: contentText
        )
    }
    
    public init(
        foregroundColor: UIColor,
        tomatoImage: UIImage,
        titleText: String,
        contentText: String
    ) {
        toastView = TDToastView(
            foregroundColor: foregroundColor,
            tomatoImage: tomatoImage,
            titleText: titleText,
            contentText: contentText
        )
        super.init(frame: .zero)
        configure()
        layout()
    }
    
    @available(*, unavailable)
    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        backgroundColor = .clear
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 10
        layer.masksToBounds = false
        
        addSubview(toastView)
    }
    
    private func layout() {
        toastView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
