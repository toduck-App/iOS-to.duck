import Combine
import TDDesign
import UIKit

final class SocialSelectRoutineViewController: BaseViewController<SocialSelectRoutineView> {
    weak var coordinator: SocialSelectRoutineCoordinator?
    private let viewModel: SocialSelectRoutineViewModel!
    private let input = PassthroughSubject<SocialSelectRoutineViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: SocialSelectRoutineViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    required init?(coder: NSCoder) {
        self.viewModel = nil
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        input.send(.fetchRoutines)
    }
    
    override func configure() {
        layoutView.routineTableView.delegate = self
        layoutView.routineTableView.dataSource = self
        layoutView.routineTableView.register(SocialRoutineSelectCell.self, forCellReuseIdentifier: SocialRoutineSelectCell.identifier)
    }
    
    override func binding() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self else { return }
                switch event {
                case .fetchRoutines:
                    self.layoutView.routineTableView.reloadData()
                case .selectRoutine:
                    guard let routine = self.viewModel.selectedRoutine else { return }
                    self.coordinator?.didTapRoutine(routine)
                case .failure(let message):
                    break
                }
            }.store(in: &cancellables)
    }
}

extension SocialSelectRoutineViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.routines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SocialRoutineSelectCell.identifier, for: indexPath) as? SocialRoutineSelectCell else {
            return UITableViewCell()
        }
        cell.configure(event: viewModel.routines[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        84
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let routine = viewModel.routines[indexPath.row]
        input.send(.selectRoutine(routine))
    }
}
