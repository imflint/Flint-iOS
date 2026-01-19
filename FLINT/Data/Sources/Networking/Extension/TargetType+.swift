//
//  File.swift
//  Data
//
//  Created by 김호성 on 2026.01.19.
//

import Moya

extension TargetType {
    var headers: [String : String]? {
        return [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    }
}
