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
    func checkNickname(_ nickname: String) -> AnyPublisher<NicknameCheckDTO, Error>
}

public final class DefaultUserService: UserService {
    
    private let userAPIProvider: MoyaProvider<UserAPI>
    
    public init(userAPIProvider: MoyaProvider<UserAPI>) {
        self.userAPIProvider = userAPIProvider
    }
    
    public func checkNickname(_ nickname: String) -> AnyPublisher<NicknameCheckDTO, Error> {
        return userAPIProvider.requestPublisher(.checkNickname(nickname))
            .extractData(NicknameCheckDTO.self)
    }
}
