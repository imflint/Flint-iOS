//
//  AuthRepositoryImpl.swift
//  Data
//
//  Created by 김호성 on 2026.01.21.
//

import Combine
import Foundation

import Domain

import DTO
import Networking

public final class DefaultAuthRepository: AuthRepository {
    
    private let authService: AuthService
    
    public init(authService: AuthService) {
        self.authService = authService
    }
    
    public func signup(userInfo: SignupInfoEntity) -> AnyPublisher<String, Error> {
        return authService.signup(userInfo: userInfo)
            .tryMap({ try $0.userIdValue })
            .eraseToAnyPublisher()
    }
    
    public func socialVerify(socialAuthCredential: SocialVerifyEntity) -> AnyPublisher<SocialVerifyResultEntity, Error> {
        return authService.socialVerify(socialAuthCredential: SocialVerifyRequestDTO(entity: socialAuthCredential))
            .tryMap({ try $0.entity })
            .eraseToAnyPublisher()
    }
    
    public func logout() -> AnyPublisher<Void, Error> {
        return authService.logout()
    }
    
    public func refresh() -> AnyPublisher<Void, Error> {
        return authService.refresh()
    }
    
    public func withDraw(agreedTermsIds: [String]) -> AnyPublisher<Void, Error> {
        return authService.withDraw(agreedTermsIds: agreedTermsIds)
    }
}
