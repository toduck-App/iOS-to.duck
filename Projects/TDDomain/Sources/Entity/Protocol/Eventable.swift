//
//  Eventable.swift
//  TDDomain
//
//  Created by 박효준 on 12/23/24.
//

import Foundation

public protocol Eventable {
    var id: UUID { get }
    var title: String { get }
    var category: TDCategory { get }
    var time: Date? { get }
    var isFinish: Bool { get }
}
