//
//  UserAPIProviderFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.22.
//

import Foundation

import Moya

import Data

protocol UserAPIProviderFactory {
    var userAPIProvider: MoyaProvider<UserAPI> { get set }
    
    func makeUserAPIProvider() -> MoyaProvider<UserAPI>
}

extension UserAPIProviderFactory {
    func makeUserAPIProvider() -> MoyaProvider<UserAPI> {
        return userAPIProvider
    }
}
