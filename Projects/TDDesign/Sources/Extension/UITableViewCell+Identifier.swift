//
//  UITableViewCell+Identifier.swift
//  TDDesign
//
//  Created by 박효준 on 11/14/24.
//

import UIKit

public extension UITableViewCell {
    static var identifier: String {
        String(describing: self)
    }
}
