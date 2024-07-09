//
//  ViewController.swift
//  toduck
//
//  Created by 승재 on 5/21/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .yellow
        if let baseUrl = Bundle.main.infoDictionary?["SERVER_URL"] as? String {
            print("Base API URL: \(baseUrl)")
        }
    }
}

