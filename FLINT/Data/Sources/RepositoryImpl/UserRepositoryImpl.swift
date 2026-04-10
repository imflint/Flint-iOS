//
//  UserRepositoryImpl.swift
//  Data
//
//  Created by 김호성 on 2026.01.19.
//

import Combine
import Foundation

import Domain

import DTO
import Networking

public final class DefaultUserRepository: UserRepository {
    
    private let userService: UserService
    
    public init(userService: UserService) {
        self.userService = userService
    }
    
    public func fetchUserProfile(userId: Int64) -> AnyPublisher<UserProfileEntity, Error> {
        return userService.fetchUserProfile(userId: userId)
            .tryMap { try $0.entity }
            .eraseToAnyPublisher()
    }
    
    public func fetchUserBookmarkedCollections(userId: Int64) -> AnyPublisher<[CollectionEntity], Error> {
        return userService.fetchUserBookmarkedCollections(userId: userId)
            .tryMap { try $0.entities }
            .eraseToAnyPublisher()
    }
    
    public func fetchUserBookmarkedContents(userId: Int64) -> AnyPublisher<[ContentInfoEntity], Error> {
        return userService.fetchUserBookmarkedContents(userId: userId)
            .tryMap { try $0.entities }
            .eraseToAnyPublisher()
    }
    
    public func fetchUserCreatedCollections(userId: Int64) -> AnyPublisher<[CollectionEntity], Error> {
        return userService.fetchUserCreatedCollections(userId: userId)
            .tryMap { try $0.entities }
            .eraseToAnyPublisher()
    }
    
    public func fetchUserKeywords(userId: Int64) -> AnyPublisher<[KeywordEntity], Error> {
        return userService.fetchUserKeywords(userId: userId)
            .tryMap { try $0.entities }
            .eraseToAnyPublisher()
    }
    
    public func fetchMyProfile() -> AnyPublisher<UserProfileEntity, Error> {
        return userService.fetchMyProfile()
            .tryMap { try $0.entity }
            .eraseToAnyPublisher()
    }
    
    public func fetchMyBookmarkedCollections() -> AnyPublisher<[CollectionEntity], Error> {
        return userService.fetchMyBookmarkedCollections()
            .tryMap { try $0.entities }
            .eraseToAnyPublisher()
    }
    
    public func fetchMyCreatedCollections() -> AnyPublisher<[CollectionEntity], Error> {
        return userService.fetchMyCreatedCollections()
            .tryMap { try $0.entities }
            .eraseToAnyPublisher()
    }
    
    public func fetchMyKeywords() -> AnyPublisher<[KeywordEntity], Error> {
        return userService.fetchMyKeywords()
            .tryMap { try $0.entities }
            .eraseToAnyPublisher()
    }
    
    public func recalculateMyKeywords() -> AnyPublisher<Void, Error> {
        return userService.recalculateMyKeywords()
    }
    
    public func checkNickname(_ nickname: String) -> AnyPublisher<Bool, Error> {
        return userService.checkNickname(nickname)
            .tryMap({ try $0.isAvailable })
            .eraseToAnyPublisher()
    }
}
