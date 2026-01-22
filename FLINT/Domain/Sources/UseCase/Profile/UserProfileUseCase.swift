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
}