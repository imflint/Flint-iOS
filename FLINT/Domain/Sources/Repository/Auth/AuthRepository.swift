//
//  File.swift
//  Domain
//
//  Created by 김호성 on 2026.01.21.
//

import Combine
import Foundation

import Entity

public protocol AuthRepository {
    func signup(_ signupInfoEntity: SignupInfoEntity) -> AnyPublisher<LoginEntity, NetworkError>
}
