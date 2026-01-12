//
//  ExampleAPI.swift
//  FLINT
//
//  Created by 진소은 on 1/10/26.
//

import Alamofire
import Moya

public enum ExampleAPI {
    case fetchExample
}

extension ExampleAPI: BaseTargetType {
    public var path: String {
        switch self {
        case .fetchExample:
            return "/test"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .fetchExample:
            return .get
        }
    }
    
    public var task: Task {
        switch self {
        case .fetchExample:
            return .requestPlain
        }
    }
}
