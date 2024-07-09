//
//  ViewController.swift
//  toduck
//
//  Created by 승재 on 5/21/24.
//

import UIKit

class ViewController: UIViewController {
    
    let label: TDLabel = .init(
        frame: .zero,
        toduckFont: TDFont.mediumHeader1,
        alignment: .center,
        toduckColor: TDColor.baseBlack.color,
        labelText: "Custom TDLabel"
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = TDColor.Diary.diarySosoColor.color
        view.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            label.widthAnchor.constraint(equalToConstant: 300),
            label.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
}
