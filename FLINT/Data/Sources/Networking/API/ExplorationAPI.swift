//
//  ExplorationAPI.swift
//  Data
//
//  Created by Hosung.Kim on 2026.10.14.
//

import Foundation

import Moya

public enum ExplorationAPI {
    case fetchSession
    case saveSessionProgress(lastViewedPosition: Int)
}

extension ExplorationAPI: TargetType {
    public var path: String {
        switch self {
        case .fetchSession:
            return "/api/v1/exploration"
        case .saveSessionProgress:
            return "/api/v1/exploration/progress"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .fetchSession:
            return .get
        case .saveSessionProgress:
            return .patch
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .fetchSession:
            return .requestPlain
        case let .saveSessionProgress(lastViewedPosition):
            return .requestCompositeParameters(bodyParameters: [
                "lastViewedPosition": lastViewedPosition
            ], bodyEncoding: JSONEncoding.default, urlParameters: [:])
        }
    }
}
