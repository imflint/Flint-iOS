//
//  AuthAPIProviderFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.23.
//

import Foundation

import Moya

import Data

protocol AuthAPIProviderFactory {
    var authAPIProvider: MoyaProvider<AuthAPI> { get set }
    
    func makeAuthAPIProvider() -> MoyaProvider<AuthAPI>
}

extension AuthAPIProviderFactory {
    func makeAuthAPIProvider() -> MoyaProvider<AuthAPI> {
        return authAPIProvider
    }
}
