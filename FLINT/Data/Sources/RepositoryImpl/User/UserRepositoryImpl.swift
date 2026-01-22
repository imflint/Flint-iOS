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
}
