//
//  ThemeViewController.swift
//  toduck
//
//  Created by 박효준 on 8/4/24.
//

import UIKit
import SnapKit
import Then

// MARK: 테스트 시트지 뷰 컨트롤러
class ThemeViewController: UIViewController {
    let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .equalSpacing
        $0.spacing = 10
        
        for i in 1...15 {
            let label = UILabel()
            label.text = "Label \(i)"
            label.textAlignment = .center
            $0.addArrangedSubview(label)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(20)
            make.leading.equalTo(view.snp.leading).offset(20)
            make.trailing.equalTo(view.snp.trailing).offset(-20)
        }
    }
}
