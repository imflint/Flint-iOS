//
//  File.swift
//  Domain
//
//  Created by 김호성 on 2026.01.20.
//

import Combine
import Foundation

import Entity

public protocol UserRepository {
    func checkNickname(_ nickname: String) -> AnyPublisher<NicknameCheckEntity, NetworkError>
}

