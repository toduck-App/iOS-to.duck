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
        case purpose = "제1조 [목적]"
        case definition = "제2조 [정의]"
        case effectiveness = "제3조 [약관의 효력 및 변경]"
        case registration = "제4조 [회원가입 및 이용 계약 체결]"
        case obligation = "제5조 [회원의 의무]"
        case service = "제6조 [서비스의 제공]"
        case restriction = "제7조 [서비스 이용 제한 및 해지]"
        case privacy = "제8조 [개인정보 보호]"
        case posts = "제9조 [게시물의 관리]"
        case ip = "제10조 [지적재산권]"
        case disclaimer = "제11조 [면책조항]"
        case jurisdiction = "제12조 [관할법원 및 준거법]"

        var description: String {
            switch self {
            case .purpose:
                return "이 약관은 회사가 제공하는 ‘토덕’ 서비스의 이용과 관련하여 회사와 회원 간의 권리, 의무 및 책임사항을 규정합니다."
            case .definition:
                return """
                • "서비스": 회사가 제공하는 '토덕' 모바일 애플리케이션 및 관련 서비스  
                • "회원": 본 약관에 동의하고 서비스에 가입하여 이용 자격을 부여받은 자  
                • "콘텐츠": 루틴, 메모, 감정일기, 이미지, 게시물 등 이용자가 생성한 정보
                """
            case .effectiveness:
                return """
                본 약관은 앱 내 공지 또는 별도 통지를 통해 효력이 발생합니다.  
                회사는 관련 법령에 따라 약관을 개정할 수 있으며, 개정 시 사전 공지합니다.  
                회원이 변경된 약관에 동의하지 않을 경우, 서비스 이용을 중단하고 탈퇴할 수 있습니다.
                """
            case .registration:
                return """
                회원은 이메일 인증 및 약관 동의 후 가입할 수 있습니다.  
                회사는 다음에 해당하는 경우 가입을 거절할 수 있습니다:  
                - 타인의 정보 도용  
                - 허위 정보 입력  
                - 기타 회사 정책 위반
                """
            case .obligation:
                return """
                회원은 관련 법령, 본 약관, 회사 정책을 준수해야 하며 다음 행위를 해서는 안 됩니다:  
                - 타인의 개인정보 무단 수집/유포  
                - 욕설, 음란물 등 부적절한 게시  
                - 서비스 방해 행위
                """
            case .service:
                return """
                회사는 루틴 관리, 감정일기 작성, 커뮤니티 기능 등 다양한 서비스를 제공합니다.  
                시스템 점검이나 불가피한 사유로 일시 중단될 수 있습니다.
                """
            case .restriction:
                return """
                회사는 회원의 약관 위반 시 일시적 또는 영구적으로 서비스 이용을 제한할 수 있습니다.  
                회원은 앱 내에서 언제든지 탈퇴할 수 있으며, 탈퇴 시 콘텐츠는 일정 기간 보관 후 삭제됩니다.
                """
            case .privacy:
                return "회사는 개인정보 보호법 등 관련 법령을 준수하며, 자세한 사항은 개인정보 처리방침을 따릅니다."
            case .posts:
                return """
                회원이 작성한 게시물의 권리는 회원에게 있으며, 회사는 운영 목적 내에서 활용할 수 있습니다.  
                타인을 불쾌하게 하거나 법령에 위반되는 게시물은 사전 통보 없이 삭제될 수 있습니다.
                """
            case .ip:
                return "서비스의 UI, 콘텐츠, 캐릭터 등 모든 자료는 회사 또는 제휴사의 지적재산권에 속하며, 무단 복제·전송·수정·배포할 수 없습니다."
            case .disclaimer:
                return "회사는 천재지변, 통신망 장애 등 불가항력적 사유로 인한 손해에 대해 책임을 지지 않습니다."
            case .jurisdiction:
                return "이 약관은 대한민국 법에 따르며, 분쟁 발생 시 관할 법원은 민사소송법상 정해진 법원으로 합니다."
            }
        }
    }
}
