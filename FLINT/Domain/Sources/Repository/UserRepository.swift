//
//  UserRepository.swift
//  Domain
//
//  Created by 김호성 on 2026.01.20.
//

import Combine
import Foundation

import Entity

public protocol UserRepository {
    func fetchUserProfile(userId: Int64) -> AnyPublisher<UserProfileEntity, Error>
    func fetchUserBookmarkedCollections(userId: Int64) -> AnyPublisher<[CollectionEntity], Error>
    func fetchUserBookmarkedContents(userId: Int64) -> AnyPublisher<[ContentInfoEntity], Error>
    func fetchUserCreatedCollections(userId: Int64) -> AnyPublisher<[CollectionEntity], Error>
    func fetchUserKeywords(userId: Int64) -> AnyPublisher<[KeywordEntity], Error>
    
    func fetchMyProfile() -> AnyPublisher<UserProfileEntity, Error>
    func fetchMyBookmarkedCollections() -> AnyPublisher<[CollectionEntity], Error>
    func fetchMyCreatedCollections() -> AnyPublisher<[CollectionEntity], Error>
    func fetchMyKeywords() -> AnyPublisher<[KeywordEntity], Error>
    func recalculateMyKeywords() -> AnyPublisher<Void, Error>
    
    func checkNickname(_ nickname: String) -> AnyPublisher<Bool, Error>
}
