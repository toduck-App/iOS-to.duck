//
//  MyPageViewController.swift
//  toduck
//
//  Created by 박효준 on 7/15/24.
//

import UIKit

final class MyPageViewController: BaseViewController<MyPageView> {
    weak var coordinator: MyPageCoordinator?
    
    override func addView() {
        setupNavigationBar(style: .mypage, navigationDelegate: coordinator!)
    }
    
    override func layout() {
        self.view.backgroundColor = .white
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if let responderEvent = event as? CustomEventWrapper {
            if responderEvent.customType == .profileImageTapped {
                // TODO: coordinator로 화면 전환
            }
        }
    }
}
