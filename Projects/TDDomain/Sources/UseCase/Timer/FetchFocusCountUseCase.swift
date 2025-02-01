//
//  FetchFocusCountUseCase.swift
//  TDDomain
//
//  Created by 신효성 on 1/27/25.
//

public protocol FetchFocusCountUseCase {
    func execute() -> Int
}

final class FetchFocusCountImpl: FetchFocusCountUseCase {
    private let repository: TimerRepository
    
    public init(repository: TimerRepository) {
        self.repository = repository
    }
    
    public func execute() -> Int {
        return self.repository.fetchFocusCount()
    }
}
