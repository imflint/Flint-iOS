//
//  AuthService.swift
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
    func signup(userInfo: SignupInfoEntity) -> AnyPublisher<SignupDTO, Error>
    func socialVerify(socialAuthCredential: SocialVerifyRequestDTO) -> AnyPublisher<SocialVerifyResponseDTO, Error>
    func logout() -> AnyPublisher<Void, Error>
    func withDraw(agreedTermsIds: [String]) -> AnyPublisher<Void, Error>
}

public final class DefaultAuthService: AuthService {
    
    private let tokenStorage: TokenStorage
    private let authAPIProvider: MoyaProvider<AuthAPI>
    
    public init(tokenStorage: TokenStorage, authAPIProvider: MoyaProvider<AuthAPI>) {
        self.tokenStorage = tokenStorage
        self.authAPIProvider = authAPIProvider
    }
    
    public func signup(userInfo: SignupInfoEntity) -> AnyPublisher<SignupDTO, Error> {
        guard let tempToken = tokenStorage.load(type: .tempToken) else {
            return Fail(error: TokenError.noToken).eraseToAnyPublisher()
        }
        let signupRequestDTO = SignupRequestDTO(tempToken: tempToken, signupEntity: userInfo)
        return authAPIProvider.requestPublisher(.signup(userInfo: signupRequestDTO))
            .logged()
            .mapBaseResponseData(SignupDTO.self)
            .tryMap({ [weak self] in
                let loginEntity = try $0.loginEntity
                self?.tokenStorage.save(loginEntity.accessToken, type: .accessToken)
                self?.tokenStorage.save(loginEntity.refreshToken, type: .refreshToken)
                return $0
            })
            .eraseToAnyPublisher()
    }
    
    public func socialVerify(socialAuthCredential: SocialVerifyRequestDTO) -> AnyPublisher<SocialVerifyResponseDTO, Error> {
        return authAPIProvider.requestPublisher(.socialVerify(socialAuthCredential: socialAuthCredential))
            .logged()
            .mapBaseResponseData(SocialVerifyResponseDTO.self)
            .map({ [weak self] socialVerifyResponseDTO in
                guard let self, let isRegister = socialVerifyResponseDTO.isRegistered else {
                    return socialVerifyResponseDTO
                }
                if !isRegister, let tempToken = socialVerifyResponseDTO.tempToken {
                    tokenStorage.save(tempToken, type: .tempToken)
                } else if let accessToken = socialVerifyResponseDTO.accessToken, let refreshToken = socialVerifyResponseDTO.refreshToken {
                    tokenStorage.save(accessToken, type: .accessToken)
                    tokenStorage.save(refreshToken, type: .refreshToken)
                }
                return socialVerifyResponseDTO
            })
            .eraseToAnyPublisher()
    }
    
    public func logout() -> AnyPublisher<Void, Error> {
        guard let refreshToken = tokenStorage.load(type: .refreshToken) else {
            return Fail(error: TokenError.noToken).eraseToAnyPublisher()
        }
        return authAPIProvider.requestPublisher(.logout(refreshToken: refreshToken))
            .logged()
            .mapBaseResponseData(BlankData.self)
            .map({ [weak self] _ in
                self?.tokenStorage.clearAll()
            })
            .eraseToAnyPublisher()
    }
    
    public func withDraw(agreedTermsIds: [String]) -> AnyPublisher<Void, Error> {
        return authAPIProvider.requestPublisher(.withdraw(agreedTermsIds: agreedTermsIds))
            .logged()
            .mapBaseResponseData(BlankData.self)
            .map({ _ in })
            .eraseToAnyPublisher()
    }
}
