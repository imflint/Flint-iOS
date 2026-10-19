//
//  ExplorationAPIProviderFactory.swift
//  FLINT
//
//  Created by Hosung.Kim on 2026.10.17.
//

import Foundation

import Moya

import Data

protocol ExplorationAPIProviderFactory {
    var explorationAPIProvider: MoyaProvider<ExplorationAPI> { get set }
    
    func makeExplorationAPIProvider() -> MoyaProvider<ExplorationAPI>
}

extension ExplorationAPIProviderFactory {
    func makeExplorationAPIProvider() -> MoyaProvider<ExplorationAPI> {
        return explorationAPIProvider
    }
}
