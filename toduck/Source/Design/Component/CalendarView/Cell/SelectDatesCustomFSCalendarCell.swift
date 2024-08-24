//
//  SelectDatesCustomFSCalendarCell.swift
//  toduck
//
//  Created by 박효준 on 8/25/24.
//

import FSCalendar
import SnapKit
import Then

final class SelectDatesCustomFSCalendarCell: FSCalendarCell {
    let circleBackImageView = UIImageView()
    let leftRectBackImageView = UIImageView()
    let rightRectBackImageView = UIImageView()
    
    override init!(frame: CGRect) {
        super.init(frame: frame)
        
        setConfigure()
        setConstraints()
        settingImageView()
    }
    
    required init!(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
        
        setConfigure()
        setConstraints()
        settingImageView()
    }
    
    private func setConfigure() {
        
    }
    private func setConstraints() {
        
    }
    private func settingImageView() {
        
    }
}
