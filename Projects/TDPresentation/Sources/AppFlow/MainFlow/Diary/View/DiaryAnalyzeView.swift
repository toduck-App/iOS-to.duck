import TDDesign
import UIKit

final class DiaryAnalyzeView: BaseView {
    let nickNameLabel = TDLabel(
        toduckFont: .boldHeader4,
        toduckColor: TDColor.Neutral.neutral800
    )
    let titleLabel = TDLabel(
        labelText: "님을 분석해봤어요 !",
        toduckFont: .boldHeader4,
        toduckColor: TDColor.Neutral.neutral700
    )
    
    private let analzeHorizontalStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 10
    }
    lazy var diaryAnalyzeLabel = DiaryAnalyzeDetailView(
        type: .diary,
        diaryCount: diaryCount,
        focusPercent: focusPercent
    )
    lazy var focusAnalyzeLabel = DiaryAnalyzeDetailView(
        type: .focus,
        diaryCount: diaryCount,
        focusPercent: focusPercent
    )
    let diaryCount: Int?
    let focusPercent: Int?
    
    init(diaryCount: Int?, focusPercent: Int?) {
        self.diaryCount = diaryCount
        self.focusPercent = focusPercent
        super.init(frame: .zero)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addview() {
        addSubview(nickNameLabel)
        addSubview(titleLabel)
        addSubview(analzeHorizontalStackView)
        analzeHorizontalStackView.addArrangedSubview(diaryAnalyzeLabel)
        analzeHorizontalStackView.addArrangedSubview(focusAnalyzeLabel)
    }
    
    override func layout() {
        nickNameLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(8)
            make.leading.equalToSuperview().inset(24)
        }
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(nickNameLabel)
            make.leading.equalTo(nickNameLabel.snp.trailing)
        }
        analzeHorizontalStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(180)
        }
    }
    
    func configure(nickname: String) {
        nickNameLabel.setText(nickname)
    }
}
