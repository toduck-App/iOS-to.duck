import UIKit
import SnapKit

protocol DropDownDelegate: AnyObject {
    func dropDown(_ dropDownView: DropDownView, didSelectRowAt indexPath: IndexPath)
}

final class DropDownView: UIView {
    private enum DropDownMode {
        case display
        case hide
    }
    
    // MARK: - Properties
    weak var delegate: DropDownDelegate?
    
    private var dropDownConstraints: ((ConstraintMaker) -> Void)?
    var isDisplayed: Bool {
        get { dropDownMode == .display }
        set { newValue ? becomeFirstResponder() : resignFirstResponder() }
    }
    
    private var dropDownMode: DropDownMode = .hide
    var dataSource = [String]() {
        didSet { dropDownTableView.reloadData() }
    }
    
    private(set) var selectedOption: String?
    override var canBecomeFirstResponder: Bool { true }
    
    private let anchorView: UIView
    fileprivate let dropDownTableView = DropDownTableView()
    
    init(anchorView: UIView) {
        self.anchorView = anchorView
        super.init(frame: .zero)
        
        dropDownTableView.dataSource = self
        dropDownTableView.delegate = self
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if dropDownMode == .display {
            resignFirstResponder()
        } else {
            becomeFirstResponder()
        }
    }
    
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        dropDownMode = .display
        displayDropDown(with: dropDownConstraints)
        return true
    }
    
    @discardableResult
    override func resignFirstResponder() -> Bool {
        super.resignFirstResponder()
        dropDownMode = .hide
        hideDropDown()
        return true
    }
}

// MARK: - UI Methods
private extension DropDownView {
    func setupUI() {
        self.addSubview(anchorView)
        anchorView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        setConstraints {
            $0.leading.trailing.equalTo(self.anchorView)
            $0.top.equalTo(self.anchorView.snp.bottom)
        }
    }
}

// MARK: - DropDown Logic
extension DropDownView {
    func displayDropDown(with constraints: ((ConstraintMaker) -> Void)?) {
        guard let constraints = constraints else { return }
        window?.addSubview(dropDownTableView)
        dropDownTableView.snp.makeConstraints(constraints)
    }
    
    func hideDropDown() {
        dropDownTableView.removeFromSuperview()
        dropDownTableView.snp.removeConstraints()
    }
    
    func setConstraints(_ closure: @escaping (_ make: ConstraintMaker) -> Void) {
        self.dropDownConstraints = closure
    }
}

// MARK: - UITableViewDataSource
extension DropDownView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: DropDownCell.identifier,
            for: indexPath
        ) as? DropDownCell else {
            return UITableViewCell()
        }
        
        if let selectedOption = self.selectedOption, selectedOption == dataSource[indexPath.row] {
            cell.isSelected = true
        }
        
        cell.configure(with: dataSource[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate
extension DropDownView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedOption = dataSource[indexPath.row]
        delegate?.dropDown(self, didSelectRowAt: indexPath)
        dropDownTableView.selectRow(at: indexPath)
        resignFirstResponder()
    }
}
