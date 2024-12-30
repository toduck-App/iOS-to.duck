//
//  ToduckCalendarDateCell.swift
//  TDDesign
//
//  Created by 박효준 on 10/21/24.
//

import FSCalendar
import SnapKit
import Then

public final class ToduckCalendarDateCell: FSCalendarCell {
    public let eventLabel1 = UILabel()
    public let eventLabel2 = UILabel()
    public let eventLabel3 = UILabel()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        setConstraints()
    }

    @available(*, unavailable)
    public required init(coder: NSCoder) {
        super.init(coder: coder)
        setUpViews()
        setConstraints()
    }

    private func setUpViews() {
        [eventLabel1, eventLabel2, eventLabel3].forEach { label in
            contentView.addSubview(label)
            label.font = UIFont.systemFont(ofSize: 10)
            label.textColor = .gray
            label.textAlignment = .center
            label.isHidden = true // 기본적으로 숨김 처리
        }
    }

    private func setConstraints() {
        eventLabel1.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(4)
            $0.centerX.equalTo(contentView)
        }

        eventLabel2.snp.makeConstraints {
            $0.top.equalTo(eventLabel1.snp.bottom).offset(2)
            $0.centerX.equalTo(contentView)
        }

        eventLabel3.snp.makeConstraints {
            $0.top.equalTo(eventLabel2.snp.bottom).offset(2)
            $0.centerX.equalTo(contentView)
//            $0.bottom.lessThanOrEqualTo(contentView).offset(-4)
        }
    }

    public func updateEventLabels(texts: [String?]) {
        // 최대 3개의 텍스트를 설정
        let labels = [eventLabel1, eventLabel2, eventLabel3]

        for (index, text) in texts.enumerated() {
            if index < labels.count {
                labels[index].text = text
                labels[index].isHidden = (text == nil)
            }
        }
    }
}
