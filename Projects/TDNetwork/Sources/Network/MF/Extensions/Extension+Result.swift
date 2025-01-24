//
//  Extension+Result.swift
//  TDNetwork
//
//  Created by 디해 on 1/10/25.
//

import Foundation

extension Result {
    var success: Success? {
        guard case let .success(value) = self else { return nil }
        return value
    }
    
    var failure: Failure? {
        guard case let .failure(error) = self else {
            return nil }
        return error
    }
}
