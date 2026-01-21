//
//  File.swift
//  Data
//
//  Created by 김호성 on 2026.01.19.
//

import Foundation

import Moya

extension TargetType {
    public var baseURL: URL {
        return NetworkConfig.baseURL
    }
    
    public var headers: [String : String]? {
        return [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    }
}
