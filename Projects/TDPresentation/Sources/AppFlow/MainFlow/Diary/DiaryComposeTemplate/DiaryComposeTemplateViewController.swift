import UIKit
import SnapKit
import Then
import TDDesign

final class DiaryComposeTemplateViewController: BaseViewController<DiaryComposeTemplateView> {
    
    // MARK: - UI Components
    
    let navigationProgressView = NavigationProgressView()
    
    let pageLabel = TDLabel(
        labelText: "1 / 3",
        toduckFont: .mediumHeader4,
        toduckColor: TDColor.Neutral.neutral600,
    )
    
    // MARK: - Properties
    
    weak var coordinator: DiaryComposeTemplateCoordinator?
    
    // MARK: - Life Cycle
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeProgressViewFromNavigationBar()
    }
    
    // MARK: - Common Methods
    
    override func configure() {
        configurePagingNavigationBar(currentPage: 1, totalPages: 3)
    }
}

// MARK: - PagingNavigationBarConfigurable

extension DiaryComposeTemplateViewController: PagingNavigationBarConfigurable { }
