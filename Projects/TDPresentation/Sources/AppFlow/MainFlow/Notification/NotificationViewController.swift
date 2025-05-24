import TDDesign
import TDCore
import Combine
import UIKit

final class NotificationViewController: BaseViewController<BaseView> {
    // MARK: - UI Components
    private let noAlarmContainerView = UIView()
    private let noAlarmImageView = UIImageView(image: TDImage.noEvent)
    private let noAlarmLabel = TDLabel(
        labelText: "도착한 알림이 없어요",
        toduckFont: .boldBody1,
        toduckColor: TDColor.Neutral.neutral600
    )
    
    // MARK: - Properties
    private let viewModel: NotificationViewModel
    private let input = PassthroughSubject<NotificationViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    weak var coordinator: NotificationCoordinator?
    
    // MARK: - Initializer
    init(
        viewModel: NotificationViewModel
    ) {
        self.viewModel = viewModel
        super.init()
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        input.send(.fetchNotificationList(page: 0, size: 20))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        input.send(.readAllNotifications)
    }
    
    // MARK: - Common Methods
    override func addView() {
        layoutView.addSubview(noAlarmContainerView)
        noAlarmContainerView.addSubview(noAlarmImageView)
        noAlarmContainerView.addSubview(noAlarmLabel)
    }
    
    override func layout() {
        noAlarmContainerView.snp.makeConstraints { make in
            make.top.equalTo(layoutView.safeAreaLayoutGuide.snp.top).offset(56)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(152)
        }
        noAlarmImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(96)
        }
        noAlarmLabel.snp.makeConstraints { make in
            make.top.equalTo(noAlarmImageView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
    }
    
    override func binding() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .fetchedNotificationList:
                    TDLogger.info("알림 목록을 성공적으로 가져왔습니다.")
                case .failure(let message):
                    self?.showErrorAlert(errorMessage: message)
                }
            }.store(in: &cancellables)
    }
    
    override func configure() {
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigationController?.setupNestedNavigationBar(
            leftButtonTitle: "",
            leftButtonAction: UIAction { [weak self] _ in
                self?.coordinator?.finish(by: .pop)
            }
        )
    }
}
