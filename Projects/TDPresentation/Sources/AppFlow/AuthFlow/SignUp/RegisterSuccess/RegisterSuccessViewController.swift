import UIKit
import SnapKit
import Then
import TDDesign

final class RegisterSuccessViewController: BaseViewController<BaseView> {
    // MARK: - UI Components
    private let backGroundImageView = UIImageView(image: TDImage.loginBackGround)
    private let logoImageView = UIImageView(image: TDImage.registerSuccess)
    private let titleLabel = TDLabel(
        labelText: "가입을 축하드려요!",
        toduckFont: .boldHeader2,
        toduckColor: TDColor.Neutral.neutral800
    )
    private let subTitleLabel = TDLabel(
        labelText: "토덕과 함께 더 나은 하루를 만들어봐요",
        toduckFont: .regularBody3,
        toduckColor: TDColor.Neutral.neutral700
    )
    private let startButton = TDBaseButton(
        title: "시작하기",
        backgroundColor: TDColor.Primary.primary500,
        foregroundColor: TDColor.baseWhite,
        radius: 12,
        font: TDFont.boldHeader3.font
    )
    
    // MARK: - Properties
    weak var coordinator: RegisterSuccessCoordinator?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    override func addView() {
        view.addSubview(backGroundImageView)
        view.addSubview(logoImageView)
        view.addSubview(titleLabel)
        view.addSubview(subTitleLabel)
        view.addSubview(startButton)
    }
    
    override func layout() {
        backGroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        logoImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(240)
            $0.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom).offset(46)
            $0.centerX.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
        }
        
        startButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-28)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(48)
        }
    }
    
    override func configure() {
        startButton.addAction(UIAction { [weak self] _ in
            self?.coordinator?.notifyRegistrationSuccess()
        }, for: .touchUpInside)
    }
}
