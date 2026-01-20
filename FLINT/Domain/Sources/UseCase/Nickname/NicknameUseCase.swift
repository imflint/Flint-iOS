//
//  File.swift
//  Domain
//
//  Created by 김호성 on 2026.01.20.
//

import Combine
import Foundation

import Entity
import Repository

public protocol NicknameUseCase {
    func checkNickname(_ nickname: String) -> AnyPublisher<NicknameCheckEntity, NetworkError>
}

public class DefaultNicknameUseCase: NicknameUseCase {
    
    private let userRepository: UserRepository
    
    public init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    public func checkNickname(_ nickname: String) -> AnyPublisher<NicknameCheckEntity, NetworkError> {
        return userRepository.checkNickname(nickname)
    }
}
