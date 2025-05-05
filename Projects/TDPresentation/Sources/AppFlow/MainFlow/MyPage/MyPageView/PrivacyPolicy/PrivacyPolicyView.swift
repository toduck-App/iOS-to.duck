import SnapKit
import TDDesign
import UIKit

final class PrivacyPolicyView: BaseView {
    private let mainLabel = TDLabel(
        toduckFont: .boldHeader3,
        toduckColor: TDColor.Neutral.neutral800
    ).then {
        $0.setText("토덕 개인정보 처리방침")
    }
    
    private let mainDescription = TDLabel(
        toduckFont: .regularBody2,
        toduckColor: TDColor.Neutral.neutral700
    ).then {
        $0.setText("토덕은 이용자의 개인정보를 보호하고 이와 관련된 고충을 신속하고 원활하게 처리할 수 있도록 다음과 같이 개인정보 처리 방침을 수립 및 공개합니다.")
        $0.numberOfLines = 0
        $0.setLineHeightMultiple(1.5)
    }

    private let scrollView = UIScrollView().then {
        $0.backgroundColor = TDColor.baseWhite
        $0.isDirectionalLockEnabled = true
    }

    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 12
        $0.alignment = .leading
        $0.distribution = .fillProportionally
    }

    override func addview() {
        addSubview(scrollView)
        scrollView.addSubview(mainLabel)
        scrollView.addSubview(mainDescription)
        scrollView.addSubview(stackView)
    }

    override func configure() {
        scrollView.showsVerticalScrollIndicator = true

        for term in PrivacyPolicy.allCases {
            let titleLabel = TDLabel(
                toduckFont: .boldHeader5,
                toduckColor: TDColor.Neutral.neutral800
            ).then {
                $0.setText(term.rawValue)
                $0.numberOfLines = 0
                $0.setLineHeightMultiple(1.2)
            }

            stackView.addArrangedSubview(titleLabel)

            let descriptionLabel = TDLabel(
                toduckFont: .regularCaption2,
                toduckColor: TDColor.Neutral.neutral700
            ).then {
                $0.setText(term.description)
                $0.numberOfLines = 0
                $0.setLineHeightMultiple(1.4)
            }

            stackView.addArrangedSubview(descriptionLabel)
        }
    }

    override func layout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        mainLabel.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.top).offset(18)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        mainDescription.snp.makeConstraints {
            $0.top.equalTo(mainLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        stackView.snp.makeConstraints {
            $0.top.equalTo(mainDescription.snp.bottom).offset(20)
            $0.leading.trailing.bottom.equalToSuperview().inset(16)
            $0.width.equalToSuperview().inset(16)
        }
    }
}

extension PrivacyPolicyView {
    enum PrivacyPolicy: String, CaseIterable {
        case interpretation = "해석"
        case definition = "정의"

        var description: String {
            switch self {
            case .interpretation:
                "아래에 정의된 용어들은 단수 또는 복수 형태 표기 여부에 관계없이 본 문서 내에서 동일한 의미를 갖습니다."
            case .definition:
                """
                이 약관의 목적을 위해:

                • 애플리케이션이란 To.duck(이하 “토덕”)이 라는 이름의 전자 기기에 사용자가 다운로드한 회사가 제공하는 소프트웨어 프로그램을 의미합니다.
                
                • 앱 스토어란 애플리케이션이 다운로드된 애플(애플 앱 스토어) 또는 구글(구글 플레이 스토어)에서 운영 및 개발한 디지털 유통 서비스를 의미합니다.
                
                •  계열사란 당사자가 지배하거나, 지배되거나, 당사자와 공동지배 하에 있는 기업을 의미합니다. 여기서 “지배력”은 이사 선출이나 그 밖의 권리 권한에 투표권이 있는 주식, 지분 또는 그 밖의 유가증권의 50 % 이상의 소유권을 의미합니다.
                
                • 국가란 대한민국을 의미합니다.
                
                • 회사(이 약관에서는 “회사”, “당사”, “당사” 또는 “당사의”라 함)란 대한민국 서울특별시 노원구 동일로174길 27, 서울창업디딤터 1층 ㈜루빗을 말합니다.
                
                • 기기란 컴퓨터, 휴대폰 또는 디지털 태블릿 등 서비스에 액세스할 수 있는 모든 기기를 의미합니다.
                
                • 피드백이란 당사 서비스의 속성, 성능 또는 특징에 관련하여 사용자가 보낸 피드백, 혁신 또는 제안을 의미합니다.
                
                • 무료 이용이란 구독을 구매할 때 무료로 제공될 수 있는 제한된 기간을 의미합니다.
                
                • 인앱 구매란 애플리케이션을 통하여 본 약관 및/또는 앱 스토어 자체 약관에 의거하여 제품, 품목, 서비스 또는 구독을 구매하는 것을 말합니다.
                
                • 서비스란 애플리케이션을 의미합니다.
                
                • 구독이란 회사가 사용자에게 가입 방식으로 제공하는 서비스 또는 서비스에 대한 액세스를 의미합니다.
                
                • 이용약관(이하 “약관”이라 한다)이란 사용자와 회사 간의 서비스 이용에 관한 전체 약관을 구성하는 본 이용약관을 의미합니다.
                
                • 제3자 소셜 미디어 서비스란 서비스에 의해 표시, 포함 또는 제공될 수 있는 제3자가 제공하는 모든 서비스 또는 콘텐츠(데이터, 정보, 제품 또는 서비스 포함)를 의미합니다.
                
                • 사용자란 서비스에 액세스하거나 서비스를 사용하는 개인, 회사, 또는 그러한 개인이 대신하는 법적 실체를 의미합니다.
                """
            }
        }
    }
}
