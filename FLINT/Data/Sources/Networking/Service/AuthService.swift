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
    func socialVerify(socialVerifyRequestDTO: SocialVerifyRequestDTO) -> AnyPublisher<SocialVerifyResponseDTO, Error>
}

public final class DefaultAuthService: AuthService {
    
    private let tokenStorage: TokenStorage
    private let authAPIProvider: MoyaProvider<AuthAPI>
    
    public init(tokenStorage: TokenStorage, authAPIProvider: MoyaProvider<AuthAPI>) {
        self.tokenStorage = tokenStorage
        self.authAPIProvider = authAPIProvider
    }
    
    public func signup(_ signupInfoEntity: SignupInfoEntity) -> AnyPublisher<SignupDTO, Error> {
        guard let tempToken = tokenStorage.load(type: .tempToken) else {
            return Fail(error: TokenError.noToken).eraseToAnyPublisher()
        }
        let signupRequestDTO = SignupRequestDTO(tempToken: tempToken, signupEntity: signupInfoEntity)
        Log.d(signupRequestDTO)
        return authAPIProvider.requestPublisher(.signup(signupRequestDTO))
            .extractData(SignupDTO.self)
            .tryMap({ [weak self] in
                let loginEntity = try $0.loginEntity
                self?.tokenStorage.save(loginEntity.accessToken, type: .accessToken)
                self?.tokenStorage.save(loginEntity.refreshToken, type: .refreshToken)
                return $0
            })
            .eraseToAnyPublisher()
    }
    
    public func socialVerify(socialVerifyRequestDTO: SocialVerifyRequestDTO) -> AnyPublisher<SocialVerifyResponseDTO, Error> {
        return authAPIProvider.requestPublisher(.socialVerify(_socialVerifyRequestDTO: socialVerifyRequestDTO))
            .extractData(SocialVerifyResponseDTO.self)
            .map({ [weak self] socialVerifyResponseDTO in
                Log.d(socialVerifyResponseDTO)
                guard let self, let isRegister = socialVerifyResponseDTO.isRegistered else {
                    return socialVerifyResponseDTO
                }
                if !isRegister, let tempToken = socialVerifyResponseDTO.tempToken {
                    Log.d(tempToken)
                    tokenStorage.save(tempToken, type: .tempToken)
                } else if let accessToken = socialVerifyResponseDTO.accessToken, let refreshToken = socialVerifyResponseDTO.refreshToken {
                    tokenStorage.save(accessToken, type: .accessToken)
                    tokenStorage.save(refreshToken, type: .refreshToken)
                }
                return socialVerifyResponseDTO
            })
            .eraseToAnyPublisher()
    }
}
