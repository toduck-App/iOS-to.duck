//
//  DiaryViewController.swift
//  toduck
//
//  Created by 박효준 on 7/15/24.
//

import TDDesign
import UIKit

class DiaryViewController: UIViewController {
    weak var coordinator: DiaryCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar(style: .diary, navigationDelegate: coordinator!)
        self.view.backgroundColor = .systemGray
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.tabBarController?.tabBar.backgroundColor = TDColor.baseBlack
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.tabBarController?.tabBar.backgroundColor = TDColor.baseWhite
    }
}
