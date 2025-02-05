//
//  FocusCountRepository.swift
//  TDData
//
//  Created by 신효성 on 1/27/25.
//
import TDDomain

public protocol FocusCountRepository {
    func fetch() -> Int
    func update(_ focusCount: Int)
}
