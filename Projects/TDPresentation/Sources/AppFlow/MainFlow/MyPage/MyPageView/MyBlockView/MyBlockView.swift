import UIKit
import TDDesign

final class MyBlockView: BaseView {
    let blockTableView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout().then {
            $0.scrollDirection = .vertical
            $0.minimumInteritemSpacing = 0
        }
    ).then {
        $0.backgroundColor = TDColor.baseWhite
        $0.isScrollEnabled = true
    }
    
    let emptyView = UIView().then {
        $0.backgroundColor = TDColor.baseWhite
        $0.isHidden = true
    }
    
    let emptyLabel = TDLabel(
        labelText: "차단한 사용자가 없어요.",
        toduckFont: .mediumHeader5,
        toduckColor: TDColor.Neutral.neutral500
    )
    
    override func addview() {
        addSubview(blockTableView)
        addSubview(emptyView)
        emptyView.addSubview(emptyLabel)
    }
    
    override func configure() {
        backgroundColor = TDColor.Neutral.neutral100
        blockTableView.register(with: MyBlockCell.self)
    }
    
    override func layout() {
        blockTableView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
        
        emptyView.snp.makeConstraints { make in
            make.edges.equalTo(blockTableView)
        }
        
        emptyLabel.snp.makeConstraints { make in
            make.center.equalTo(emptyView)
        }
    }
    
    func showEmptyView() {
        emptyView.isHidden = false
        blockTableView.isHidden = true
    }
}
