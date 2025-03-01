//
//  MyPageMenuCollectionViewCell.swift
//  TDPresentation
//
//  Created by 정지용 on 1/14/25.
//

import UIKit
import SnapKit

import TDDesign

final class MyPageMenuCollectionViewCell: UICollectionViewCell {
    private let textLabel: UILabel = {
        let label = UILabel()
        label.font = TDFont.mediumBody2.font
        label.textColor = TDColor.Neutral.neutral800
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupViews()
        setupLayoutConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textLabel.text = nil
    }
    
    func configure(with title: String) {
        textLabel.text = title
    }
}

// MARK: - Private Methods
private extension MyPageMenuCollectionViewCell {
    func setupViews() {
        addSubview(textLabel)
    }
    
    func setupLayoutConstraints() {
        textLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
        }
    }
}
