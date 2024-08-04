//
//  TimerViewController.swift
//  toduck
//
//  Created by 박효준 on 7/15/24.
//

import UIKit

class TimerViewController: UIViewController, TDSheetPresentation {
    
    let sheetButton = UIButton().then {
        $0.setTitle("시트지 열기", for: .normal)
        $0.addTarget(self, action: #selector(showDetail), for: .touchUpInside)
        $0.setTitleColor(.systemRed, for: .normal)
    }
    
    @objc func showDetail() {
        let bottomSheetVC = ThemeViewController()
        showSheet(with: bottomSheetVC)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        
        view.addSubview(sheetButton)
        sheetButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sheetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sheetButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
