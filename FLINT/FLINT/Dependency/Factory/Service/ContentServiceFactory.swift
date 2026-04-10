//
//  ContentServiceFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.02.09.
//

import Foundation

import Data

protocol ContentServiceFactory: ContentAPIProviderFactory {
    func makeContentService() -> ContentService
}

extension ContentServiceFactory {
    func makeContentService() -> ContentService {
        return DefaultContentService(contentAPIProvider: makeContentAPIProvider())
    }
}
