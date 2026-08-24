//
//  UserService.swift
//  Data
//
//  Created by 김호성 on 2026.01.19.
//

import Combine
import Foundation

import CombineMoya
import Moya

import DTO

public protocol UserService {
    func fetchUserProfile(userId: Int64) -> AnyPublisher<UserProfileDTO, Error>
    func fetchUserBookmarkedCollections(userId: Int64) -> AnyPublisher<CollectionsDTO, Error>
    func fetchUserBookmarkedContents(userId: Int64) -> AnyPublisher<ContentsDTO, Error>
    func fetchUserCreatedCollections(userId: Int64) -> AnyPublisher<CollectionsDTO, Error>
    func fetchUserKeywords(userId: Int64) -> AnyPublisher<KeywordsDTO, Error>
    
    func fetchMyProfile() -> AnyPublisher<UserProfileDTO, Error>
    func fetchMyBookmarkedCollections() -> AnyPublisher<CollectionsDTO, Error>
    func fetchMyCreatedCollections() -> AnyPublisher<CollectionsDTO, Error>
    func fetchMyKeywords() -> AnyPublisher<KeywordsDTO, Error>
    func recalculateMyKeywords() -> AnyPublisher<Void, Error>
    
    func modifyNickname(nickname: String) -> AnyPublisher<Void, Error>
    func modifyProfileImage(key: String) -> AnyPublisher<Void, Error>
    func checkNickname(_ nickname: String) -> AnyPublisher<NicknameCheckDTO, Error>
}

public final class DefaultUserService: UserService {
    
    private let userAPIProvider: MoyaProvider<UserAPI>
    
    public init(userAPIProvider: MoyaProvider<UserAPI>) {
        self.userAPIProvider = userAPIProvider
    }
    
    public func fetchUserProfile(userId: Int64) -> AnyPublisher<UserProfileDTO, Error> {
        return userAPIProvider.requestPublisher(.fetchUserProfile(userId: userId))
            .mapBaseResponseData(UserProfileDTO.self)
    }
    
    public func fetchUserBookmarkedCollections(userId: Int64) -> AnyPublisher<CollectionsDTO, Error> {
        return userAPIProvider.requestPublisher(.fetchUserBookmarkedCollections(userId: userId))
            .mapBaseResponseData(CollectionsDTO.self)
    }
    
    public func fetchUserBookmarkedContents(userId: Int64) -> AnyPublisher<ContentsDTO, Error> {
        return userAPIProvider.requestPublisher(.fetchUserBookmarkedContents(userId: userId))
            .mapBaseResponseData(ContentsDTO.self)
    }
    
    public func fetchUserKeywords(userId: Int64) -> AnyPublisher<KeywordsDTO, any Error> {
        return userAPIProvider.requestPublisher(.fetchUserKeywords(userId: userId))
            .mapBaseResponseData(KeywordsDTO.self)
    }
    
    public func fetchUserCreatedCollections(userId: Int64) -> AnyPublisher<CollectionsDTO, Error> {
        return userAPIProvider.requestPublisher(.fetchUserCreatedCollections(userId: userId))
            .mapBaseResponseData(CollectionsDTO.self)
    }
    
    public func fetchMyProfile() -> AnyPublisher<UserProfileDTO, Error> {
        return userAPIProvider.requestPublisher(.fetchMyProfile)
            .mapBaseResponseData(UserProfileDTO.self)
    }
    
    public func fetchMyBookmarkedCollections() -> AnyPublisher<CollectionsDTO, Error> {
        return userAPIProvider.requestPublisher(.fetchMyBookmarkedCollections)
            .mapBaseResponseData(CollectionsDTO.self)
    }
    
    public func fetchMyCreatedCollections() -> AnyPublisher<CollectionsDTO, Error> {
        return userAPIProvider.requestPublisher(.fetchMyCreatedCollections)
            .mapBaseResponseData(CollectionsDTO.self)
    }
    
    public func fetchMyKeywords() -> AnyPublisher<KeywordsDTO, Error> {
        return userAPIProvider.requestPublisher(.fetchMyKeywords)
            .mapBaseResponseData(KeywordsDTO.self)
    }
    
    public func recalculateMyKeywords() -> AnyPublisher<Void, Error> {
        return userAPIProvider.requestPublisher(.recalculateMyKeywords)
            .mapBaseResponseData(BlankData.self)
            .map({ _ in })
            .eraseToAnyPublisher()
    }
    
    public func modifyNickname(nickname: String) -> AnyPublisher<Void, Error> {
        return userAPIProvider.requestPublisher(.modifyNickname(NicknameDTO(nickname: nickname)))
            .mapBaseResponseEmpty()
            .eraseToAnyPublisher()
    }
    
    public func modifyProfileImage(key: String) -> AnyPublisher<Void, Error> {
        return userAPIProvider.requestPublisher(.modifyProfileImage(ProfileImageDTO(profileImage: key)))
            .mapBaseResponseEmpty()
            .eraseToAnyPublisher()
    }
    
    public func checkNickname(_ nickname: String) -> AnyPublisher<NicknameCheckDTO, Error> {
        return userAPIProvider.requestPublisher(.checkNickname(nickname))
            .mapBaseResponseData(NicknameCheckDTO.self)
    }
}
