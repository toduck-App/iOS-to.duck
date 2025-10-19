import UIKit
import TDDesign

/// 페이징 형태의 커스텀 네비게이션 바를 설정하기 위한 프로토콜
protocol PagingNavigationBarConfigurable: AnyObject {
    var navigationProgressView: NavigationProgressView { get }
    var pageLabel: TDLabel { get }
}

extension PagingNavigationBarConfigurable where Self: UIViewController {
    
    /// 페이징 네비게이션 바를 설정합니다.
    /// - Parameters:
    ///   - currentPage: 현재 페이지 번호 (1부터 시작)
    ///   - totalPages: 전체 페이지 수
    ///   - highlightColor: 현재 페이지 번호에 적용할 하이라이트 색상 (기본값: Primary500)
    func configurePagingNavigationBar(
        currentPage: Int,
        totalPages: Int,
        highlightColor: UIColor = TDColor.Primary.primary500
    ) {
        navigationItem.title = ""
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: pageLabel)
        
        let pageString = "\(currentPage)"
        let totalString = "/ \(totalPages)"
        pageLabel.setText(pageString + " " + totalString)
        pageLabel.highlight(tokens: [pageString], color: highlightColor)
        
        guard let navigationBar = navigationController?.navigationBar else { return }
        
        navigationBar.addSubview(navigationProgressView)
        navigationProgressView.snp.makeConstraints {
            let margins = navigationBar.layoutMarginsGuide
            
            $0.leading.equalTo(margins).offset(60)
            $0.trailing.equalTo(margins).offset(-75)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(8)
        }
        
        let progress = totalPages > 0 ? Float(currentPage) / Float(totalPages) : 0
        navigationProgressView.configure(progress: progress)
    }
    
    func removeProgressViewFromNavigationBar() {
        navigationProgressView.removeFromSuperview()
    }
}
