//
//  UserRepositoryFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.22.
//

import Foundation

import Data
import Domain

protocol UserRepositoryFactory: UserServiceFactory {
    func makeUserRepository() -> UserRepository
}

extension UserRepositoryFactory {
    func makeUserRepository() -> UserRepository {
        return DefaultUserRepository(userService: makeUserService())
    }
}
