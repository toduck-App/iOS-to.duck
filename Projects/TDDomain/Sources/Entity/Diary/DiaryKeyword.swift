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
    public let id: Int
    public var name: String
    public var category: DiaryKeywordCategory
    public var isCustom: Bool
    
    public init(id: Int, name: String, category: DiaryKeywordCategory, isCustom: Bool) {
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
        .init(id: 1, name: "가족", category: .person, isCustom: true),
        .init(id: 2, name: "부모님", category: .person, isCustom: true),
        .init(id: 3, name: "형제/자매", category: .person, isCustom: true),
    ]
    
    // MARK: - Place
    static let place: [DiaryKeyword] = [
        .init(id: 4, name: "집", category: .place, isCustom: true),
        .init(id: 5, name: "회사", category: .place, isCustom: true),
        .init(id: 6, name: "학교", category: .place, isCustom: true),
    ]
    
    // MARK: - Situation
    static let situation: [DiaryKeyword] = [
        .init(id: 7, name: "공부", category: .situation, isCustom: true),
        .init(id: 8, name: "직업", category: .situation, isCustom: true),
        .init(id: 9, name: "발표", category: .situation, isCustom: true),
    ]

    // MARK: - Result
    static let result: [DiaryKeyword] = [
        .init(id: 10, name: "칭찬을 받음", category: .result, isCustom: true),
        .init(id: 11, name: "혼남", category: .result, isCustom: true),
        .init(id: 12, name: "기분 좋은 대화", category: .result, isCustom: true),
    ]
}
