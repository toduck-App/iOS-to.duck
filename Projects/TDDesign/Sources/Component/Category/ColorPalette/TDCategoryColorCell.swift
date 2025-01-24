import UIKit
import SnapKit
import Then

import UIKit

final class TDCategoryColorCell: UICollectionViewCell {
    // MARK: - UI Components
    private let backgroundCircleView = UIView().then {
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    private let checkImageView = UIImageView().then {
        $0.image = TDImage.checkMedium
        $0.isHidden = true // 기본 숨김
        $0.contentMode = .scaleAspectFit
    }
    private let titleLabel = TDLabel(
        labelText: "토덕의 일정",
        toduckFont: TDFont.mediumCaption3
    )

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        backgroundCircleView.layer.borderWidth = 0
        backgroundCircleView.layer.borderColor = nil
        checkImageView.image = TDImage.checkMedium
        
        checkImageView.snp.removeConstraints()
        checkImageView.snp.makeConstraints {
            $0.center.equalTo(backgroundCircleView)
            $0.width.height.equalToSuperview().inset(12)
        }
    }

    // MARK: - Setup
    private func setupViews() {
        contentView.addSubview(backgroundCircleView)
        contentView.addSubview(checkImageView)
        contentView.addSubview(titleLabel)
    }

    private func setupLayout() {
        backgroundCircleView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(48)
        }

        checkImageView.snp.makeConstraints {
            $0.center.equalTo(backgroundCircleView)
            $0.width.height.equalToSuperview().inset(12)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(backgroundCircleView.snp.bottom).offset(6)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(50)
        }
    }

    // MARK: - Configuration
    public func configure(
        color: UIColor,
        textColor: UIColor,
        isSelected: Bool
    ) {
        backgroundCircleView.backgroundColor = color
        titleLabel.textColor = textColor
        titleLabel.backgroundColor = color
        checkImageView.isHidden = !isSelected
        checkImageView.tintColor = textColor
        
        if color == TDColor.baseWhite {
            backgroundCircleView.layer.borderWidth = 1
            backgroundCircleView.layer.borderColor = TDColor.Schedule.back10.cgColor
            checkImageView.image = TDImage.slashMedium.withTintColor(TDColor.Schedule.back10)
            checkImageView.isHidden = false
            
            if isSelected {
                backgroundCircleView.layer.borderWidth = 1
                backgroundCircleView.layer.borderColor = TDColor.Schedule.back10.cgColor
                checkImageView.image = TDImage.checkMedium.withTintColor(textColor)
                
                checkImageView.snp.makeConstraints {
                    $0.center.equalTo(backgroundCircleView)
                    $0.width.height.equalToSuperview().inset(12)
                }
            } else {
                checkImageView.image = TDImage.slashMedium.withTintColor(TDColor.Schedule.back10)
                checkImageView.snp.makeConstraints {
                    $0.width.height.equalToSuperview().inset(20)
                }
            }
        }
    }
}
