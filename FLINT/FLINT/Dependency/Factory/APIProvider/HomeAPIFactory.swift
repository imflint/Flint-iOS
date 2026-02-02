//
//  HomeAPIFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.31.
//

import Foundation

import Moya

import Data

protocol HomeAPIFactory {
    var homeAPIProvider: MoyaProvider<HomeAPI> { get set }
    
    func makeHomeAPIProvider() -> MoyaProvider<HomeAPI>
}

extension HomeAPIFactory {
    func makeHomeAPIProvider() -> MoyaProvider<HomeAPI> {
        return homeAPIProvider
    }
}
