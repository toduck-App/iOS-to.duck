//
//  MyPageViewController.swift
//  toduck
//
//  Created by 박효준 on 7/15/24.
//

import UIKit

class MyPageViewController: UIViewController {
    weak var coordinator: MyPageCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemRed
        setupNavigationBar(style: .mypage, navigationDelegate: coordinator!)
    }
}
