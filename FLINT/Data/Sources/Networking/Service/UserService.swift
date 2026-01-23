//
//  File.swift
//  Data
//
//  Created by 김호성 on 2026.01.19.
//

import Combine
import Foundation

import CombineMoya
import Moya

import Domain

import DTO

public protocol UserService {
    func checkNickname(_ nickname: String) -> AnyPublisher<NicknameCheckDTO, Error>
    func fetchUserProfile(userId: Int64) -> AnyPublisher<UserProfileDTO, Error>
    func fetchMyProfile() -> AnyPublisher<UserProfileDTO, Error>
    func fetchMyKeywords() -> AnyPublisher<KeywordsDTO, Error>
    func fetchUserKeywords(userId: Int64) -> AnyPublisher<KeywordsDTO, Error>
    func fetchMyCollections() -> AnyPublisher<UserCollectionsDTO, Error>
    func fetchUserCollections(userId: Int64) -> AnyPublisher<UserCollectionsDTO, Error>
}

public final class DefaultUserService: UserService {

    
    
    private let userAPIProvider: MoyaProvider<UserAPI>
    
    public init(userAPIProvider: MoyaProvider<UserAPI>) {
        self.userAPIProvider = userAPIProvider
    }
    
    public func checkNickname(_ nickname: String) -> AnyPublisher<NicknameCheckDTO, Error> {
        return userAPIProvider.requestPublisher(.checkNickname(nickname))
            .extractData(NicknameCheckDTO.self)
    }
    
    public func fetchUserProfile(userId: Int64) -> AnyPublisher<UserProfileDTO, Error> {
        return userAPIProvider.requestPublisher(.fetchUserProfile(userId: userId))
            .extractData(UserProfileDTO.self)
    }
    
    public func fetchMyProfile() -> AnyPublisher<UserProfileDTO, Error> {
        return userAPIProvider.requestPublisher(.fetchMyProfile)
            .extractData(UserProfileDTO.self)
    }
    
    public func fetchMyKeywords() -> AnyPublisher<KeywordsDTO, Error> {
        return userAPIProvider.requestPublisher(.fetchMyKeywords)
            .extractData(KeywordsDTO.self)
    }
    
    public func fetchUserKeywords(userId: Int64) -> AnyPublisher<KeywordsDTO, any Error> {
        return userAPIProvider.requestPublisher(.fetchUserKeywords(userId: userId))
            .extractData(KeywordsDTO.self)
    }

    public func fetchMyCollections() -> AnyPublisher<UserCollectionsDTO, Error> {
        return userAPIProvider.requestPublisher(.fetchMyCollections)
            .extractData(UserCollectionsDTO.self)
    }

    public func fetchUserCollections(userId: Int64) -> AnyPublisher<UserCollectionsDTO, Error> {
        return userAPIProvider.requestPublisher(.fetchUserCollections(userId: userId))
            .extractData(UserCollectionsDTO.self)
    }
}
