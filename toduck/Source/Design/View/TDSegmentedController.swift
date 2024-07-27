//
//  TDSegmentedController.swift
//  toduck
//
//  Created by 박효준 on 7/28/24.
//

import UIKit

import SnapKit
import Then

final class TDSegmentedController: UISegmentedControl {
    private var indicatorView = UIView().then {
        $0.backgroundColor = TDColor.Neutral.neutral800
    }
    
    override init(items: [Any]?) {
        super.init(items: items)
        setSegmentedControl()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setSegmentedControl()
    }
    
    private func setSegmentedControl() {
        selectedSegmentIndex = 0
        addSubview(indicatorView)
        addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        
        setSegmentedImage()
        setSegmentedFont()
        layout()
    }
    
    private func setSegmentedImage() {
        // 세그먼트 컨트롤 외형 커스터마이징
        setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        setBackgroundImage(UIImage(), for: .selected, barMetrics: .default)
        setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
    }
    
    private func setSegmentedFont() {
        // 선택안된 버튼의 폰트 & 색상 설정
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: TDColor.Neutral.neutral500,
            .font: TDFont.boldHeader5.font
        ]
        setTitleTextAttributes(normalAttributes, for: .normal)
        
        // 선택된 버튼의 폰트 & 색상 설정
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: TDColor.Neutral.neutral800,
            .font: TDFont.boldHeader5.font
        ]
        setTitleTextAttributes(selectedAttributes, for: .selected)
    }
    
    private func layout() {
        indicatorView.snp.makeConstraints {
            $0.top.equalTo(self.snp.bottom).offset(-1)
            $0.height.equalTo(1.5)
            $0.width.equalTo(self.snp.width).dividedBy(self.numberOfSegments)
            $0.leading.equalTo(self.snp.leading)
        }
    }
    
    private func updateIndicatorPosition(animated: Bool) {
        let segmentWidth = frame.width / CGFloat(numberOfSegments)
        let leadingDistance = segmentWidth * CGFloat(selectedSegmentIndex)
        
        // 애니메이션 여부에 따라 위치 업데이트
        if animated {
            UIView.animate(withDuration: 0.3) {
                self.indicatorView.snp.updateConstraints {
                    $0.leading.equalTo(self.snp.leading).offset(leadingDistance)
                }
                self.layoutIfNeeded()
            }
        } else {
            indicatorView.snp.updateConstraints {
                $0.leading.equalTo(self.snp.leading).offset(leadingDistance)
            }
            layoutIfNeeded()
        }
    }
    
    @objc func segmentChanged() {
        updateIndicatorPosition(animated: true)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateIndicatorPosition(animated: false)
    }
}