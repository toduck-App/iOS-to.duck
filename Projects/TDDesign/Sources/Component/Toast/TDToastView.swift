import UIKit

public final class TDToastView: UIView {
    // MARK: - Properties
    
    private let foregroundColor: UIColor
    private let titleText: String
    private let contentText: String
    private let sideDumpView = UIView()
    private let tomatoImageView: UIImageView
    private let sideColor = UIView()
    private let titleLabel = TDLabel(
        toduckFont: .boldBody2
    )
    private let contentLabel = TDLabel(
        toduckFont: .mediumBody3,
        toduckColor: TDColor.Neutral.neutral700
    )
    private let verticalStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 2
    }
    
    // MARK: - Initialize
    
    public init(
        frame: CGRect = .zero,
        foregroundColor: UIColor,
        tomatoImage: UIImage,
        titleText: String,
        contentText: String
    ) {
        self.foregroundColor = foregroundColor
        self.titleText = titleText
        self.contentText = contentText
        self.tomatoImageView = UIImageView(image: tomatoImage)
        super.init(frame: frame)
        
        addViews()
        layout()
        configure()
    }
    
    @available(*, unavailable)
    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func addViews() {
        addSubview(sideDumpView)
        addSubview(tomatoImageView)
        addSubview(verticalStackView)
        
        verticalStackView.addArrangedSubview(titleLabel)
        verticalStackView.addArrangedSubview(contentLabel)
    }
    
    private func layout() {
        snp.updateConstraints {
            $0.height.equalTo(69)
        }
        
        sideDumpView.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
            $0.width.equalTo(8)
        }
        
        tomatoImageView.snp.makeConstraints {
            $0.leading.equalTo(sideDumpView.snp.trailing).offset(16)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }
        
        verticalStackView.snp.makeConstraints {
            $0.leading.equalTo(tomatoImageView.snp.trailing).offset(12)
            $0.trailing.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
        }
    }
    
    private func configure() {
        layer.cornerRadius = 8
        backgroundColor = .white
        clipsToBounds = true
        
        sideDumpView.backgroundColor = .white
        
        titleLabel.setColor(foregroundColor)
        titleLabel.setText(titleText)
        
        contentLabel.setText(contentText)
        
        sideColor.backgroundColor = .white
    }
    
    func updateContentText(_ text: String) {
        contentLabel.setText(text)
    }
}
