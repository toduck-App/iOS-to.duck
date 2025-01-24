//
//  ThemeSettingViewController.swift
//  TDPresentation
//
//  Created by 신효성 on 1/6/25.
//
import UIKit
import Combine
import TDCore
final class ThemeSettingViewController: BaseViewController<ThemeSettingView> {
    private let viewModel: TimerViewModel!
    private let input = PassthroughSubject<TimerViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()

    init(viewModel: TimerViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = nil
        super.init(coder: coder)
    }
    
    override func binding() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())

        output.sink { [weak self] event in
            switch event {
            default:
                break
            }

        }.store(in: &cancellables)
    }

}
