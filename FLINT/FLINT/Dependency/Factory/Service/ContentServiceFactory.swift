//
//  ContentServiceFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.02.09.
//

import Foundation

import Moya

import Data

protocol ContentServiceFactory: ContentAPIProviderFactory {
    func makeContentService() -> ContentService
    func makeContentService(contentAPIProvider: MoyaProvider<ContentAPI>) -> ContentService
}

extension ContentServiceFactory {
    func makeContentService() -> ContentService {
        return makeContentService(contentAPIProvider: makeContentAPIProvider())
    }
    func makeContentService(contentAPIProvider: MoyaProvider<ContentAPI>) -> ContentService {
        return DefaultContentService(contentAPIProvider: contentAPIProvider)
    }
}
