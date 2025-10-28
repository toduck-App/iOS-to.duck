//
//  SocialEventJoinSheet.swift
//  TDPresentation
//
//  Created by 승재 on 10/27/25.
//

import TDDesign
import TDDomain
import UIKit
import Combine

final class SocialEventJoinViewController: BaseViewController<SocialEventJoinView> {
    let viewModel: SocialEventJoinViewModel
    private let input = PassthroughSubject<SocialEventJoinViewModel.Input, Never>()
    private var cancellables: Set<AnyCancellable> = []
    
    weak var coordinator: SocialEventJoinCoordinator?
    init(viewModel: SocialEventJoinViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidLoad()
        coordinator?.didTapCancle()
    }
    
    override func configure() {
        layoutView.backgroundColor = TDColor.baseWhite
        layoutView.delegate = self
    }
    
    override func binding() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
            switch event {
            case .success:
                self?.coordinator?.didTapJoin()
            case .error(let message):
                self?.showErrorAlert(errorMessage: message)
            }
        }.store(in: &cancellables)
    }
}

extension SocialEventJoinViewController: SocialEventJoinViewDelegate {
    func eventSheetDidTapJoin(_ view: SocialEventJoinView, phoneNumber: String) {
        input.send(.joinEvent(phoneNumber))
    }
}
