//
//  File.swift
//  Data
//
//  Created by 김호성 on 2026.01.19.
//

import Foundation

import Moya

import Domain

public enum UserAPI {
    case checkNickname(_ nickname: String)
    case fetchUserProfile(userId: Int64)
    case fetchMyProfile
    case fetchMyKeywords
    case fetchUserKeywords(userId: Int64)
    case fetchMyCollections
    case fetchUserCollections(userId: Int64)
    case fetchMyBookmarkedCollections
    case fetchBookmarkedCollections(userId: Int64)
    case fetchMyBookmarkedContents
    case fetchBookmarkedContents(userId: Int64)
}

extension UserAPI: TargetType {
    public var baseURL: URL {
        return NetworkConfig.baseURL
    }
    
    public var path: String {
        switch self {
        case .checkNickname:
            return "/api/v1/users/nickname/check"
        case let .fetchUserProfile(userId):
            return "/api/v1/users/\(userId)"
        case .fetchMyProfile:
            return "/api/v1/users/me"
        case .fetchMyKeywords:
            return "/api/v1/users/me/keywords"
        case let .fetchUserKeywords(userId):
            return "/api/v1/users/\(userId)/keywords"
        case .fetchMyCollections:
                return "/api/v1/users/me/collections"
        case let .fetchUserCollections(userId):
            return "/api/v1/users/\(userId)/collections"
        case .fetchMyBookmarkedCollections:
            return "/api/v1/users/me/bookmarked-collections"
        case let .fetchBookmarkedCollections(userId):
            return "/api/v1/users/\(userId)/bookmarked-collections"
        case .fetchMyBookmarkedContents:
            return "/api/v1/contents/bookmarks"
        case let .fetchBookmarkedContents(userId):
            return "/api/v1/users/\(userId)/bookmarked-contents"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .checkNickname:
            return .get
        case .fetchUserProfile:
            return .get
        case .fetchMyProfile:
            return .get
        case .fetchMyKeywords:
            return .get
        case .fetchUserKeywords:
            return .get
        case .fetchUserCollections:
            return .get
        case .fetchMyCollections:
            return .get
        case .fetchMyBookmarkedCollections:
            return .get
        case .fetchBookmarkedCollections:
            return .get
        case .fetchMyBookmarkedContents:
            return .get
        case .fetchBookmarkedContents:
            return .get
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .checkNickname(let nickname):
            return .requestParameters(
                parameters: ["nickname": nickname],
                encoding: URLEncoding.queryString)
        case .fetchUserProfile:
            return .requestPlain
        case .fetchMyProfile:
            return .requestPlain
        case .fetchMyKeywords:
            return .requestPlain
        case .fetchUserKeywords:
            return .requestPlain
        case .fetchUserCollections:
            return .requestPlain
        case .fetchMyCollections:
            return .requestPlain
        case .fetchMyBookmarkedCollections:
            return .requestPlain
        case .fetchBookmarkedCollections:
            return .requestPlain
        case .fetchMyBookmarkedContents:
            return .requestPlain
        case .fetchBookmarkedContents:
            return .requestPlain
        }
    }
}
