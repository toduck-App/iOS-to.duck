//
//  APIConstants.swift
//  toduck
//
//  Created by 승재 on 7/10/24.
//

import Foundation

struct APIConstants {
    static let baseURL = Bundle.main.infoDictionary?["SERVER_URL"] as? String ?? "http://localhost:8080"
}
