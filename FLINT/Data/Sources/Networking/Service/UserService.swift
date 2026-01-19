//
//  File.swift
//  Data
//
//  Created by 김호성 on 2026.01.19.
//

import Combine
import Foundation

import CombineMoya
import Moya

import DTO

public protocol UserService {
    func checkNickname(nickname: String) -> AnyPublisher<NicknameCheckDTO, MoyaError>
}

public final class DefaultUserService: UserService {
    private let provider = MoyaProvider<UserAPI>()
    
    public init() {
        
    }
    
    public func checkNickname(nickname: String) -> AnyPublisher<NicknameCheckDTO, MoyaError> {
        return provider.requestPublisher(.checkNickname(nickname: nickname))
            .map(NicknameCheckDTO.self)
    }
}
