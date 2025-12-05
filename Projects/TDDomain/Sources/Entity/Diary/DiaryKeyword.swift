//
//  DiaryKeyword.swift
//  TDDomain
//
//  Created by 승재 on 11/16/25.
//

import Foundation

public typealias DiaryKeywordDictionary = [UserKeywordCategory: [UserKeyword]]

public enum UserKeywordCategory: String, CaseIterable, Hashable {
    case person = "PERSON"
    case place = "PLACE"
    case situation = "SITUATION"
    case result = "RESULT"
    
    public var title: String {
        switch self {
        case .person:
            return "사람"
        case .place:
            return "장소"
        case .situation:
            return "상황"
        case .result:
            return "결과 / 느낌"
        }
    }
    
    public init(rawValue: String) {
        switch rawValue {
        case "PERSON":
            self = .person
        case "PLACE":
            self = .place
        case "SITUATION":
            self = .situation
        case "RESULT":
            self = .result
        default:
            self = .place
        }
    }
}

public struct UserKeyword: Identifiable, Hashable {
    public let id: Int
    public var name: String
    public var category: UserKeywordCategory
    
    public init(id: Int, name: String, category: UserKeywordCategory) {
        self.id = id
        self.name = name
        self.category = category
    }
}

public struct DiaryKeyword: Identifiable, Hashable {
    public let id: Int
    public let keywordName: String
    
    public init(id: Int, keywordName: String) {
        self.id = id
        self.keywordName = keywordName
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
    static let person: [UserKeyword] = [
        .init(id: 1, name: "가족", category: .person),
        .init(id: 2, name: "부모님", category: .person),
        .init(id: 3, name: "형제/자매", category: .person),
    ]
    
    // MARK: - Place
    static let place: [UserKeyword] = [
        .init(id: 4, name: "집", category: .place),
        .init(id: 5, name: "회사", category: .place),
        .init(id: 6, name: "학교", category: .place),
    ]
    
    // MARK: - Situation
    static let situation: [UserKeyword] = [
        .init(id: 7, name: "공부", category: .situation),
        .init(id: 8, name: "직업", category: .situation),
        .init(id: 9, name: "발표", category: .situation),
    ]

    // MARK: - Result
    static let result: [UserKeyword] = [
        .init(id: 10, name: "칭찬을 받음", category: .result),
        .init(id: 11, name: "혼남", category: .result),
        .init(id: 12, name: "기분 좋은 대화", category: .result),
    ]
}
