//
//  CustomEventWrapper.swift
//  TDPresentation
//
//  Created by 정지용 on 1/16/25.
//

import UIKit

enum ResponderEventType {
    case profileImageTapped
    case unknown
}

final class CustomEventWrapper: UIEvent {
    let customType: ResponderEventType
    
    init(event: UIEvent?, type customType: ResponderEventType) {
        self.customType = customType
        super.init()
    }
}
