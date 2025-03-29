import UIKit
import TDDesign

final class ShowIdViewController: BaseViewController<BaseView> {
    // MARK: UI Components
    private let infoLabel1 = TDLabel(
        labelText: "회원님의 아이디는",
        toduckFont: .mediumHeader3,
        toduckColor: TDColor.Neutral.neutral800
    )
    private let resultStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
        $0.alignment = .center
    }
    private let userIdLabel = TDLabel(
        toduckFont: .mediumHeader3,
        toduckColor: TDColor.Primary.primary500
    )
    private let infoLabel2 = TDLabel(
        labelText: "입니다.",
        toduckFont: .mediumHeader3,
        toduckColor: TDColor.Neutral.neutral800
    )
    private let confirmButton = TDBaseButton(
        title: "확인",
        backgroundColor: TDColor.Primary.primary500,
        foregroundColor: TDColor.baseWhite,
        radius: 12,
        font: TDFont.boldHeader3.font
    )
    
    // MARK: Properties
    weak var coordinator: FindAccountCoordinator?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    override func addView() {
        layoutView.addSubview(infoLabel1)
        resultStackView.addArrangedSubview(userIdLabel)
        resultStackView.addArrangedSubview(infoLabel2)
        layoutView.addSubview(resultStackView)
        layoutView.addSubview(confirmButton)
    }
    
    override func layout() {
        infoLabel1.snp.makeConstraints {
            $0.top.equalToSuperview().offset(80)
            $0.centerX.equalToSuperview()
        }
        
        resultStackView.snp.makeConstraints {
            $0.top.equalTo(infoLabel1.snp.bottom)
            $0.centerX.equalToSuperview()
        }
        
        confirmButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(48)
        }
    }
    
    override func configure() {
        confirmButton.addAction(UIAction { [weak self] _ in
            self?.coordinator?.finish(by: .pop)
        }, for: .touchUpInside)
    }
    
    func setUserId(with id: String) {
        userIdLabel.text = id
    }
}
