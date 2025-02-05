//
//  UpdateFocusCountUseCase.swift
//  TDDomain
//
//  Created by 신효성 on 1/27/25.
//

public protocol UpdateFocusCountUseCase {
    func execute(_ count: Int)
}

final class UpdateFocusCountUseCaseImpl: UpdateFocusCountUseCase {
    private let repository: TimerRepository
    private let maxCount: Int = 5

    public init(repository: TimerRepository) {
        self.repository = repository
    }

    public func execute(_ count: Int) {
        if count > 0 && count <= maxCount {
            repository.updateFocusCount(count: count)
        }
    }
}
