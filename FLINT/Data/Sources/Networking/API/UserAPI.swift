//
//  UserAPI.swift
//  Data
//
//  Created by 김호성 on 2026.01.19.
//

import Foundation

import Moya

import DTO

public enum UserAPI {
    case fetchUserProfile(userId: Int64)
    case fetchUserBookmarkedCollections(userId: Int64)
    case fetchUserBookmarkedContents(userId: Int64)
    case fetchUserCreatedCollections(userId: Int64)
    case fetchUserKeywords(userId: Int64)
    
    case fetchMyProfile
    case fetchMyBookmarkedCollections
    case fetchMyCreatedCollections
    case fetchMyKeywords
    case recalculateMyKeywords
    
    case modifyNickname(_ nickname: NicknameDTO)
    case modifyProfileImage(_ image: ProfileImageDTO)
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
        case let .fetchUserCreatedCollections(userId):
            return "/api/v1/users/\(userId)/collections"
        case let .fetchUserKeywords(userId):
            return "/api/v1/users/\(userId)/keywords"
            
        case .fetchMyProfile:
            return "/api/v1/users/me"
        case .fetchMyBookmarkedCollections:
            return "/api/v1/users/me/bookmarked-collections"
        case .fetchMyCreatedCollections:
            return "/api/v1/users/me/collections"
        case .fetchMyKeywords:
            return "/api/v1/users/me/keywords"
        case .recalculateMyKeywords:
            return "/api/v1/users/me/keywords/recalculate"
        
            
        case .modifyNickname:
            return "/api/v1/users/me/nickname"
        case .modifyProfileImage:
            return "/api/v1/users/me/profile-image"
        case .checkNickname:
            return "/api/v1/users/nickname/check"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .fetchUserProfile, .fetchUserBookmarkedCollections, .fetchUserBookmarkedContents, .fetchUserCreatedCollections, .fetchUserKeywords, .fetchMyProfile, .fetchMyBookmarkedCollections, .fetchMyCreatedCollections, .fetchMyKeywords, .checkNickname:
            return .get
        case .recalculateMyKeywords:
            return .patch
        case .modifyNickname, .modifyProfileImage:
            return .put
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case let .checkNickname(nickname):
            return .requestParameters(
                parameters: ["nickname": nickname],
                encoding: URLEncoding.queryString
            )
        case let .modifyNickname(nickname):
            return .requestJSONEncodable(nickname)
        case let .modifyProfileImage(image):
            return .requestJSONEncodable(image)
        case .fetchUserProfile, .fetchUserBookmarkedCollections, .fetchUserBookmarkedContents, .fetchUserCreatedCollections, .fetchUserKeywords, .fetchMyProfile, .fetchMyBookmarkedCollections, .fetchMyCreatedCollections, .fetchMyKeywords, .recalculateMyKeywords:
            return .requestPlain
        }
    }
}
