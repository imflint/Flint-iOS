//
//  File.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.22.
//

import Foundation

import Data
import Domain

protocol UserRepositoryFactory: UserServiceFactory {
    func makeUserRepository() -> UserRepository
    func makeUserRepository(userService: UserService) -> UserRepository
}

extension UserRepositoryFactory {
    func makeUserRepository() -> UserRepository {
        return makeUserRepository(userService: makeUserService())
    }
    func makeUserRepository(userService: UserService) -> UserRepository {
        return DefaultUserRepository(userService: userService)
    }
}
