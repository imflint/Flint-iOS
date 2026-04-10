//
//  CheckNicknameUseCase.swift
//  Domain
//
//  Created by 김호성 on 2026.01.20.
//

import Combine
import Foundation

import Entity
import Repository

public protocol CheckNicknameUseCase {
    func callAsFunction(_ nickname: String) -> AnyPublisher<Bool, Error>
}

public final class DefaultCheckNicknameUseCase: CheckNicknameUseCase {
    
    private let userRepository: UserRepository
    
    public init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    public func callAsFunction(_ nickname: String) -> AnyPublisher<Bool, Error> {
        return userRepository.checkNickname(nickname)
    }
}
