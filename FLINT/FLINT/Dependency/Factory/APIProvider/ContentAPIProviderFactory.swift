//
//  ContentAPIProviderFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.02.09.
//

import Foundation

import Moya

import Data

protocol ContentAPIProviderFactory {
    var contentAPIProvider: MoyaProvider<ContentAPI> { get set }
    
    func makeContentAPIProvider() -> MoyaProvider<ContentAPI>
}

extension ContentAPIProviderFactory {
    func makeContentAPIProvider() -> MoyaProvider<ContentAPI> {
        return contentAPIProvider
    }
}
