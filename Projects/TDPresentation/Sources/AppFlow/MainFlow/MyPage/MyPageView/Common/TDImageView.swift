//
//  TDImageView.swift
//  TDPresentation
//
//  Created by 정지용 on 1/16/25.
//

import UIKit
import SnapKit

import TDDesign

final class TDImageView: BaseView {
    let innerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = TDImage.Profile.large
        return imageView
    }()
    
    private let outerImageContainer: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        view.backgroundColor = TDColor.Primary.primary500
        view.layer.borderWidth = LayoutConstants.imageBorderWidth
        view.layer.borderColor = TDColor.baseWhite.cgColor
        return view
    }()
    
    private let outerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = TDImage.Pen.penMediumColor
        return imageView
    }()
    
    override func addview() {
        [innerImageView, outerImageContainer].forEach(addSubview)
        outerImageContainer.addSubview(outerImageView)
    }
    
    override func layout() {
        innerImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.height.equalToSuperview()
        }
        
        outerImageContainer.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview()
            $0.width.height.equalTo(LayoutConstants.zero)
        }
        
        outerImageView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.width.height.equalTo(LayoutConstants.zero)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        outerImageContainer.snp.updateConstraints {
            $0.width.height.equalTo(bounds.width / 3)
        }
        
        outerImageView.snp.updateConstraints {
            $0.width.height.equalTo(bounds.width / 5)
        }
        
        if (innerImageView.layer.cornerRadius != innerImageView.bounds.width / 2) ||
            (outerImageContainer.layer.cornerRadius != outerImageContainer.bounds.width / 2) {
            innerImageView.layer.cornerRadius = innerImageView.bounds.width / 2
            outerImageContainer.layer.cornerRadius = outerImageContainer.bounds.width / 2
        }
    }

    func configureImage(
        inner: UIImage,
        outer: UIImage
    ) {
        innerImageView.image = inner
        outerImageView.image = outer
    }
}

private extension TDImageView {
    enum LayoutConstants {
        static let imageBorderWidth: CGFloat = 1
        static let zero: CGFloat = 0
    }
}
