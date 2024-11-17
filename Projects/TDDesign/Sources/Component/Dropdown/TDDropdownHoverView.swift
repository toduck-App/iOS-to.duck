import UIKit
import SnapKit

public protocol TDDropDownDelegate: AnyObject {
    func dropDown(_ dropDownView: TDDropdownHoverView, didSelectRowAt indexPath: IndexPath)
}

public final class TDDropdownHoverView: UIView {
    // MARK: - Nested Type

    private enum DropDownMode {
        case display
        case hide
    }

    public enum LocateLayout {
        case leading
        case trailing
    }

    // MARK: - Properties

    private let containerView = UIView()
    private let dropDownTableView = DropDownTableView()
    private var dropDownConstraints: ((ConstraintMaker) -> Void)?
    private var dropDownMode: DropDownMode = .hide
    private var locate: LocateLayout = .leading
    private(set) var selectedOption: String?
    private var width: CGFloat = 0
    private let anchorView: UIView
    private lazy var overlayView = UIView().then {
        $0.backgroundColor = UIColor.clear
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleOverlayTap(_:)))
        tapGesture.cancelsTouchesInView = false 
        $0.addGestureRecognizer(tapGesture)
    }

    public override var canBecomeFirstResponder: Bool { true }
    public var dataSource = [TDDropdownItem]() {
        didSet { dropDownTableView.reloadData() }
    }

    public weak var delegate: TDDropDownDelegate?

    // MARK: - Initializer

    public init(anchorView: UIView, selectedOption: String? = nil, layout: LocateLayout, width: CGFloat) {
        self.anchorView = anchorView
        self.selectedOption = selectedOption
        self.locate = layout
        self.width = width
        super.init(frame: anchorView.frame)
        dropDownTableView.dataSource = self
        dropDownTableView.delegate = self

        setupUI()
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if dropDownMode == .display {
            resignFirstResponder()
        } else {
            becomeFirstResponder()
        }
    }

    @discardableResult
    public override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        dropDownMode = .display
        displayDropDown(with: dropDownConstraints)
        return true
    }

    @discardableResult
    public override func resignFirstResponder() -> Bool {
        super.resignFirstResponder()
        dropDownMode = .hide
        hideDropDown()
        return true
    }
}

private extension TDDropdownHoverView {
    func setupUI() {
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        containerView.layer.shadowRadius = 10
        containerView.layer.cornerRadius = 12
        containerView.backgroundColor = .clear
        containerView.addSubview(dropDownTableView)

        dropDownTableView.layer.cornerRadius = 8
        dropDownTableView.layer.masksToBounds = true
        dropDownTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        self.addSubview(anchorView)

        self.snp.makeConstraints {
            $0.edges.equalTo(anchorView)
        }

        if locate == .leading {
            setConstraints {
                $0.leading.equalTo(self.anchorView)
                $0.width.equalTo(self.width)
                $0.top.equalTo(self.anchorView.snp.bottom)
            }
        } else if locate == .trailing {
            setConstraints {
                $0.trailing.equalTo(self.anchorView.snp.trailing)
                $0.width.equalTo(self.width)
                $0.top.equalTo(self.anchorView.snp.bottom)
            }
        }
    }

    @objc func handleOverlayTap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: containerView)
        if !containerView.bounds.contains(location) {
            resignFirstResponder()
        }
    }
}

// MARK: - DropDown Logic
public extension TDDropdownHoverView {
    func displayDropDown(with constraints: ((ConstraintMaker) -> Void)?) {
        guard let constraints = constraints else { return }
        if let window = window {
            window.addSubview(overlayView)
            overlayView.snp.makeConstraints { $0.edges.equalToSuperview() }

            overlayView.addSubview(containerView)
            containerView.snp.makeConstraints(constraints)
        }
    }

    func hideDropDown() {
        containerView.removeFromSuperview()
        overlayView.removeFromSuperview()
    }

    func setConstraints(_ closure: @escaping (_ make: ConstraintMaker) -> Void) {
        self.dropDownConstraints = closure
    }
}

// MARK: - UITableViewDataSource
extension TDDropdownHoverView: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: DropDownCell.identifier,
            for: indexPath
        ) as? DropDownCell else {
            return UITableViewCell()
        }

        if let selectedOption = self.selectedOption, selectedOption == dataSource[indexPath.row].title {
            cell.isSelected = true
        }

        cell.configure(with: dataSource[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate
extension TDDropdownHoverView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedOption = dataSource[indexPath.row].title
        delegate?.dropDown(self, didSelectRowAt: indexPath)
        dropDownTableView.selectRow(at: indexPath)
        resignFirstResponder()
    }
}
