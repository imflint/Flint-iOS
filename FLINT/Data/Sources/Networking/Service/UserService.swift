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

import Domain

import DTO

public protocol UserService {
    func checkNickname(_ nickname: String) -> AnyPublisher<NicknameCheckDTO, NetworkError>
}

public final class DefaultUserService: UserService {
    
    private let provider = MoyaProvider<UserAPI>()
    
    public init() {
        
    }
    
    public func checkNickname(_ nickname: String) -> AnyPublisher<NicknameCheckDTO, NetworkError> {
        return provider.requestPublisher(.checkNickname(nickname))
            .extractData(NicknameCheckDTO.self)
    }
}
