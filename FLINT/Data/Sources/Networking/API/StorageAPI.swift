//
//  StorageAPI.swift
//  Data
//
//  Created by 김호성 on 2026.04.24.
//

import Foundation

import Moya

import Domain

import DTO

public enum StorageAPI {
    case fetchpresignedUrl(pathType: UploadType, fileExtension: FileExtension)
}

extension StorageAPI: TargetType {
    public var path: String {
        switch self {
        case .fetchpresignedUrl:
            return "/api/v1/storage/presigned-url"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .fetchpresignedUrl:
            return .get
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case let .fetchpresignedUrl(pathType, fileExtension):
            return .requestParameters(parameters: [
                "pathType": pathType.requestParameter,
                "extension": fileExtension.requestParameter
            ], encoding: URLEncoding.queryString)
        }
    }
}
