import Foundation

struct FAQItem {
    let question: String
    let answer: String
    var isExpanded: Bool = false
}

enum FAQCategory: String {
    case profile = "프로필"
    case auth = "인증"
    case login = "로그인"
    case routine = "루틴"
    case calendar = "캘린더"
    case focus = "집중"
}

struct FAQSection {
    let category: FAQCategory
    var items: [FAQItem]
}

enum FAQDataSource {
    static var sections: [FAQSection] = [
        FAQSection(
            category: .profile,
            items: [
                FAQItem(
                    question: "Q. 프로필 사진과 닉네임을 변경하고 싶어요",
                    answer: "마이페이지 > 프로필 수정에서 프로필 사진과 닉네임을 변경할 수 있어요."
                ),
                FAQItem(
                    question: "Q. 나의 대표 활동 뱃지를 변경하고 싶어요",
                    answer: "TODO"
                )
            ]
        ),
        FAQSection(
            category: .auth,
            items: [
                FAQItem(
                    question: "Q. 등록된 휴대폰 번호를 어떻게 변경하나요?",
                    answer: "TODO"
                ),
                FAQItem(
                    question: "Q. 인증번호 문자가 오지 않아요",
                    answer: "TODO"
                ),
                FAQItem(
                    question: "Q. 인증번호를 보낸 적이 없는데 인증 번호가 왔어요",
                    answer: "TODO"
                ),
                FAQItem(
                    question: "Q. 본인인증 가능 횟수를 초과했을 경우",
                    answer: "TODO"
                ),
                FAQItem(
                    question: "Q. 본인인증 시 입력정보가 올바르지 않다고 나와요",
                    answer: "TODO"
                )
            ]
        ),
        FAQSection(
            category: .login,
            items: [
                FAQItem(
                    question: "Q. 내가 로그인하지 않았는데, 로그인 알림을 받았어요",
                    answer: "TODO"
                ),
                FAQItem(
                    question: "Q. 타인이 내 계정으로 로그인한 것 같아요",
                    answer: "TODO"
                )
            ]
        ),
        FAQSection(
            category: .routine,
            items: [
                FAQItem(
                    question: "Q. 루틴은 어떻게 만들 수 있나요?",
                    answer: "TODO"
                ),
                FAQItem(
                    question: "Q. 루틴을 수정하거나 삭제하는 방법이 궁금해요",
                    answer: "TODO"
                ),
                FAQItem(
                    question: "Q. 루틴 순서를 변경하고 싶어요",
                    answer: "루틴 목록에서 꾹 눌러 드래그해 순서를 변경할 수 있어요."
                ),
                FAQItem(
                    question: "Q. 추천 루틴은 어떠한 기준으로 추천되나요?",
                    answer: "TODO"
                ),
                FAQItem(
                    question: "Q. 루틴 데이터를 초기화하고 싶어요",
                    answer: "TODO"
                )
            ]
        ),
        FAQSection(
            category: .calendar,
            items: [
                FAQItem(
                    question: "Q. 캘린더에 내가 설정한 일정이 모두 보이지 않아요.",
                    answer: "TODO"
                ),
                FAQItem(
                    question: "Q. 캘린더에서 내 일정을 더 자세히 보고싶어요.",
                    answer: "TODO"
                )
            ]
        ),
        FAQSection(
            category: .focus,
            items: [
                FAQItem(
                    question: "Q. 집중도와 집중 시간 모두 리셋하려면 어떻게 하나요?",
                    answer: "TODO"
                ),
                FAQItem(
                    question: "Q. 집중도는 어떻게 계산되는지 궁금해요",
                    answer: "TODO"
                )
            ]
        )
    ]
}
