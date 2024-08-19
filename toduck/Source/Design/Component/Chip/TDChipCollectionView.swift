import UIKit

struct chipItem {
    let title: String
    let type: TDChipType
}

protocol TDChipCollectionViewDelegate: AnyObject {
    func chipCollectionView(_ collectionView: TDChipCollectionView, didSelectChipAt index: Int, chipText: String)
}

class TDChipCollectionView: UICollectionView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    private var chips: [chipItem] = []
    private var selectedStates: [Bool] = []
    private var defaultChipType: TDChipType
    private var hasAllSelectChip: Bool = false
    weak var chipDelegate: TDChipCollectionViewDelegate?
    
    init(chipType: TDChipType, hasAllSelectChip: Bool = false) {
        self.hasAllSelectChip = hasAllSelectChip
        self.defaultChipType = chipType
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        super.init(frame: .zero, collectionViewLayout: layout)

        self.backgroundColor = TDColor.baseWhite
        self.delegate = self
        self.dataSource = self
        self.register(with: TDChipCell.self)
        self.showsHorizontalScrollIndicator = false
        self.allowsSelection = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setChips(_ chipTexts: [String]) {
        
        self.chips = chipTexts.map { chipItem(title: $0, type: defaultChipType) }
        self.selectedStates = Array(repeating: false, count: chipTexts.count)
        if hasAllSelectChip {
            self.chips.insert(chipItem(title: "전체", type: defaultChipType), at: 0)
            self.selectedStates.insert(false, at: 0)
        }
        self.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chips.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: TDChipCell = collectionView.dequeueReusableCell(for: indexPath)
        let chip = chips[indexPath.item]
        let isActive = selectedStates[indexPath.item]
        cell.configure(title: chip.title, chipType: chip.type, isActive: isActive)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = chips[indexPath.item].title
        let width = (text as NSString).size(withAttributes: [NSAttributedString.Key.font: TDFont.regularBody2.font]).width
        return CGSize(width: width + 24, height: chips[indexPath.item].type.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if hasAllSelectChip {
            switch indexPath.item {
            case selectedStates.startIndex:
                selectedStates = Array(repeating: !selectedStates[0], count: chips.count)
            default:
                selectedStates[indexPath.item].toggle()
                if selectedStates[indexPath.item] == false { selectedStates[0] = false }
                if (selectedStates[1...].allSatisfy{ $0 == true }) {
                    selectedStates[0] = true
                }
            }
        } else {
            selectedStates[indexPath.item].toggle()
        }
        
        if let cell = collectionView.cellForItem(at: indexPath) as? TDChipCell {
            cell.toggle()
            let chip = chips[indexPath.item]
            chipDelegate?.chipCollectionView(self, didSelectChipAt: indexPath.item, chipText: chip.title)
        }
        
        self.reloadData()
    }
}
