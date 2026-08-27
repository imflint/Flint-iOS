//
//  File.swift
//  Domain
//
//  Created by Hosung.Kim on 2026.08.24.
//

import Combine
import Foundation

import Repository

public protocol ModifyProfileImageUseCase {
    func callAsFunction(key: String) -> AnyPublisher<Void, Error>
}

public final class DefaultModifyProfileImageUseCase: ModifyProfileImageUseCase {

    private let userRepository: UserRepository

    public init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }

    public func callAsFunction(key: String) -> AnyPublisher<Void, Error> {
        return userRepository.modifyProfileImage(key: key)
    }
}
