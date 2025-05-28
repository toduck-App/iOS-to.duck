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
        case collection = "1. 개인정보 수집 항목 및 방법"
        case usagePurpose = "2. 개인정보 수집 및 이용 목적"
        case retention = "3. 개인정보의 보유 및 이용 기간"
        case thirdParty = "4. 개인정보의 제3자 제공"
        case consignment = "5. 개인정보 처리 위탁"
        case rights = "6. 이용자의 권리 및 행사 방법"
        case destruction = "7. 개인정보의 파기 절차 및 방법"
        case security = "8. 개인정보의 안전성 확보 조치"
        case children = "9. 아동의 개인정보 처리"
        case officer = "10. 개인정보 보호책임자 및 문의처"
        case revision = "11. 개인정보처리방침의 변경 고지"

        var description: String {
            switch self {
            case .collection:
                return """
                [필수 수집 항목]  
                - 이메일 주소, 닉네임, 전화번호  
                - 서비스 이용 기록, 접속 로그, 기기 정보(OS, 기기 모델 등), 앱 사용 통계

                [선택 수집 항목]  
                - 프로필 이미지, 루틴 이름 및 설정 정보, 감정 일기 및 메모 내용

                [수집 방법]  
                - 회원 가입 및 이용 중 사용자가 직접 입력  
                - 서비스 이용 시 자동 수집
                """
            case .usagePurpose:
                return """
                - 회원 식별 및 인증, 계정 관리  
                - 루틴 및 감정 일기 기능 등 서비스 제공  
                - 커뮤니티 운영 및 사용자 간 소통 지원  
                - 서비스 개선 및 통계 분석  
                - 고객 문의 대응 및 품질 향상
                """
            case .retention:
                return """
                회원 탈퇴 시 모든 개인정보는 즉시 파기됩니다.  
                단, 법령에 따라 다음과 같은 정보는 일정 기간 동안 보관됩니다.

                - 서비스 이용 기록: 3개월 (통신비밀보호법)  
                - 전자상거래 기록 (결제, 계약 등): 5년 (전자상거래법)
                """
            case .thirdParty:
                return """
                회사는 이용자의 개인정보를 외부에 제공하지 않으며,  
                다음의 경우에만 예외적으로 제공합니다:

                - 이용자의 사전 동의가 있는 경우  
                - 법령에 따른 요청이 있는 경우 (수사기관 등)
                """
            case .consignment:
                return """
                현재 회사는 개인정보 처리를 외부에 위탁하지 않습니다.  
                향후 위탁이 필요한 경우, 사전 고지 및 동의를 받습니다.
                """
            case .rights:
                return """
                이용자는 다음과 같은 권리를 행사할 수 있습니다:

                - 개인정보 열람, 수정, 삭제 요청  
                - 회원 탈퇴 및 처리 정지 요청

                [행사 방법]  
                - 앱 내 설정 > 고객지원 메뉴  
                - 이메일: to.duck.official@gmail.com
                """
            case .destruction:
                return """
                회사는 개인정보 보유기간 경과 또는 목적 달성 시  
                지체 없이 정보를 파기합니다.

                - 전자적 파일: 복구 불가능한 방식으로 삭제  
                - 문서 형태: 분쇄 또는 소각
                """
            case .security:
                return """
                회사는 다음과 같은 보호조치를 시행합니다:

                - 개인정보 접근 제한 및 권한 관리  
                - 해킹·바이러스 대응 보안 시스템  
                - 최소 인원만 개인정보 처리, 정기 교육  
                - 중요 정보 암호화 저장
                """
            case .children:
                return """
                회사는 만 14세 미만 아동의 개인정보를 수집하지 않으며,  
                수집 사실 인지 시 즉시 삭제 조치를 취합니다.
                """
            case .officer:
                return """
                개인정보 보호책임자: 박효준  
                문의 이메일: to.duck.official@gmail.com  
                문의 가능 시간: 평일 10:00 ~ 17:00 (공휴일 제외)
                """
            case .revision:
                return """
                본 방침은 법령 및 정책에 따라 변경될 수 있으며,  
                변경 시 앱 내 공지사항을 통해 고지합니다.

                - 공고일자: 2025년 5월 27일  
                - 시행일자: 2025년 5월 27일
                """
            }
        }
    }
}
