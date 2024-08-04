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
        labelText: "Custom TDLabel",
        toduckFont: TDFont.mediumHeader1,
        alignment: .justified,
        toduckColor: TDColor.baseBlack
    )
    
    let calendarImageView: UIImageView = {
        let calendarImageView = UIImageView()
        calendarImageView.contentMode = .scaleAspectFit
        calendarImageView.image = TDImage.Calendar.medium
        
        return calendarImageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = TDColor.Diary.happy
        view.addSubview(label)
        view.addSubview(calendarImageView)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        calendarImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            label.widthAnchor.constraint(equalToConstant: 300),
            label.heightAnchor.constraint(equalToConstant: 100),
            
            calendarImageView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20),
            calendarImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            calendarImageView.widthAnchor.constraint(equalToConstant: 50),
            calendarImageView.heightAnchor.constraint(equalToConstant: 50),
        ])
        if let baseUrl = Bundle.main.infoDictionary?["SERVER_URL"] as? String {
            print("Base API URL: \(baseUrl)")
        }
    }
}
