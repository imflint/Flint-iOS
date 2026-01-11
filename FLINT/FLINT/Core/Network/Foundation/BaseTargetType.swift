//
//  BaseTargetType.swift
//  FLINT
//
//  Created by 진소은 on 1/10/26.
//

import Foundation

import Moya

public protocol BaseTargetType: TargetType {
    var extraHeaders: [String: String] { get }
}

public extension BaseTargetType {
    var baseURL: URL {
        NetworkEnvironment.config.baseURL
    }
    
    var headers: [String : String]? {
        var header = NetworkEnvironment.config.defaultHeaders
        extraHeaders.forEach { header[$0.key] = $0.value }
        return header
    }
    
    var extraHeaders: [String: String] { [:] }
    
    var validationType: ValidationType {
        .successCodes
    }
    
    var sampleData: Data {
        Data()
    }
}

