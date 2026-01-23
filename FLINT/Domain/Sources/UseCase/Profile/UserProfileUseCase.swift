//
//  UserProfileUseCase.swift
//  Domain
//
//  Created by 진소은 on 1/22/26.
//


import Combine
import Foundation

import Entity
import Repository

public protocol UserProfileUseCase {
    func fetchUserProfile(userId: Int64) -> AnyPublisher<UserProfileEntity, Error>
    func fetchMyProfile() -> AnyPublisher<UserProfileEntity, Error>
    func fetchMyKeywords() -> AnyPublisher<[KeywordEntity], Error>
    func fetchUserKeywords(userId: Int64) -> AnyPublisher<[KeywordEntity], Error>
    func fetchMyCollections() -> AnyPublisher<[CollectionEntity], Error>
    func fetchUserCollections(userId: Int64) -> AnyPublisher<[CollectionEntity], Error>
    func fetchMyBookmarkedCollections() -> AnyPublisher<[CollectionEntity], Error>
    func fetchBookmarkedCollections(userId: Int64) -> AnyPublisher<[CollectionEntity], Error>
    func fetchMyBookmarkedContents() -> AnyPublisher<[ContentEntity], Error>
    func fetchBookmarkedContents(userId: Int64) -> AnyPublisher<[ContentEntity], Error>
}

public final class DefaultUserProfileUseCase: UserProfileUseCase {
    
    private let userRepository: UserRepository
    
    public init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    public func fetchUserProfile(userId: Int64) -> AnyPublisher<UserProfileEntity, Error> {
        return userRepository.fetchUserProfile(userId: userId)
    }
    
    public func fetchMyProfile() -> AnyPublisher<UserProfileEntity, Error> {
        return userRepository.fetchMyProfile()
    }
    
    public func fetchUserKeywords(userId: Int64) -> AnyPublisher<[KeywordEntity], Error> {
        return userRepository.fetchUserKeywords(userId: userId)
    }
    
    public func fetchMyKeywords() -> AnyPublisher<[KeywordEntity], Error> {
        return userRepository.fetchMyKeywords()
    }
    
    public func fetchMyCollections() -> AnyPublisher<[CollectionEntity], Error> {
        userRepository.fetchMyCollections()
    }
    
    public func fetchUserCollections(userId: Int64) -> AnyPublisher<[CollectionEntity], Error> {
        userRepository.fetchUserCollections(userId: userId)
    }
    
    public func fetchMyBookmarkedCollections() -> AnyPublisher<[CollectionEntity], Error> {
        return userRepository.fetchMyBookmarkedCollections()
    }
    
    public func fetchBookmarkedCollections(userId: Int64) -> AnyPublisher<[CollectionEntity], Error> {
        return userRepository.fetchBookmarkedCollections(userId: userId)
    }
    
    public func fetchMyBookmarkedContents() -> AnyPublisher<[ContentEntity], Error> {
        return userRepository.fetchMyBookmarkedContents()
    }
    
    public func fetchBookmarkedContents(userId: Int64) -> AnyPublisher<[ContentEntity], Error> {
        return userRepository.fetchBookmarkedContents(userId: userId)
    }
}
