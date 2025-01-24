//
//  MFTarget.swift
//  TDNetwork
//
//  Created by 디해 on 1/22/25.
//

import Foundation

public protocol MFTarget {
    var baseURL: URL { get }
    var path: String { get }
    var method: MFHTTPMethod { get }
    var queries: Parameters? { get }
    var task: MFTask { get }
    var headers: MFHeaders? { get }
}

extension MFTarget {
    func toRequest() -> MFRequest {
        let url = baseURL.appendingPathComponent(path).absoluteString
        let request = MFRequest(url: url)
            .setMethod(method)
        
        if let queries {
            request.addQueries(queries)
        }
        
        if let headers {
            request.addHeaders(headers)
        }
        
        switch task {
        case .requestPlain:
            return request
        case .requestJSONEncodable(let encodable):
            request.addParameters(encodable)
        case .requestParameters(let parameters):
            request.addParameters(parameters)
        }
        
        return request
    }
}
