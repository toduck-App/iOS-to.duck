import UIKit
import TDDesign
import Combine

final class SocialReportDetailViewController: BaseViewController<SocialReportDetailView> {
    weak var coordinator: SocialReportCoordinator?
    private let viewModel: SocialReportViewModel!
    private var cancellables = Set<AnyCancellable>()
    private let input = PassthroughSubject<SocialReportViewModel.Input, Never>()

    init(viewModel: SocialReportViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        layoutView.setReason(reason: viewModel.reportType)
        layoutView.reportButton.addTarget(self, action: #selector(reportAction), for: .touchUpInside)
    }
    
    override func binding() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .reportPostSuccess:
                    self?.coordinator?.didTapReport()
                case .failure(let errorMessage):
                    self?.showErrorAlert(errorMessage: errorMessage)
                }
            }
            .store(in: &cancellables)
    }

    @objc private func reportAction() {
        input.send(.reportPost)
    }
    
    override func configure() {
        super.configure()
        layoutView.socialTextField.delegate = self
        layoutView.checkBoxButton.onToggle = { [weak self] isChecked in
            self?.input.send(.checkBlockAuthor(isChecked))
        }
    }
}

extension SocialReportDetailViewController: TDFormTextViewDelegate {
    func tdTextView(_ textView: TDDesign.TDFormTextView, didChangeText text: String) {
        input.send(.typingText(text))
    }
}
