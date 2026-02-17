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
}

extension FetchOTTPlatformsForContentUseCaseFactory {
    func makeFetchOTTPlatformsForContentUseCase() -> FetchOTTPlatformsForContentUseCase {
        return DefaultFetchOTTPlatformsForContentUseCase(contentRepository: makeContentRepository())
    }
}
