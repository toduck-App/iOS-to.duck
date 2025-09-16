//
//  Widget+Constant.swift
//  TDCore
//
//  Created by 승재 on 8/10/25.
//

public enum WidgetConstant {
    case diary
    
    public var kindIdentifier: String {
        switch self {
        case .diary:
            return "DiaryWidget"
        }
    }
}
