import SnapKit
import UIKit

public final class TDCheckbox: UIButton {
    private var backgroundTocukColor: UIColor
    private var foregroundTocukColor: UIColor
    private var checkImage: UIImage
    public var onToggle: ((Bool) -> Void)?
    
    // MARK: - Initialization
    public init(
        frame: CGRect = .zero,
        backgroundColor: UIColor = TDColor.Primary.primary200,
        foregroundColor: UIColor = TDColor.Primary.primary500
    ) {
        backgroundTocukColor = backgroundColor
        foregroundTocukColor = foregroundColor
        checkImage = TDImage.checkMedium
        super.init(frame: frame)
        setupCheckBox()
        layout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public var isSelected: Bool {
        didSet {
            if isSelected {
                layer.borderColor = UIColor.clear.cgColor
                backgroundColor = backgroundTocukColor
                tintColor = foregroundTocukColor

                setImage(TDImage.checkMedium, for: .normal)
            } else {
                layer.borderColor = TDColor.Neutral.neutral400.cgColor
                backgroundColor = .white
                setImage(nil, for: .normal)
            }
        }
    }

    private func setupCheckBox() {
        imageView?.tintColor = foregroundTocukColor
        
        addAction(UIAction { [weak self] _ in
            self?.buttonClicked()
        }, for: .touchUpInside)

        layer.borderColor = TDColor.Neutral.neutral400.cgColor
        backgroundColor = .white
        setImage(nil, for: .normal)
        layer.borderWidth = 1
        layer.cornerRadius = 8
    }

    private func layout() {
        snp.makeConstraints { make in
            make.width.height.equalTo(22)
        }
    }
    
    private func buttonClicked() {
        isSelected.toggle()
        onToggle?(isSelected)
    }
}
