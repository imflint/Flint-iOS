//
//  UserAPI.swift
//  Data
//
//  Created by 김호성 on 2026.01.19.
//

import Foundation

import Moya

import Domain

public enum UserAPI {
    case fetchUserProfile(userId: Int64)
    case fetchUserBookmarkedCollections(userId: Int64)
    case fetchUserBookmarkedContents(userId: Int64)
    case fetchUserCollections(userId: Int64)
    case fetchUserKeywords(userId: Int64)
    
    case fetchMyProfile
    case fetchMyBookmarkedCollections
    case fetchMyCollections
    case fetchMyKeywords
    case recalculateMyKeywords
    
    case checkNickname(_ nickname: String)
}

extension UserAPI: TargetType {
    public var path: String {
        switch self {
        case let .fetchUserProfile(userId):
            return "/api/v1/users/\(userId)"
        case let .fetchUserBookmarkedCollections(userId):
            return "/api/v1/users/\(userId)/bookmarked-collections"
        case let .fetchUserBookmarkedContents(userId):
            return "/api/v1/users/\(userId)/bookmarked-contents"
        case let .fetchUserCollections(userId):
            return "/api/v1/users/\(userId)/collections"
        case let .fetchUserKeywords(userId):
            return "/api/v1/users/\(userId)/keywords"
            
        case .fetchMyProfile:
            return "/api/v1/users/me"
        case .fetchMyBookmarkedCollections:
            return "/api/v1/users/me/bookmarked-collections"
        case .fetchMyCollections:
            return "/api/v1/users/me/collections"
        case .fetchMyKeywords:
            return "/api/v1/users/me/keywords"
        case .recalculateMyKeywords:
            return "/api/v1/users/me/keywords/recalculate"
        
        case .checkNickname:
            return "/api/v1/users/nickname/check"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .fetchUserProfile, .fetchUserBookmarkedCollections, .fetchUserBookmarkedContents, .fetchUserCollections, .fetchUserKeywords, .fetchMyProfile, .fetchMyBookmarkedCollections, .fetchMyCollections, .fetchMyKeywords, .checkNickname:
            return .get
        case .recalculateMyKeywords:
            return .patch
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case let .checkNickname(nickname):
            return .requestParameters(
                parameters: ["nickname": nickname],
                encoding: URLEncoding.queryString
            )
        case .fetchUserProfile, .fetchUserBookmarkedCollections, .fetchUserBookmarkedContents, .fetchUserCollections, .fetchUserKeywords, .fetchMyProfile, .fetchMyBookmarkedCollections, .fetchMyCollections, .fetchMyKeywords, .recalculateMyKeywords:
            return .requestPlain
        }
    }
}
