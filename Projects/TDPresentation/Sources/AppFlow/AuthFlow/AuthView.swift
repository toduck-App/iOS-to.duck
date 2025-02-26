import UIKit
import SnapKit
import Then
import TDDesign
import AuthenticationServices

final class AuthView: BaseView {
    // MARK: - UI Components
    let onboardingButton = UIButton().then {
        $0.setTitleColor(TDColor.Primary.primary500, for: .normal)
        $0.setTitle("둘러보기", for: .normal)
        $0.titleLabel?.font = TDFont.mediumHeader5.font
    }

    let mainButton = TDBaseButton(title: "메인 홈으로 가기")

    /// 토덕 로고
    let toduckLogoView = UIImageView(image: TDImage.toduckLogo.withRenderingMode(.alwaysTemplate)).then {
        $0.tintColor = TDColor.Primary.primary500
    }
    let toduckTitleLabel = TDLabel(
        labelText: "ADHD 토덕과 함께 극복해요",
        toduckFont: TDFont.mediumBody3,
        alignment: .center,
        toduckColor: TDColor.Primary.primary400
    )
    let toduckView = UIImageView(image: TDImage.loginToduck)

    /// Oauth 로그인
    private let oauthDescriptionContainerView = UIView()
    private let horizontalDummyView1 = UIView()
    private let oauthLoginDescriptionLabel = TDLabel(
        labelText: "3초만에 간편 가입하기",
        toduckFont: TDFont.mediumBody3,
        alignment: .center,
        toduckColor: TDColor.Primary.primary500
    )
    private let horizontalDummyView2 = UIView()
    let appleLoginButton = ASAuthorizationAppleIDButton()

    /// 자체 로그인/회원가입
    let signInButton = UIButton().then {
        $0.setTitleColor(TDColor.Primary.primary500, for: .normal)
        $0.setTitle("로그인", for: .normal)
        $0.titleLabel?.font = TDFont.mediumHeader5.font
    }
    private let separatorView = UIView()
    let signUpButton = UIButton().then {
        $0.setTitleColor(TDColor.Primary.primary500, for: .normal)
        $0.setTitle("회원가입", for: .normal)
        $0.titleLabel?.font = TDFont.mediumHeader5.font
    }

    // MARK: - Setup Methods
    override func addview() {
        [
            mainButton,
            onboardingButton,
            toduckLogoView,
            toduckTitleLabel,
            toduckView,
            oauthDescriptionContainerView,
            appleLoginButton,
            signInButton,
            separatorView,
            signUpButton
        ].forEach { addSubview($0) }

        oauthDescriptionContainerView.addSubview(horizontalDummyView1)
        oauthDescriptionContainerView.addSubview(oauthLoginDescriptionLabel)
        oauthDescriptionContainerView.addSubview(horizontalDummyView2)
    }

    override func layout() {
        onboardingButton.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.trailing.equalToSuperview().offset(-Layout.descriptionInset)
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
            $0.top.equalTo(toduckTitleLabel.snp.bottom).offset(Layout.viewTopOffset)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }

        /// Oauth 로그인
        oauthDescriptionContainerView.snp.makeConstraints {
            $0.top.equalTo(toduckView.snp.bottom).offset(Layout.descriptionTopOffset)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(Layout.descriptionInset)
        }
        horizontalDummyView1.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(oauthLoginDescriptionLabel.snp.leading).offset(-Layout.lineSpacing)
            $0.width.equalTo(Layout.lineWidth)
            $0.height.equalTo(Layout.lineHeight)
        }
        oauthLoginDescriptionLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        horizontalDummyView2.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(oauthLoginDescriptionLabel.snp.trailing).offset(Layout.lineSpacing)
            $0.width.equalTo(Layout.lineWidth)
            $0.height.equalTo(Layout.lineHeight)
        }
        appleLoginButton.snp.makeConstraints {
            $0.top.equalTo(oauthDescriptionContainerView.snp.bottom).offset(Layout.loginButtonTopOffset)
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
        [horizontalDummyView1, horizontalDummyView2, separatorView].forEach {
            $0.backgroundColor = TDColor.Primary.primary500
        }
    }
}

extension AuthView {
    enum Layout {
        static let topOffset: CGFloat = 80
        static let logoWidth: CGFloat = 160
        static let logoHeight: CGFloat = 40
        static let titleTopOffset: CGFloat = 12
        static let viewTopOffset: CGFloat = 20
        static let descriptionTopOffset: CGFloat = 24
        static let descriptionInset: CGFloat = 16
        static let lineSpacing: CGFloat = 12
        static let lineWidth: CGFloat = 62
        static let lineHeight: CGFloat = 1
        static let loginButtonTopOffset: CGFloat = 30
        static let loginButtonSideInset: CGFloat = 60
        static let separatorBottomOffset: CGFloat = -20
        static let separatorWidth: CGFloat = 1
        static let separatorHeight: CGFloat = 12
        static let buttonHeight: CGFloat = 16
    }
}
