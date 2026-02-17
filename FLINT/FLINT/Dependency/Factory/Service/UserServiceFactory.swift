//
//  UserServiceFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.22.
//

import Foundation

import Data

protocol UserServiceFactory: UserAPIProviderFactory {
    func makeUserService() -> UserService
}

extension UserServiceFactory {
    func makeUserService() -> UserService {
        return DefaultUserService(userAPIProvider: makeUserAPIProvider())
    }
}
