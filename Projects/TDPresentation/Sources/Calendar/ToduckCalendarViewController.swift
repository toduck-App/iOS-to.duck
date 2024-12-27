//
//  CalendarViewController.swift
//  toduck
//
//  Created by 박효준 on 9/29/24.
//

import FSCalendar
import SnapKit
import TDDesign
import UIKit
import Combine

// FIXME: 실 기기에서 빌드할 경우 캘린더 깨짐 현상 발생
final class ToduckCalendarViewController: BaseViewController<BaseView> {
    // MARK: Nested Types
    private enum DetailViewState {
        case topExpanded
        case topCollapsed
        case topHidden
    }
    
    // MARK: - UI Components
    let calendarHeader = CalendarHeaderStackView(type: .toduck)
    let calendar = ToduckCalendar()
    private let selectedDayScheduleView = SelectedDayScheduleView()
    
    // MARK: - Properties
    private let viewModel: ToduckCalendarViewModel!
    private let input = PassthroughSubject<ToduckCalendarViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    private var calendarHeightConstraint: Constraint?
    private var selectedDayViewTopConstraint: Constraint?
    private var selectedDayViewTopExpanded: CGFloat = 0
    private var selectedDayViewTopCollapsed: CGFloat = 0
    private var selectedDayViewTopHidden: CGFloat = 0
    private var isInitialLayoutDone = false  // 첫 실행 때만 레이아웃 업데이트
    private var isDetailCalendarMode = false // 캘린더가 화면 꽉 채우는지
    private var currentDetailViewState: DetailViewState = .topCollapsed
    private var initialDetailViewState: DetailViewState = .topCollapsed
    weak var coordinator: ToduckCalendarCoordinator?
    
    init(viewModel: ToduckCalendarViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        viewModel = nil
        super.init(coder: coder)
    }
    
    // MARK: - Life Cycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setup()
        binding()
        input.send(.fetchScheduleList)
        addSubviews()
        setupCalendar()
        setupConstraints()
        setupGesture()
        selectToday()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !isInitialLayoutDone {
            updateConstants()
            selectedDayViewTopConstraint?.update(offset: selectedDayViewTopCollapsed)
            isInitialLayoutDone = true
        }
        view.bringSubviewToFront(selectedDayScheduleView)
    }
    
    private func updateConstants() {
        let safeAreaTop = view.safeAreaInsets.top
        let calendarHeaderHeight = calendarHeader.frame.height
        let calendarHeight = calendar.frame.height
        let dragViewHeight = selectedDayScheduleView.headerView.frame.height
        let tabBarHeight = tabBarController?.tabBar.frame.height ?? 0
        
        selectedDayViewTopExpanded = safeAreaTop + Constant.calendarHeaderTopOffset
        selectedDayViewTopCollapsed = calendarHeaderHeight + selectedDayViewTopExpanded + Constant.calendarTopOffset + calendarHeight
        selectedDayViewTopHidden = view.bounds.height - dragViewHeight - tabBarHeight
    }
    
    // MARK: - Setup
    private func setup() {
        selectedDayScheduleView.scheduleTableView.delegate = self
        selectedDayScheduleView.scheduleTableView.dataSource = self
        selectedDayScheduleView.scheduleTableView.separatorInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    }
    
    override func binding() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .fetchedScheduleList:
                    self?.selectedDayScheduleView.scheduleTableView.reloadData()
                case .failure(let errorMessage):
                    self?.showErrorAlert(with: errorMessage)
                }
            }.store(in: &cancellables)
    }
    
    private func addSubviews() {
        view.addSubview(calendarHeader)
        view.addSubview(calendar)
        view.addSubview(selectedDayScheduleView)
    }
    
    private func setupConstraints() {
        calendarHeader.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(4)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(16)
        }
        calendar.snp.makeConstraints {
            $0.centerX.equalTo(view)
            $0.top.equalTo(calendarHeader.snp.bottom).offset(20)
            $0.width.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.95)
            self.calendarHeightConstraint = $0.height.equalTo(Constant.calendarHeight).constraint
        }
        selectedDayScheduleView.snp.makeConstraints {
            self.selectedDayViewTopConstraint = $0.top.equalTo(view).constraint
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func selectToday() {
        let today = Date()
        calendar.select(today)
        selectedDayScheduleView.updateDateLabel(date: today)
    }
}

private extension ToduckCalendarViewController {
    private enum Constant {
        static let calendarHeaderTopOffset: CGFloat = 30
        static let calendarTopOffset: CGFloat = 20
        static let calendarHeight: CGFloat = 334
    }
    
    private func setupGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        selectedDayScheduleView.headerView.addGestureRecognizer(panGesture)
    }
    
    @objc
    func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view).y
        let velocity = gesture.velocity(in: view).y
        
        switch gesture.state {
        case .began:
            initialDetailViewState = self.currentDetailViewState
            
        case .changed:
            var newTop = (selectedDayViewTopConstraint?.layoutConstraints.first?.constant ?? selectedDayViewTopCollapsed) + translation
            newTop = max(selectedDayViewTopExpanded, min(selectedDayViewTopHidden, newTop))
            selectedDayViewTopConstraint?.update(offset: newTop)
            gesture.setTranslation(.zero, in: view)
            
        case .ended, .cancelled:
            let currentTop = selectedDayViewTopConstraint?.layoutConstraints.first?.constant ?? selectedDayViewTopCollapsed
            let shouldExpand: Bool
            let shouldHide: Bool
            let targetTop: CGFloat
            let detailViewState: DetailViewState
            
            switch initialDetailViewState {
            case .topHidden:
                // TopHidden 상태에서는 위로 스와이프하면 무조건 TopCollapsed로 이동
                if velocity < 0 {
                    targetTop = selectedDayViewTopCollapsed
                    detailViewState = .topCollapsed
                } else {
                    // 아래로 스와이프하면 그대로 TopHidden 유지
                    targetTop = selectedDayViewTopHidden
                    detailViewState = .topHidden
                }
            default:
                if abs(velocity) > 500 {
                    shouldExpand = velocity < 0
                    shouldHide = velocity > 0 && currentTop > selectedDayViewTopCollapsed + 100
                } else {
                    let middlePosition = (selectedDayViewTopCollapsed + selectedDayViewTopExpanded) / 2
                    shouldExpand = currentTop < middlePosition
                    shouldHide = currentTop >= selectedDayViewTopHidden - 100
                }
                
                if shouldExpand {
                    targetTop = selectedDayViewTopExpanded
                    detailViewState = .topExpanded
                } else if shouldHide {
                    targetTop = selectedDayViewTopHidden
                    detailViewState = .topHidden
                } else {
                    targetTop = selectedDayViewTopCollapsed
                    detailViewState = .topCollapsed
                }
            }
            
            UIView.animate(withDuration: 0.3, animations: {
                self.selectedDayViewTopConstraint?.update(offset: targetTop)
                self.view.layoutIfNeeded()
            }, completion: { _ in
                self.adjustCalendarHeight(for: detailViewState)
                self.currentDetailViewState = detailViewState
            })
            
        default:
            break
        }
    }
    
    // FIXME: FSCalendarCollectionView가 아니라 UIView가 늘어나고 있음
    private func adjustCalendarHeight(for detailViewState: DetailViewState) {
        let newCalendarHeight: CGFloat
        
        switch detailViewState {
        case .topHidden:
            newCalendarHeight = selectedDayViewTopHidden - (calendarHeader.frame.maxY + view.safeAreaInsets.bottom)
        case .topExpanded, .topCollapsed:
            newCalendarHeight = Constant.calendarHeight
        }
        
        // 먼저 rowHeight를 계산
        let headerHeight = calendar.headerHeight
        let weekdayHeight = calendar.weekdayHeight
        let numberOfRows: CGFloat = 6 // 최대 6주
        let newRowHeight = (newCalendarHeight - headerHeight - weekdayHeight) / numberOfRows
        
        // 애니메이션과 함께 변경사항 적용
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            guard let self else { return }
            self.calendar.rowHeight = newRowHeight
            self.calendarHeightConstraint?.update(offset: newCalendarHeight)
        }, completion: { [weak self] _ in
            guard let self else { return }
            self.calendar.setNeedsLayout()
            self.calendar.layoutIfNeeded()
        })
    }
}

// MARK: - FSCalendarDelegateAppearance, FSCalendarDataSource, FSCalendarDelegate
extension ToduckCalendarViewController: TDCalendarConfigurable {
    func calendar(
        _ calendar: FSCalendar,
        didSelect date: Date,
        at monthPosition: FSCalendarMonthPosition
    ) {
        selectedDayScheduleView.updateDateLabel(date: date)
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        updateHeaderLabel(for: calendar.currentPage)
    }
    
    // MARK: - 날짜 폰트 색상
    // 기본 폰트 색
    func calendar(
        _ calendar: FSCalendar,
        appearance: FSCalendarAppearance,
        titleDefaultColorFor date: Date
    ) -> UIColor? {
        // TODO: 인접한 달 Neutral600 색상 표시
        colorForDate(date)
    }
    
    // 선택된 날짜 폰트 색 (이걸 안 하면 오늘날짜와 토,일 선택했을 때 폰트색이 바뀜)
    func calendar(
        _ calendar: FSCalendar,
        appearance: FSCalendarAppearance,
        titleSelectionColorFor date: Date
    ) -> UIColor? {
        colorForDate(date)
    }
    
    // MARK: - 날짜 아래의 이벤트
    // 날짜 아래 점 개수 지정
    func calendar(
        _ calendar: FSCalendar,
        numberOfEventsFor date: Date
    ) -> Int {
        0
    }
    
    // 날짜 아래 점 색상 지정 (이벤트 색상)
    func calendar(
        _ calendar: FSCalendar,
        appearance: FSCalendarAppearance,
        eventDefaultColorsFor date: Date
    ) -> [UIColor]? {
        colorFromEvent(for: date)
    }
    
    // 선택된 날짜에도 동일한 이벤트 색상을 유지하도록 설정
    func calendar(
        _ calendar: FSCalendar,
        appearance: FSCalendarAppearance,
        eventSelectionColorsFor date: Date
    ) -> [UIColor]? {
        colorFromEvent(for: date)
    }
    
    // TODO: 나중에 TDCalendarConfigurable로 옮겨야 함, tempSchedules 생각하기
    // 날짜에 대한 일정 색상을 반환하는 헬퍼 메서드
    func colorFromEvent(for date: Date) -> [UIColor]? {
        return nil
    }
}

// MARK: - UITableViewDelegate
extension ToduckCalendarViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    // TODO: 셀 좌측 색상 바와 우측 삭제 버튼 Radius 처리
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: nil
        ) { _, _, _ in
            
        }
        deleteAction.image = TDImage.trashWhiteMedium
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

// MARK: - UITableViewDataSource
extension ToduckCalendarViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.scheduleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.identifier, for: indexPath)
        
        let detailView = EventDetailView()
        cell.contentView.addSubview(detailView)
        
        detailView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let dummyData = viewModel.scheduleList[indexPath.row]
        detailView.configureCell(
            color: .black,
            title: dummyData.title,
            time: nil,
            category: nil,
            isFinish: dummyData.isFinish,
            place: dummyData.place
        )
        detailView.configureButtonAction {
            print("체크박스 클릭")
        }
        
        return cell
    }
}
