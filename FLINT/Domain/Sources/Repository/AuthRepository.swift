//
//  AuthRepository.swift
//  Domain
//
//  Created by 김호성 on 2026.01.21.
//

import Combine
import Foundation

import Entity

public protocol AuthRepository {
    func signup(userInfo: SignupInfoEntity) -> AnyPublisher<String, Error>
    func socialVerify(socialAuthCredential: SocialVerifyEntity) -> AnyPublisher<SocialVerifyResultEntity, Error>
    func logout() -> AnyPublisher<Void, Error>
    func refresh() -> AnyPublisher<Void, Error>
    func withDraw(agreedTermsIds: [String]) -> AnyPublisher<Void, Error>
}
