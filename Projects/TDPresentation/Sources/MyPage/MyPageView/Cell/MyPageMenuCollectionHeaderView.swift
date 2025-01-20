//
//  MyPageMenuCollectionHeaderView.swift
//  TDPresentation
//
//  Created by 정지용 on 1/14/25.
//

import UIKit
import SnapKit

import TDDesign

final class MyPageMenuCollectionHeaderView: UICollectionReusableView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = TDFont.mediumCaption1.font
        label.textColor = TDColor.Neutral.neutral600
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
        setupLayoutConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with title: String) {
        titleLabel.text = title
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
    }
}

// MARK: - Private Methods
private extension MyPageMenuCollectionHeaderView {
    func setupView() {
        addSubview(titleLabel)
    }
    
    func setupLayoutConstraints() {
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(LayoutConstants.titleLabelPadding)
        }
    }
}

// MARK: - Constants
private extension MyPageMenuCollectionHeaderView {
    enum LayoutConstants {
        static let titleLabelPadding: CGFloat = 16
    }
}
