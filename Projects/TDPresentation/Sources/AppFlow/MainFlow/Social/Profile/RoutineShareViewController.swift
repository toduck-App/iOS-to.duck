import Combine
import TDCore
import TDDesign
import TDDomain
import UIKit

final class RoutineShareViewController: TDPopupViewController<RoutineShareView> {
    weak var coordinator: RoutineShareCoordinator?
    private let viewModel: RoutineShareViewModel
    private let input = PassthroughSubject<RoutineShareViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    init(
        viewModel: RoutineShareViewModel
    ) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        input.send(.fetchRoutine)
        setupTapGestureForCategoryImageView() // viewDidLoad에서 탭 제스처 등록
    }
    
    override func configure() {
        super.configure()
        setupButtonActions()
    }
    
    private func setupButtonActions() {
        popupContentView.cancelButton.addAction(UIAction { [weak self] _ in
            self?.dismissPopup()
        }, for: .touchUpInside)
        popupContentView.doneButton.addAction(UIAction { [weak self] _ in
            self?.input.send(.createRoutine)
        }, for: .touchUpInside)
    } 
    
    private func setupTapGestureForCategoryImageView() {
        popupContentView.categoryImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCategoryTap))
        popupContentView.categoryImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleCategoryTap() {
        coordinator?.didTapSelectCategory()
    }
    
    override func binding() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self else { return }
                switch event {
                case .fetchRoutine(let routine):
                    popupContentView.routineTitleLabel.setText(routine.title)
                    configureRotuineDetails(routine: routine)
                    configureVisibility(routine: routine)
                case .success:
                    dismissPopup()
                case .failure(let description):
                    coordinator?.showErrorAlert(message: description)
                }
            }
            .store(in: &cancellables)
    }
    
    /// 이벤트 정보 설정
    private func configureRotuineDetails(routine: Routine) {
        popupContentView.titleLabel.setText("루틴 저장하기")
        
        popupContentView.categoryImageView.configure(
            radius: 12,
            backgroundColor: routine.categoryColor,
            category: routine.categoryIcon ?? .add
        )
        
        popupContentView.routineTitleLabel.setText(routine.title)
        popupContentView.timeDetailView.updateDescription(routine.time ?? "-")
        let repeatDaysString = routine.repeatDays?.compactMap(\.title).joined(separator: ", ") ?? "-"
        popupContentView.repeatDetailView.updateDescription(repeatDaysString)
        popupContentView.memoContentLabel.setText(routine.memo ?? "-")
    }
    
    /// 루틴과 일정에 따라 UI를 다르게 설정
    private func configureVisibility(routine: Routine) {
        popupContentView.lockDetailView.updateDescription(routine.isPublic ? "공개" : "비공개")
    }
}
