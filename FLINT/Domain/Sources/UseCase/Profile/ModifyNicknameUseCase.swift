//
//  File.swift
//  Domain
//
//  Created by Hosung.Kim on 2026.08.24.
//

import Combine
import Foundation

import Repository

public protocol ModifyNicknameUseCase {
    func callAsFunction(nickname: String) -> AnyPublisher<Void, Error>
}

public final class DefaultModifyNicknameUseCase: ModifyNicknameUseCase {

    private let userRepository: UserRepository

    public init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }

    public func callAsFunction(nickname: String) -> AnyPublisher<Void, Error> {
        return userRepository.modifyNickname(nickname: nickname)
    }
}
