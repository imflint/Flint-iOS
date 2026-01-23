//
//  File.swift
//  Domain
//
//  Created by 김호성 on 2026.01.20.
//

import Combine
import Foundation

import Entity

public protocol UserRepository {
    func checkNickname(_ nickname: String) -> AnyPublisher<Bool, Error>
    func fetchUserProfile(userId: Int64) -> AnyPublisher<UserProfileEntity, Error>
    func fetchMyProfile() -> AnyPublisher<UserProfileEntity, Error>
    func fetchMyKeywords() -> AnyPublisher<[KeywordEntity], Error>
    func fetchUserKeywords(userId: Int64) -> AnyPublisher<[KeywordEntity], Error>
    func fetchMyCollections() -> AnyPublisher<[CollectionEntity], Error>
    func fetchUserCollections(userId: Int64) -> AnyPublisher<[CollectionEntity], Error>
    func fetchMyBookmarkedCollections() -> AnyPublisher<[CollectionEntity], Error>
    func fetchBookmarkedCollections(userId: Int64) -> AnyPublisher<[CollectionEntity], Error>
    func fetchMyBookmarkedContents() -> AnyPublisher<[ContentInfoEntity], Error>
    func fetchBookmarkedContents(userId: Int64) -> AnyPublisher<[ContentInfoEntity], Error>
}
