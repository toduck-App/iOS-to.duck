import UIKit
import SnapKit
import Then
import TDDesign
import AuthenticationServices

final class AuthView: BaseView {
    // MARK: - UI Components
    let backGroundImageView = UIImageView(image: TDImage.loginBackGround)
    let mainButton = TDBaseButton(title: "메인 홈으로 가기")

    /// 토덕 로고
    let toduckLogoView = UIImageView(image: TDImage.toduckPrimaryLogo)
    let toduckTitleLabel = TDLabel(
        labelText: "ADHD 토덕과 함께 극복해요",
        toduckFont: TDFont.mediumBody3,
        alignment: .center,
        toduckColor: TDColor.Primary.primary400
    )
    let toduckView = UIImageView(image: TDImage.loginToduck)

    /// Oauth 로그인
    let kakaoLoginButton = TDBaseButton(
        title: "카카오로 로그인",
        image: TDImage.Logo.kakaoLogo,
        backgroundColor: TDColor.Oauth.kakaoBackground,
        foregroundColor: TDColor.Oauth.kakaoForeground,
        radius: 8,
        font: TDFont.mediumBody1.font
    )
    let appleLoginButton = ASAuthorizationAppleIDButton()

    /// 자체 로그인/회원가입
    let signInButton = UIButton().then {
        $0.setTitleColor(TDColor.Neutral.neutral800, for: .normal)
        $0.setTitle("로그인", for: .normal)
        $0.titleLabel?.font = TDFont.mediumHeader5.font
    }
    private let separatorView = UIView()
    let signUpButton = UIButton().then {
        $0.setTitleColor(TDColor.Neutral.neutral800, for: .normal)
        $0.setTitle("회원가입", for: .normal)
        $0.titleLabel?.font = TDFont.mediumHeader5.font
    }

    // MARK: - Setup Methods
    override func addview() {
        [
            backGroundImageView,
            mainButton,
            toduckLogoView,
            toduckTitleLabel,
            toduckView,
            kakaoLoginButton,
            appleLoginButton,
            signInButton,
            separatorView,
            signUpButton
        ].forEach { addSubview($0) }

    }

    override func layout() {
        backGroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        toduckLogoView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(Layout.topOffset)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(Layout.logoWidth)
            $0.height.equalTo(Layout.logoHeight)
        }
        toduckTitleLabel.snp.makeConstraints {
            $0.top.equalTo(toduckLogoView.snp.bottom).offset(Layout.titleTopOffset)
            $0.centerX.equalToSuperview()
        }
        toduckView.snp.makeConstraints {
            $0.top.equalTo(toduckTitleLabel.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }

        /// Oauth 로그인
        kakaoLoginButton.snp.makeConstraints {
            $0.top.equalTo(toduckView.snp.bottom).offset(Layout.loginButtonTopOffset)
            $0.leading.equalToSuperview().offset(Layout.loginButtonSideInset)
            $0.trailing.equalToSuperview().offset(-Layout.loginButtonSideInset)
            $0.height.equalTo(44)
        }
        appleLoginButton.snp.makeConstraints {
            $0.top.equalTo(kakaoLoginButton.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(Layout.loginButtonSideInset)
            $0.trailing.equalToSuperview().offset(-Layout.loginButtonSideInset)
            $0.height.equalTo(44)
        }
        
        // TODO: 제거
        mainButton.snp.makeConstraints {
            $0.top.equalTo(appleLoginButton.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(Layout.loginButtonSideInset)
            $0.trailing.equalToSuperview().offset(-Layout.loginButtonSideInset)
            $0.height.equalTo(44)
        }

        /// 자체 로그인/회원가입
        signInButton.snp.makeConstraints {
            $0.centerY.equalTo(separatorView)
            $0.trailing.equalTo(separatorView.snp.leading).offset(-Layout.lineSpacing)
            $0.height.equalTo(Layout.buttonHeight)
        }

        separatorView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(Layout.separatorBottomOffset)
            $0.width.equalTo(Layout.separatorWidth)
            $0.height.equalTo(Layout.separatorHeight)
        }

        signUpButton.snp.makeConstraints {
            $0.centerY.equalTo(separatorView)
            $0.leading.equalTo(separatorView.snp.trailing).offset(Layout.lineSpacing)
            $0.height.equalTo(Layout.buttonHeight)
        }
    }

    override func configure() {
        backGroundImageView.contentMode = .scaleAspectFill
        separatorView.backgroundColor = TDColor.Neutral.neutral800
        setupKakaoLoginButton()
    }
    
    private func setupKakaoLoginButton() {
        let kakaoLogo = UIImage.resizedImage(
            image: TDImage.Logo.kakaoLogo,
            size: CGSize(width: 14, height: 14)
        )
        kakaoLoginButton.setImage(kakaoLogo, for: .normal)
    }
}

extension AuthView {
    enum Layout {
        static let topOffset: CGFloat = 60
        static let logoWidth: CGFloat = 160
        static let logoHeight: CGFloat = 40
        static let titleTopOffset: CGFloat = 12
        static let descriptionTopOffset: CGFloat = 24
        static let descriptionInset: CGFloat = 16
        static let lineSpacing: CGFloat = 12
        static let lineWidth: CGFloat = 62
        static let lineHeight: CGFloat = 1
        static let loginButtonTopOffset: CGFloat = 20
        static let loginButtonSideInset: CGFloat = 60
        static let separatorBottomOffset: CGFloat = -40
        static let separatorWidth: CGFloat = 1
        static let separatorHeight: CGFloat = 12
        static let buttonHeight: CGFloat = 16
    }
}
