//
//  MFTask.swift
//  TDNetwork
//
//  Created by 디해 on 1/22/25.
//

import Foundation

public enum MFTask {
    case requestPlain
    case requestJSONEncodable(Encodable)
    case requestParameters(parameters: Parameters)
}
