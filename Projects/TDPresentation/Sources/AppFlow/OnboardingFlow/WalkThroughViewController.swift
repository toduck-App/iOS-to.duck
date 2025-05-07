import UIKit
import TDDesign

final class WalkThroughViewController: BaseViewController<WalkThroughView> {
    weak var coordinator: WalkThroughCoordinator?
    
    /// 워크쓰루 페이지 데이터
    private let pages: [(image: UIImage, title: String, description: String, buttonTitle: String)] = [
        (TDImage.Walkthrough.first, "토덕과 함께\n나만의 루틴을 만들어요", "하루 일정과 루틴을 정리하고, 집중해봐요.", "다음"),
        (TDImage.Walkthrough.second, "이야기를 나누고\n루틴을 공유해보세요", "혼자 고민하지 않아도 괜찮아요!\n서로의 일상과 마음을 나눠봐요.", "다음"),
        (TDImage.Walkthrough.third, "더 나은 내일을 위해\n하루를 돌아보며 기록해요", "간단한 기록으로 매일을 복기해봐요.", "토덕 시작하기")
    ]
    
    /// 현재 페이지 인덱스
    private var currentPage = 0 {
        didSet {
            layoutView.setCurrentPage(currentPage)
            layoutView.illustrationImageView.image = pages[currentPage].image
            layoutView.titleLabel.setText(pages[currentPage].title)
            layoutView.descriptionLabel.setText(pages[currentPage].description)
            layoutView.actionButton.setTitle(pages[currentPage].buttonTitle, for: .normal)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentPage = 0
        
        layoutView.actionButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
    }
    
    @objc private func didTapNext() {
        if currentPage < pages.count - 1 {
            currentPage += 1
        } else {
            // 마지막 페이지라면 코디네이터에게 종료 알림
            coordinator?.finishDelegate?.didFinish(childCoordinator: coordinator!)
        }
    }
}
