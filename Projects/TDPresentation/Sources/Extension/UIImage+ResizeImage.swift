//
//  UIImage+ResizeImage.swift
//  TDPresentation
//
//  Created by 정지용 on 1/15/25.
//

import UIKit

extension UIImage {
    func resizeImage<T: UIImage>(targetSize: CGSize) -> T {
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        } as! T
    }
}
