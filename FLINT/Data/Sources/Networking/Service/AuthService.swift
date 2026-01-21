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
    private let provider = MoyaProvider<AuthAPI>()
    
    public init(tokenStorage: TokenStorage) {
        self.tokenStorage = tokenStorage
    }
    
    public func signup(_ signupInfoEntity: SignupInfoEntity) -> AnyPublisher<SignupDTO, Error> {
        return provider.requestPublisher(.signup(signupInfoEntity))
            .extractData(SignupDTO.self)
    }
}
