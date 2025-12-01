//
//  DiaryKeyword.swift
//  TDDomain
//
//  Created by 승재 on 11/16/25.
//

import Foundation

public typealias DiaryKeywordDictionary = [DiaryKeywordCategory: [DiaryKeyword]]

public enum DiaryKeywordCategory: String, CaseIterable, Hashable {
    case person = "사람"
    case place = "장소"
    case situation = "상황"
    case result = "결과 / 느낌"
    
    public init(rawValue: String) {
        switch rawValue {
        case "사람":
            self = .person
        case "장소":
            self = .place
        case "상황":
            self = .situation
        case "결과 / 느낌":
            self = .result
        default:
            self = .place
        }
    }
}

public struct DiaryKeyword: Equatable, Identifiable, Hashable {
    public let id: UUID
    public var name: String
    public var category: DiaryKeywordCategory
    public var isCustom: Bool
    
    public init(id: UUID, name: String, category: DiaryKeywordCategory, isCustom: Bool) {
        self.id = id
        self.name = name
        self.category = category
        self.isCustom = isCustom
    }
}


public struct DefaultDiaryKeywords {
    public static let all: DiaryKeywordDictionary = [
        .person: person,
        .place: place,
        .situation: situation,
        .result: result
    ]
    
    // MARK: - Person
    static let person: [DiaryKeyword] = [
        .init(id: UUID(uuidString: "11111111-1111-1111-1111-111111111111")!,
              name: "가족", category: .person, isCustom: true),

        .init(id: UUID(uuidString: "11111111-1111-1111-1111-111111111112")!,
              name: "부모님", category: .person, isCustom: true),

        .init(id: UUID(uuidString: "11111111-1111-1111-1111-111111111113")!,
              name: "형제/자매", category: .person, isCustom: true),

        .init(id: UUID(uuidString: "11111111-1111-1111-1111-111111111114")!,
              name: "배우자", category: .person, isCustom: true),

        .init(id: UUID(uuidString: "11111111-1111-1111-1111-111111111115")!,
              name: "자녀", category: .person, isCustom: true),

        .init(id: UUID(uuidString: "11111111-1111-1111-1111-111111111116")!,
              name: "연인", category: .person, isCustom: true),

        .init(id: UUID(uuidString: "11111111-1111-1111-1111-111111111117")!,
              name: "친구", category: .person, isCustom: true),

        .init(id: UUID(uuidString: "11111111-1111-1111-1111-111111111118")!,
              name: "팀원", category: .person, isCustom: true),

        .init(id: UUID(uuidString: "11111111-1111-1111-1111-111111111119")!,
              name: "선/후배", category: .person, isCustom: true),

        .init(id: UUID(uuidString: "11111111-1111-1111-1111-11111111111A")!,
              name: "동료", category: .person, isCustom: true),

        .init(id: UUID(uuidString: "11111111-1111-1111-1111-11111111111B")!,
              name: "교수님", category: .person, isCustom: true),

        .init(id: UUID(uuidString: "11111111-1111-1111-1111-11111111111C")!,
              name: "상사", category: .person, isCustom: true),

        .init(id: UUID(uuidString: "11111111-1111-1111-1111-11111111111D")!,
              name: "새로운 사람", category: .person, isCustom: true)
    ]
    
    // MARK: - Place
    static let place: [DiaryKeyword] = [
        .init(id: UUID(uuidString: "22222222-2222-2222-2222-222222222221")!, name: "집", category: .place, isCustom: true),
        .init(id: UUID(uuidString: "22222222-2222-2222-2222-222222222222")!, name: "회사", category: .place, isCustom: true),
        .init(id: UUID(uuidString: "22222222-2222-2222-2222-222222222223")!, name: "학교", category: .place, isCustom: true),
        .init(id: UUID(uuidString: "22222222-2222-2222-2222-222222222224")!, name: "카페", category: .place, isCustom: true),
        .init(id: UUID(uuidString: "22222222-2222-2222-2222-222222222225")!, name: "공원", category: .place, isCustom: true),
        .init(id: UUID(uuidString: "22222222-2222-2222-2222-222222222226")!, name: "마트", category: .place, isCustom: true),
        .init(id: UUID(uuidString: "22222222-2222-2222-2222-222222222227")!, name: "지하철", category: .place, isCustom: true),
        .init(id: UUID(uuidString: "22222222-2222-2222-2222-222222222228")!, name: "버스", category: .place, isCustom: true),
        .init(id: UUID(uuidString: "22222222-2222-2222-2222-222222222229")!, name: "자동차", category: .place, isCustom: true),
        .init(id: UUID(uuidString: "22222222-2222-2222-2222-22222222222A")!, name: "병원", category: .place, isCustom: true),
        .init(id: UUID(uuidString: "22222222-2222-2222-2222-22222222222B")!, name: "공연장", category: .place, isCustom: true),
        .init(id: UUID(uuidString: "22222222-2222-2222-2222-22222222222C")!, name: "여행지", category: .place, isCustom: true),
        .init(id: UUID(uuidString: "22222222-2222-2222-2222-22222222222D")!, name: "도서관", category: .place, isCustom: true),
        .init(id: UUID(uuidString: "22222222-2222-2222-2222-22222222222E")!, name: "식당", category: .place, isCustom: true)
    ]
    
    // MARK: - Situation
    static let situation: [DiaryKeyword] = [
        .init(id: UUID(uuidString: "33333333-3333-3333-3333-333333333331")!, name: "공부", category: .situation, isCustom: true),
        .init(id: UUID(uuidString: "33333333-3333-3333-3333-333333333332")!, name: "직업", category: .situation, isCustom: true),
        .init(id: UUID(uuidString: "33333333-3333-3333-3333-333333333333")!, name: "발표", category: .situation, isCustom: true),
        .init(id: UUID(uuidString: "33333333-3333-3333-3333-333333333334")!, name: "보고", category: .situation, isCustom: true),
        .init(id: UUID(uuidString: "33333333-3333-3333-3333-333333333335")!, name: "독서", category: .situation, isCustom: true),
        .init(id: UUID(uuidString: "33333333-3333-3333-3333-333333333336")!, name: "게임", category: .situation, isCustom: true),
        .init(id: UUID(uuidString: "33333333-3333-3333-3333-333333333337")!, name: "산책", category: .situation, isCustom: true),
        .init(id: UUID(uuidString: "33333333-3333-3333-3333-333333333338")!, name: "장소", category: .situation, isCustom: true),
        .init(id: UUID(uuidString: "33333333-3333-3333-3333-333333333339")!, name: "요리", category: .situation, isCustom: true),
        .init(id: UUID(uuidString: "33333333-3333-3333-3333-33333333333A")!, name: "운동", category: .situation, isCustom: true),
        .init(id: UUID(uuidString: "33333333-3333-3333-3333-33333333333B")!, name: "쇼핑", category: .situation, isCustom: true),
        .init(id: UUID(uuidString: "33333333-3333-3333-3333-33333333333C")!, name: "실수", category: .situation, isCustom: true),
        .init(id: UUID(uuidString: "33333333-3333-3333-3333-33333333333D")!, name: "집중력 저하", category: .situation, isCustom: true),
        .init(id: UUID(uuidString: "33333333-3333-3333-3333-33333333333E")!, name: "날씨의 영향", category: .situation, isCustom: true),
        .init(id: UUID(uuidString: "33333333-3333-3333-3333-33333333333F")!, name: "물건 분실", category: .situation, isCustom: true),
        .init(id: UUID(uuidString: "33333333-3333-3333-3333-333333333340")!, name: "충동적", category: .situation, isCustom: true),
        .init(id: UUID(uuidString: "33333333-3333-3333-3333-333333333341")!, name: "새로운 시작", category: .situation, isCustom: true),
        .init(id: UUID(uuidString: "33333333-3333-3333-3333-333333333342")!, name: "집중력 최고", category: .situation, isCustom: true),
        .init(id: UUID(uuidString: "33333333-3333-3333-3333-333333333343")!, name: "약속", category: .situation, isCustom: true),
        .init(id: UUID(uuidString: "33333333-3333-3333-3333-333333333344")!, name: "특별한 일 없음", category: .situation, isCustom: true)
    ]

    // MARK: - Result
    static let result: [DiaryKeyword] = [
        .init(id: UUID(uuidString: "44444444-4444-4444-4444-444444444441")!, name: "칭찬을 받음", category: .result, isCustom: true),
        .init(id: UUID(uuidString: "44444444-4444-4444-4444-444444444442")!, name: "혼남", category: .result, isCustom: true),
        .init(id: UUID(uuidString: "44444444-4444-4444-4444-444444444443")!, name: "기분 좋은 대화", category: .result, isCustom: true),
        .init(id: UUID(uuidString: "44444444-4444-4444-4444-444444444444")!, name: "오해", category: .result, isCustom: true),
        .init(id: UUID(uuidString: "44444444-4444-4444-4444-444444444445")!, name: "스스로 기억해냄", category: .result, isCustom: true),
        .init(id: UUID(uuidString: "44444444-4444-4444-4444-444444444446")!, name: "소중한 만남", category: .result, isCustom: true),
        .init(id: UUID(uuidString: "44444444-4444-4444-4444-444444444447")!, name: "불편한 대화", category: .result, isCustom: true),
        .init(id: UUID(uuidString: "44444444-4444-4444-4444-444444444448")!, name: "생산적 하루", category: .result, isCustom: true),
        .init(id: UUID(uuidString: "44444444-4444-4444-4444-444444444449")!, name: "작은 성과", category: .result, isCustom: true),
        .init(id: UUID(uuidString: "44444444-4444-4444-4444-44444444444A")!, name: "계획 완료", category: .result, isCustom: true),
        .init(id: UUID(uuidString: "44444444-4444-4444-4444-44444444444B")!, name: "계획 실패", category: .result, isCustom: true),
        .init(id: UUID(uuidString: "44444444-4444-4444-4444-44444444444C")!, name: "기분 전환", category: .result, isCustom: true),
        .init(id: UUID(uuidString: "44444444-4444-4444-4444-44444444444D")!, name: "목표 달성", category: .result, isCustom: true),
        .init(id: UUID(uuidString: "44444444-4444-4444-4444-44444444444E")!, name: "건망증", category: .result, isCustom: true),
        .init(id: UUID(uuidString: "44444444-4444-4444-4444-44444444444F")!, name: "예기치 못한 일", category: .result, isCustom: true)
    ]
}
