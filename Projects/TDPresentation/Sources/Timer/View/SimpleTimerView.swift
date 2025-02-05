import TDDesign
import UIKit

final class SimpleTimerView: UIView {
    var progress: Float = 0 {
        didSet {
            updateProgress()
            updateTomatoPosition()
        }
    }

    var isEnabled: Bool = false {
        didSet {

        }
    }

    private let progressLayer = CAShapeLayer()
    private let trackLayer = CAShapeLayer()
    private let circularPath: UIBezierPath? = nil
    
    let tomatoView = UIImageView().then {
        $0.image = TDImage.Tomato.timer
        $0.contentMode = .scaleAspectFit
    }

    let circleView = UIView().then {
        $0.backgroundColor = .clear
    }

    init() {
        super.init(frame: .zero)
        addViews()
        layout()
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addViews()
        layout()
        setup()
    }

    func setup() {
        trackLayer.strokeColor = TDColor.Primary.primary100.cgColor
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineWidth = 20

        progressLayer.strokeColor = TDColor.Primary.primary500.cgColor
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineWidth = 20
        progressLayer.lineCap = .round
        progressLayer.strokeEnd = 0.5  // 초기값
    }

    func layout() {
        
        circleView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }

        tomatoView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(54)
        }
    }

    func addViews() {
        circleView.layer.addSublayer(trackLayer)
        circleView.layer.addSublayer(progressLayer)

        addSubview(tomatoView)
        addSubview(circleView)

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 원형 경로 생성
        let circularPath = UIBezierPath(
            arcCenter: CGPoint(x: circleView.bounds.midX, y: circleView.bounds.midY),
            radius: circleView.bounds.width / 2 - progressLayer.lineWidth / 2,
            startAngle: -CGFloat.pi / 2,
            endAngle: 3 * CGFloat.pi / 2,
            clockwise: true
        )

        // 경로 설정
        trackLayer.path = circularPath.cgPath
        progressLayer.path = circularPath.cgPath
    }
    
    //MARK: - private methods
    
    private func updateProgress() {
        CATransaction.begin()
        CATransaction.setDisableActions(false)
        CATransaction.setAnimationDuration(0.25) // 애니메이션 속도
        progressLayer.strokeEnd = CGFloat(progress) // 프로그레스 값 설정
        CATransaction.commit()
    }
    
    private func updateTomatoPosition() {
        guard let circularPath = circularPath else { return }
        
        // 토마토의 위치 계산
        let progressAngle = CGFloat(progress) * 2 * .pi - .pi / 2
        let radius = circleView.bounds.width / 2 - progressLayer.lineWidth / 2

        let x = circleView.bounds.midX + radius * cos(progressAngle)
        let y = circleView.bounds.midY + radius * sin(progressAngle)

        // 토마토 뷰 위치 업데이트
        tomatoView.center = CGPoint(x: x, y: y)
    }

}
    
