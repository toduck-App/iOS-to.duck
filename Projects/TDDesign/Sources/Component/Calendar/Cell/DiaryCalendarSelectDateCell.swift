import FSCalendar
import SnapKit
import Then

public final class DiaryCalendarSelectDateCell: FSCalendarCell {
    
    public let backImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }

    public let selectionBackgroundView = UIView().then {
        $0.backgroundColor = TDColor.Primary.primary100
        $0.clipsToBounds = true
    }

    // 감정 여부를 기억하는 프로퍼티
    private var hasEmotionImage = false

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setConstraints()
    }

    public required init(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setConstraints()
    }

    private func setupViews() {
        contentView.insertSubview(selectionBackgroundView, at: 0)
        contentView.insertSubview(backImageView, aboveSubview: selectionBackgroundView)
    }

    private func setConstraints() {
        titleLabel.snp.makeConstraints {
            $0.center.equalTo(contentView)
        }

        backImageView.snp.makeConstraints {
            $0.center.equalTo(contentView)
            $0.size.equalTo(minSize())
        }

        selectionBackgroundView.snp.makeConstraints {
            $0.center.equalTo(contentView)
            $0.size.equalTo(36)
        }
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        selectionBackgroundView.layer.cornerRadius = selectionBackgroundView.bounds.width / 2
        backImageView.layer.cornerRadius = backImageView.bounds.width / 2
    }

    public override var isSelected: Bool {
        didSet {
            // 감정 이미지가 없을 때만 선택 배경 보여줌
            selectionBackgroundView.isHidden = !isSelected || hasEmotionImage
        }
    }

    public override func prepareForReuse() {
        super.prepareForReuse()
        backImageView.image = nil
        hasEmotionImage = false
        selectionBackgroundView.isHidden = true
    }

    // 셀 설정 함수 (선택적으로 감정 이미지 유무 판단)
    public func configure(with emotion: UIImage?) {
        if let emotion = emotion {
            backImageView.image = emotion
            titleLabel.isHidden = true
            hasEmotionImage = true
        } else {
            backImageView.image = nil
            titleLabel.isHidden = false
            hasEmotionImage = false
        }

        // 선택 상태 재적용 (선택 상태 유지 중일 수 있어서)
        selectionBackgroundView.isHidden = !isSelected || hasEmotionImage
    }

    private func minSize() -> CGFloat {
        let width = contentView.bounds.width - 5
        let height = contentView.bounds.height - 5
        return min(width, height)
    }
}
