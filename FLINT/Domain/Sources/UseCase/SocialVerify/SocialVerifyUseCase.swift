//
//  File.swift
//  Domain
//
//  Created by 김호성 on 2026.01.23.
//

import Combine
import Foundation

import Entity
import Repository

public protocol SocialVerifyUseCase {
    func socialVerify(socialVerifyEntity: SocialVerifyEntity) -> AnyPublisher<SocialVerifyResultEntity, Error>
}

public final class DefaultSocialVerifyUseCase: SocialVerifyUseCase {
    
    private let authRepository: AuthRepository
    
    public init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    public func socialVerify(socialVerifyEntity: SocialVerifyEntity) -> AnyPublisher<SocialVerifyResultEntity, Error> {
        return authRepository.socialVerify(socialVerifyEntity: socialVerifyEntity)
    }
}
