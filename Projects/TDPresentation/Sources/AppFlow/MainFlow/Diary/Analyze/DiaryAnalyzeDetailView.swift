import TDDesign
import UIKit

enum AnalyzeDetailType {
    case diary
    case focus
}

final class DiaryAnalyzeDetailView: BaseView {
    private let containerView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 12
    }
    let titleLabel = TDLabel(
        toduckFont: .mediumCaption1,
        toduckColor: TDColor.Neutral.neutral600
    )
    let description1Label = TDLabel(
        toduckFont: .boldHeader5,
        toduckColor: TDColor.Neutral.neutral800
    )
    lazy var description2Label = TDLabel(
        toduckFont: .boldHeader5,
        toduckColor: TDColor.Neutral.neutral800
    )
    let analyzeImageView = UIImageView().then {
        $0.image = TDImage.Analyze.bookIncrease
        $0.contentMode = .scaleAspectFit
    }
    
    let type: AnalyzeDetailType
    let diaryCount: Int?
    let focusPercent: Int?
    
    init(type: AnalyzeDetailType, diaryCount: Int?, focusPercent: Int?) {
        self.type = type
        self.diaryCount = diaryCount
        self.focusPercent = focusPercent
        super.init(frame: .zero)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Common Method
    override func addview() {
        addSubview(containerView)
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(description1Label)
        containerView.addSubview(description2Label)
        containerView.addSubview(analyzeImageView)
    }
    
    override func layout() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(16)
            $0.height.equalTo(12)
        }
        description1Label.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.equalToSuperview().offset(16)
            $0.height.equalTo(24)
        }
        description2Label.snp.makeConstraints {
            $0.top.equalTo(description1Label.snp.bottom)
            $0.leading.equalToSuperview().offset(16)
            $0.height.equalTo(24)
        }
        analyzeImageView.snp.makeConstraints {
            $0.top.equalTo(description2Label.snp.bottom).offset(12)
            $0.leading.trailing.bottom.equalToSuperview().inset(16)
            $0.height.equalTo(80)
        }
    }
    
    override func configure() {
        switch type {
        case .diary:
            guard let diaryCount = diaryCount else { return }
            titleLabel.setText("기분 일기")
            description1Label.setText("지난 달 보다")
            description2Label.attributedText = makeColoredText(
                mainText: "\(diaryCount)일 더 작성했어요",
                coloredPart: "\(diaryCount)일"
            )
        case .focus:
            guard let focusPercent = focusPercent else { return }
            titleLabel.setText("집중도 분석")
            description1Label.setText("이번 달 평균")
            description2Label.attributedText = makeColoredText(
                mainText: "집중도는 \(focusPercent)% 에요",
                coloredPart: "\(focusPercent)%"
            )
        }
    }
    
    private func makeColoredText(mainText: String, coloredPart: String) -> NSAttributedString {
        return UIFont.makeAttributedText(
            mainText: mainText,
            coloredPart: coloredPart,
            mainFont: TDFont.boldHeader5.font,
            mainColor: TDColor.Neutral.neutral800,
            highlightFont: TDFont.boldHeader5.font,
            highlightColor: TDColor.Primary.primary500
        )
    }
    
    // MARK: - Configure
    func updateDiaryCount(_ count: Int) {
        
        switch count {
        case let x where x > 0:
            analyzeImageView.image = TDImage.Analyze.bookIncrease
            description1Label.setText("지난 달 보다")
            description2Label.attributedText = makeColoredText(
                mainText: "\(count)일 더 작성했어요",
                coloredPart: "\(count)일"
            )
        case let x where x < 0:
            analyzeImageView.image = TDImage.Analyze.bookDecrease
            description1Label.setText("지난 달 보다")
            description2Label.setText("일기 작성이 줄었어요")
        default:
            analyzeImageView.image = TDImage.Analyze.bookZero
            description1Label.setText("지난 기록이 없어요..")
            description2Label.setText("일기를 작성해봐요!")
        }
    }
    
    func updateFocusPercent(_ percent: Int) {
        description1Label.setText("이번 달 평균")
        
        description2Label.attributedText = makeColoredText(
            mainText: "집중도는 \(percent)% 에요",
            coloredPart: "\(percent)%"
        )
        
        switch percent {
        case 0:
            analyzeImageView.image = TDImage.Analyze.focusZero
        case 1...20:
            analyzeImageView.image = TDImage.Analyze.focus1to20
        case 21...40:
            analyzeImageView.image = TDImage.Analyze.focus21to40
        case 41...70:
            analyzeImageView.image = TDImage.Analyze.focus41to70
        case 71...100:
            analyzeImageView.image = TDImage.Analyze.focus71to100
        default:
            analyzeImageView.image = TDImage.Analyze.focus71to100
        }
    }
}
