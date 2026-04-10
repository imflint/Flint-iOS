//
//  ContentRepositoryFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.02.09.
//

import Foundation

import Data
import Domain

protocol ContentRepositoryFactory: ContentServiceFactory {
    func makeContentRepository() -> ContentRepository
}

extension ContentRepositoryFactory {
    func makeContentRepository() -> ContentRepository {
        return DefaultContentRepository(contentService: makeContentService())
    }
}
