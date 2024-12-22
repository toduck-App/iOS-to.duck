import FSCalendar
import UIKit
import TDDesign

final class ScheduleAndRoutineViewController: BaseViewController<BaseView> {
    enum Mode {
        case schedule
        case routine
    }
    
    // MARK: - UI Components
    private let weekCalendarView = HomeCalendar()
    private lazy var scheduleAndRoutineCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 100)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = TDColor.Neutral.neutral50
        collectionView.register(
            UICollectionViewCell.self,
            forCellWithReuseIdentifier: "cell"
        )
        return collectionView
    }()
    
    // MARK: - Properties
    private let mode: Mode
    
    // MARK: - Initialize
    init(mode: Mode) {
        self.mode = mode
        super.init()
    }
    
    required init?(coder: NSCoder) {
        self.mode = .schedule
        super.init(coder: coder)
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    // MARK: Base Method
    override func addView() {
        super.addView()
        
        view.addSubview(weekCalendarView)
        view.addSubview(scheduleAndRoutineCollectionView)
    }
    
    override func layout() {
        super.layout()
        
        weekCalendarView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(32)
            $0.leading.trailing.equalToSuperview().inset(28)
            $0.height.equalTo(160)
        }

        scheduleAndRoutineCollectionView.snp.makeConstraints {
            $0.top.equalTo(weekCalendarView.snp.bottom).offset(32)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    override func configure() {
        super.configure()
        
        view.backgroundColor = TDColor.baseWhite
        weekCalendarView.delegate = self
    }
}

// MARK: - FSCalendarDelegate

extension ScheduleAndRoutineViewController: FSCalendarDelegate {
    func calendar(
        _ calendar: FSCalendar,
        boundingRectWillChange bounds: CGRect,
        animated: Bool
    ) {
        calendar.snp.updateConstraints { make in
            make.height.equalTo(bounds.height)
        }
        self.view.layoutIfNeeded()
    }
}
