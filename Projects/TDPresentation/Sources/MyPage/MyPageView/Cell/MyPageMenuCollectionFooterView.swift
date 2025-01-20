//
//  MyPageMenuCollectionFooterView.swift
//  TDPresentation
//
//  Created by 정지용 on 1/15/25.
//

import UIKit
import SnapKit

import TDDesign

final class MyPageMenuCollectionFooterView: UICollectionReusableView {
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = TDColor.Neutral.neutral300
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        addSubview(separatorView)
        separatorView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(LayoutConstants.separatorPadding)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(LayoutConstants.separatorHeight)
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Constants
private extension MyPageMenuCollectionFooterView {
    enum LayoutConstants {
        static let separatorHeight: CGFloat = 1
        static let separatorPadding: CGFloat = 16
    }
}
