import SnapKit
import TDDesign
import UIKit

final class TermOfUseView: BaseView {
    private let mainLabel = TDLabel(
        toduckFont: .boldHeader3,
        toduckColor: TDColor.Neutral.neutral800
    ).then {
        $0.setText("토덕 이용 약관")
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
        scrollView.addSubview(stackView)
    }

    override func configure() {
        scrollView.showsVerticalScrollIndicator = true

        for term in TermOfUse.allCases {
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

        stackView.snp.makeConstraints {
            $0.top.equalTo(mainLabel.snp.bottom).offset(20)
            $0.leading.trailing.bottom.equalToSuperview().inset(16)
            $0.width.equalToSuperview().inset(16)
        }
    }
}

extension TermOfUseView {
    enum TermOfUse: String, CaseIterable {
        case purpose = "제 1조 [목적]"
        case definition = "제 2조 [정의]"
        case termsOfAgreement = "제 3조 [약관 등의 명시와 설명 및 개정]"

        var description: String {
            switch self {
            case .purpose:
                "이 약관은 (주)토덕(이하 '회사'라 한다)이 제공하는 온라인 성인 ADHD 환자들의 생활 개선 서비스 'To.duck'을 이용함에 있어 회사와 이용자 사이의 권리 · 의무 및 책임사항을 규정함을 목적으로 합니다."
            case .definition:
                """
                1 '사이트'란 재화 또는 용역(이하 '재화등'이라 함)을 이용자에게 제공하기 위하여 컴퓨터나 핸드폰 등 정보통신설비를 이용하여 재화등을 거래할 수 있도록 설정한 가상의 영업장을 말하며, 아울러 사이버몰을 운영하는 사업자의 의미로도 사용합니다.
                
                2 '이용자'란 '사이트'에 접속하여 이 약관에 따라 '회사'가 제공하는 '서비스'를 받는 회원을 말합니다.
                
                3 '회원'이라 함은 '사이트'에 회원등록을 한 자로서, 계속적으로 '사이트'가 제공하는 서비스를 이용할 수 있는 자를 말합니다.
                
                4 '비회원'이라 함은 회원등록을 하지 않고 '사이트'가 제공하는 서비스를 이용하는 자를 말합니다.
                """
            case .termsOfAgreement:
                """
                1 '사이트'는 이 약관의 내용과 상호 및 대표자 성명, 영업소 소재지 주소, 전화번호 · 모사전송번호 · 전자우편주소, 사업자등록번호, 통신판매업 신고번호, 개인정보관리책임자등을 이용자가 쉽게 알 수 있도록 '사이트'의 초기 서비스화면에 게시합니다.
                
                2 '사이트'는 이용자가 약관을 동의하기에 앞서 약관에 정하여져 있는 내용 중 환불 조건과 같은 중요한 내용을 이용자가 이해할 수 있도록 별도의 연결 화면 또는 팝업 화면 등을 제공하여 이용자의 확인을 구하여야 합니다.
                
                3 '사이트'는 「전자상거래 등에서의 소비자보호에 관한 법률」 , 「약관의 규제에 관한 법률」 , 「전자문서 및 전자거래기본법」 , 「전자금융거래법」 , 「전자서명법」 , 「정보통신망 이용촉진 및 정보보호 등에 관한 법률」 , 「소비자기본법」 등 관련 법을 위배하지 않는 범위에서 이 약관을 개정할 수 있습니다.
                
                4 '사이트'가 이 약관을 개정할 경우에는 적용일자 및 개정사유를 명시하여 현행 약관과 함께 사이트의 초기화면에 그 적용일자 7일 이전부터 적용일자 전일까지 공지합니다. 다만, 이용자에게 불리하게 약관 내용을 변경하는 경우에는 최소한 30일 이상의 사전 유예기간을 두고 공지합니다. 이 경우 '사이트'는 개정 전 내용과 개정 후 내용을 명확하게 비교하여 이용자가 알기 쉽도록 표시합니다.
                
                5 '사이트'가 약관을 개정할 경우에는 그 개정 약관은 그 적용 일자 이후에 체결되는 계약에만 적용되고 그 이전에 이미 체결된 계약에 대해서는 개정 전의 약관 조항이 그대로 적용됩니다. 다만 이미 계약을 체결한 이용자가 개정 약관 조항의 적용을 받기를 원하는 뜻을 제 3항에 의한 개정 약관의 공지기간 내에 '사이트'에 송신하여 '사이트'의 동의를 받은 경우에는 개정약관 조항이 적용됩니다.
                
                6 이 약관에서 정하지 아니한 사항과 이 약관의 해석에 관하여는 전자상거래 등에서의 소비자보호에 관한 법률, 약관의 규제 등에 관한 법률, 공정거래위원회가 정하는 전자상거래 등에서의 소비자 보호지침 및 관계법령 또는 상관례에 따릅니다.
                """
            }
        }
    }
}
