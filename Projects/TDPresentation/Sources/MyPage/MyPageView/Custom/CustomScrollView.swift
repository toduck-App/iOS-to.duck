//
//  CustomScrollView.swift
//  TDPresentation
//
//  Created by 정지용 on 1/16/25.
//

import UIKit

final class CustomScrollView: UIScrollView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if !self.isDragging && !self.isDecelerating {
            self.next?.touchesBegan(touches, with: event)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        if !self.isDragging && !self.isDecelerating {
            self.next?.touchesEnded(touches, with: event)
        }
    }
}
