//
//  File.swift
//  Data
//
//  Created by 김호성 on 2026.01.21.
//

import Combine
import Foundation

import CombineMoya
import Moya

import Domain

import DTO


public protocol AuthService {
    func signup(_ signupInfoEntity: SignupInfoEntity) -> AnyPublisher<SignupDTO, Error>
}

public final class DefaultAuthService: AuthService {
    
    private let tokenStorage: TokenStorage
    private let authAPIProvider: MoyaProvider<AuthAPI>
    
    public init(tokenStorage: TokenStorage, authAPIProvider: MoyaProvider<AuthAPI>) {
        self.tokenStorage = tokenStorage
        self.authAPIProvider = authAPIProvider
    }
    
    public func signup(_ signupInfoEntity: SignupInfoEntity) -> AnyPublisher<SignupDTO, Error> {
        let tempSignupInfoEntity = SignupInfoEntity(tempToken: NetworkConfig.tempToken, nickname: signupInfoEntity.nickname, favoriteContentIds: signupInfoEntity.favoriteContentIds, subscribedOttIds: signupInfoEntity.subscribedOttIds)
//        return authAPIProvider.requestPublisher(.signup(signupInfoEntity))
        return authAPIProvider.requestPublisher(.signup(tempSignupInfoEntity))
            .extractData(SignupDTO.self)
            .tryMap({ [weak self] in
                let loginEntity = try $0.loginEntity
                self?.tokenStorage.save(loginEntity.accessToken, type: .accessToken)
                self?.tokenStorage.save(loginEntity.refreshToken, type: .refreshToken)
                return $0
            })
            .eraseToAnyPublisher()
    }
}
