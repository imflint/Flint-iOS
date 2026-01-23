//
//  File.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.22.
//

import Foundation

import Moya

import Data

protocol UserServiceFactory: UserAPIFactory {
    func makeUserService() -> UserService
    func makeUserService(userAPIProvider: MoyaProvider<UserAPI>) -> UserService
}

extension UserServiceFactory {
    func makeUserService() -> UserService {
        return makeUserService(userAPIProvider: makeUserAPIProvider())
    }
    func makeUserService(userAPIProvider: MoyaProvider<UserAPI>) -> UserService {
        return DefaultUserService(userAPIProvider: userAPIProvider)
    }
}
