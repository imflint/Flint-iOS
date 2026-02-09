//
//  FetchOTTPlatformsForContentUseCaseFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.02.09.
//

import Foundation

import Domain

protocol FetchOTTPlatformsForContentUseCaseFactory: ContentRepositoryFactory {
    func makeFetchOTTPlatformsForContentUseCase() -> FetchOTTPlatformsForContentUseCase
    func makeFetchOTTPlatformsForContentUseCase(contentRepository: ContentRepository) -> FetchOTTPlatformsForContentUseCase
}

extension FetchOTTPlatformsForContentUseCaseFactory {
    func makeFetchOTTPlatformsForContentUseCase() -> FetchOTTPlatformsForContentUseCase {
        return makeFetchOTTPlatformsForContentUseCase(contentRepository: makeContentRepository())
    }
    func makeFetchOTTPlatformsForContentUseCase(contentRepository: ContentRepository) -> FetchOTTPlatformsForContentUseCase {
        return DefaultFetchOTTPlatformsForContentUseCase(contentRepository: contentRepository)
    }
}
