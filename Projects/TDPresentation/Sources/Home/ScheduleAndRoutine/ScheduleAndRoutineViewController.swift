//
//  ScheduleViewController.swift
//  toduck
//
//  Created by 박효준 on 7/28/24.
//

import UIKit

final class ScheduleAndRoutineViewController: BaseViewController<BaseView> {
    enum Mode {
        case schedule
        case routine
    }
    
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
        
        setup()
    }
    
    private func setup() {
        switch mode {
        case .schedule:
            view.backgroundColor = .red
        case .routine:
            view.backgroundColor = .green
        }
    }
}
