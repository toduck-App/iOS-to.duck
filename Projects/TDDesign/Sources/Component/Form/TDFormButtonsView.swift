import SnapKit
import Then
import UIKit

public protocol TDFormButtonsViewDelegate: AnyObject {
    /// 버튼이 눌렸을 때 호출됩니다.
    /// - Parameters:
    ///   - formButtonsView: 현재 `TDFormButtonsView` 인스턴스
    ///   - type: 버튼 뷰의 타입 (`repeatDay` 또는 `alarm`)
    ///   - selectedIndex: 눌린 버튼의 인덱스
    ///   - isSelected: 눌린 버튼이 선택되었는지 여부
    func formButtonsView(
        _ formButtonsView: TDFormButtonsView,
        type: TDFormButtonsViewType,
        didSelectIndex selectedIndex: Int,
        title: String,
        isSelected: Bool
    )
}

public enum TDFormButtonsViewType {
    case repeatDay
    case alarm
}

public final class TDFormButtonsView: UIView {
    // MARK: - UI Components
    private let containerVerticalStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.spacing = 12
    }
    
    private let titleHorizontalStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .center
    }
    private var titleImageView: UIImageView?
    private let titleLabelContainerView = UIView()
    private let titleLabel = TDLabel(toduckFont: .boldBody1)
    private let requiredLabel = TDLabel(
        labelText: "*",
        toduckFont: .boldBody1,
        alignment: .left,
        toduckColor: TDColor.Primary.primary500
    )
    
    private let buttonHorizontalStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .fill
        $0.distribution = .fillEqually
    }
    private var buttons = [TDSelectableButton]()
    
    // MARK: - Properties
    private let type: TDFormButtonsViewType
    private let isSchedule: Bool
    private var daysOfWeek = ["월", "화", "수", "목", "금", "토", "일"]
    private var alarmTimeList: [String] = []
    public weak var delegate: TDFormButtonsViewDelegate?
    
    // MARK: - Initialize
    public init(type: TDFormButtonsViewType, isSchedule: Bool) {
        self.type = type
        self.isSchedule = isSchedule
        super.init(frame: .zero)
        
        setupView()
        setupLayout()
        setupActions()
        requiredLabel.isHidden = true
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Cofigure
    public func selectButtons(buttonStateNames: [String]) {
        for button in buttons {
            let isSelected = buttonStateNames.contains(button.identifier)
            button.isSelected = isSelected
        }
    }
    
    public func showRequiredLabel() {
        requiredLabel.isHidden = false
    }
    
    public func updateAlarmContent(isAllDay: Bool) {
        // 알람 옵션 결정
        if isAllDay {
            alarmTimeList = ["1일 전"]
        } else {
            alarmTimeList = isSchedule
                ? ["10분 전", "30분 전", "1일 전"] // 일정
                : ["10분 전", "30분 전", "1시간 전"] // 루틴
        }

        // 기존 버튼 제거
        buttonHorizontalStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        buttons.removeAll()
        delegate?.formButtonsView(
            self,
            type: type,
            didSelectIndex: -1,
            title: "",
            isSelected: false
        )

        // 버튼 다시 생성
        buttons = alarmTimeList.enumerated().map { index, title in
            let button = TDSelectableButton(
                title: title,
                backgroundColor: TDColor.Neutral.neutral50,
                foregroundColor: TDColor.Neutral.neutral800,
                font: TDFont.mediumBody2.font
            )
            button.tag = index
            button.setInset()
            return button
        }

        // 버튼 레이아웃 추가 및 액션 설정
        buttons.forEach {
            buttonHorizontalStackView.addArrangedSubview($0)
            $0.addAction(UIAction { [weak self] action in
                guard let sender = action.sender as? TDSelectableButton else { return }
                self?.buttonTapped(sender)
            }, for: .touchUpInside)
        }
    }
    
    // MARK: - Setup
    private func setupView() {
        configureTitle()
        configureButtons()
    }
    
    private func configureTitle() {
        switch type {
        case .repeatDay:
            titleImageView = UIImageView(image: TDImage.Repeat.cycleMedium)
            titleLabel.setText("반복")
        case .alarm:
            titleImageView = UIImageView(image: TDImage.Bell.ringingMedium)
            titleLabel.setText("알람")
        }
        
        titleImageView?.contentMode = .scaleAspectFit
    }
    
    private func configureButtons() {
        let buttonTitles: [String] = {
            switch type {
            case .repeatDay:
                return daysOfWeek
            case .alarm:
                return []
            }
        }()
        
        buttons = buttonTitles.enumerated().map { index, title in
            let button = TDSelectableButton(
                title: title,
                backgroundColor: TDColor.Neutral.neutral50,
                foregroundColor: TDColor.Neutral.neutral800,
                font: TDFont.mediumBody2.font
            )
            button.tag = index
            button.setInset()
            return button
        }
    }
    
    private func setupLayout() {
        addSubview(containerVerticalStackView)
        containerVerticalStackView.addArrangedSubview(titleHorizontalStackView)
        containerVerticalStackView.addArrangedSubview(buttonHorizontalStackView)
        
        // 전체 스택 뷰
        containerVerticalStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        // 제목 스택 뷰
        titleHorizontalStackView.snp.makeConstraints {
            $0.height.equalTo(24)
        }
        
        // 버튼 스택 뷰
        buttonHorizontalStackView.snp.makeConstraints {
            $0.height.equalTo(32)
            $0.leading.trailing.equalToSuperview()
        }
        
        // 제목 이미지와 라벨
        if let titleImageView = titleImageView {
            titleHorizontalStackView.addArrangedSubview(titleImageView)
            titleImageView.snp.makeConstraints {
                $0.size.equalTo(20)
            }
        }
        titleHorizontalStackView.addArrangedSubview(titleLabelContainerView)
        titleLabelContainerView.addSubview(titleLabel)
        titleLabelContainerView.addSubview(requiredLabel)
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.bottom.equalToSuperview()
        }
        
        requiredLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.trailing).offset(4)
            $0.top.bottom.equalToSuperview()
        }
        
        // 버튼 추가
        buttons.forEach { buttonHorizontalStackView.addArrangedSubview($0) }
    }
    
    private func setupActions() {
        buttons.forEach { button in
            button.addAction(UIAction { [weak self] action in
                guard let sender = action.sender as? TDSelectableButton else { return }
                self?.buttonTapped(sender)
            }, for: .touchUpInside)
        }
    }

    private func buttonTapped(_ sender: TDSelectableButton) {
        guard let index = buttons.firstIndex(of: sender) else { return }

        switch type {
        case .repeatDay:
            sender.isSelected.toggle()
            
        case .alarm:
            let wasSelected = sender.isSelected
            buttons.forEach { $0.isSelected = false }
            sender.isSelected = !wasSelected
        }

        delegate?.formButtonsView(
            self,
            type: type,
            didSelectIndex: index,
            title: sender.titleLabel?.text ?? "",
            isSelected: sender.isSelected
        )
    }
}
