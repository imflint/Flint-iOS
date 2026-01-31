//
//  File.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.22.
//

import Foundation

import Moya

import Data

protocol UserAPIFactory {
    var userAPIProvider: MoyaProvider<UserAPI> { get set }
    
    func makeUserAPIProvider() -> MoyaProvider<UserAPI>
}

extension UserAPIFactory {
    func makeUserAPIProvider() -> MoyaProvider<UserAPI> {
        return userAPIProvider
    }
}
