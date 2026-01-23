//
//  File.swift
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
    
    public func checkNickname(_ nickname: String) -> AnyPublisher<Bool, Error> {
        userService.checkNickname(nickname)
            .tryMap({ try $0.isAvailable })
            .eraseToAnyPublisher()
    }
    
    public func fetchUserProfile(userId: Int64) -> AnyPublisher<UserProfileEntity, Error> {
        userService.fetchUserProfile(userId: userId)
            .tryMap { try $0.entity }
            .eraseToAnyPublisher()
    }
    
    public func fetchMyProfile() -> AnyPublisher<UserProfileEntity, Error> {
        userService.fetchMyProfile()
            .tryMap { try $0.entity }
            .eraseToAnyPublisher()
    }
    
    public func fetchMyKeywords() -> AnyPublisher<[KeywordEntity], Error> {
        userService.fetchMyKeywords()
            .tryMap { dto in
                try (dto.keywords ?? []).map { try $0.entity }
            }
            .eraseToAnyPublisher()
    }
    
    public func fetchUserKeywords(userId: Int64) -> AnyPublisher<[KeywordEntity], Error> {
        userService.fetchUserKeywords(userId: userId)
            .tryMap { dto in
                try (dto.keywords ?? []).map { try $0.entity }
            }
            .eraseToAnyPublisher()
    }
    
    public func fetchMyCollections() -> AnyPublisher<[CollectionEntity], Error> {
        userService.fetchMyCollections()
            .tryMap { dto in
                try (dto.collections ?? []).map { try $0.entity }
            }
            .eraseToAnyPublisher()
    }
    
    public func fetchUserCollections(userId: Int64) -> AnyPublisher<[CollectionEntity], Error> {
        userService.fetchUserCollections(userId: userId)
            .tryMap { dto in
                try (dto.collections ?? []).map { try $0.entity }
            }
            .eraseToAnyPublisher()
    }
    
    public func fetchMyBookmarkedCollections() -> AnyPublisher<[CollectionEntity], Error> {
        userService.fetchMyBookmarkedCollections()
            .tryMap { dto in
                try (dto.collections ?? []).map { try $0.entity }
            }
            .eraseToAnyPublisher()
    }
    
    public func fetchBookmarkedCollections(userId: Int64) -> AnyPublisher<[CollectionEntity], Error> {
        userService.fetchBookmarkedCollections(userId: userId)
            .tryMap { dto in
                try (dto.collections ?? []).map { try $0.entity }
            }
            .eraseToAnyPublisher()
    }
    
    public func fetchMyBookmarkedContents() -> AnyPublisher<[ContentEntity], Error> {
        userService.fetchMyBookmarkedContents()
            .tryMap { dto in
                try (dto.contents ?? []).map { try $0.entity }
            }
            .eraseToAnyPublisher()
    }
    
    public func fetchBookmarkedContents(userId: Int64) -> AnyPublisher<[ContentEntity], Error> {
        userService.fetchBookmarkedContents(userId: userId)
            .tryMap { dto in
                try (dto.contents ?? []).map { try $0.entity }
            }
            .eraseToAnyPublisher()
    }
    
}
