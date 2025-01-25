import SnapKit
import Then
import UIKit

public protocol TDFormSegmentViewDelegate: AnyObject {
    /// 공개/비공개 상태가 변경되었을 때 호출됩니다.
    /// - Parameter isPublic: 공개 상태(`true`: 공개, `false`: 비공개)
    func segmentView(_ segmentView: TDFormSegmentView, didChangeToPublic isPublic: Bool)
}

public final class TDFormSegmentView: UIView {
    // MARK: - UI Properties
    private var titleImageView = UIImageView().then {
        $0.image = TDImage.Lock.medium
        $0.contentMode = .scaleAspectFit
    }
    private let titleLabel = TDLabel(
        labelText: "공개여부",
        toduckFont: .boldBody1
    )
    
    private let lockSegmentedControl = UISegmentedControl(items: ["공개", "비공개"]).then {
        $0.selectedSegmentIndex = 0
        
        $0.setTitleTextAttributes([
            .font: TDFont.mediumBody3.font,
            .foregroundColor: TDColor.Neutral.neutral500
        ], for: .normal)
        
        // Selected 상태 속성 설정
        $0.setTitleTextAttributes([
            .font: TDFont.mediumBody3.font,
            .foregroundColor: TDColor.Neutral.neutral700
        ], for: .selected)
        
        // SegmentedControl 배경색 및 틴트색
        $0.backgroundColor = TDColor.Neutral.neutral50
        $0.selectedSegmentTintColor = TDColor.baseWhite
    }
    public weak var delegate: TDFormSegmentViewDelegate?

    // MARK: - Initializer
    public init() {
        super.init(frame: .zero)
        
        setupLayout()
        setupActions()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(titleImageView)
        addSubview(titleLabel)
        addSubview(lockSegmentedControl)
        
        titleImageView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.width.height.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(titleImageView.snp.trailing).offset(8)
            $0.top.bottom.equalToSuperview()
        }
        
        lockSegmentedControl.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.trailing).offset(8)
            $0.trailing.equalToSuperview()
            $0.centerY.equalTo(titleLabel.snp.centerY)
        }
    }
    
    private func setupActions() {
        lockSegmentedControl.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            let isPublic = lockSegmentedControl.selectedSegmentIndex == 0
            delegate?.segmentView(self, didChangeToPublic: isPublic)
        }, for: .valueChanged)
    }
}
