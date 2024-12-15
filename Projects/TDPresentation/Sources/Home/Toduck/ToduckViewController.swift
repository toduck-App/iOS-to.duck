//
//  ToduckViewController.swift
//  toduck
//
//  Created by 박효준 on 7/28/24.
//

import UIKit
import SnapKit
import Then
import TDCore
import TDDomain

final class ToduckViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        
        // 더미 버튼
        let button = UIButton().then {
            $0.setTitle("버튼", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.backgroundColor = .white
            $0.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        }
        
        view.addSubview(button)
        button.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(100)
            $0.height.equalTo(50)
        }
    }
    
    @objc private func didTapButton() {
        let fetchScheduleListUseCase = DIContainer.shared.resolve(FetchScheduleListUseCase.self)
        let viewModel = ToduckCalendarViewModel(fetchScheduleListUseCase: fetchScheduleListUseCase)
        let calendarViewController = ToduckCalendarViewController(viewModel: viewModel)
        navigationController?.pushViewController(calendarViewController, animated: true)
    }
}
