//
//  FetchCollectionBookmarkUsersUseCaseFactory.swift
//  FLINT
//
//  Created by 진소은 on 1/23/26.
//

import Foundation

import Domain

protocol FetchCollectionBookmarkUsersUseCaseFactory: BookmarkRepositoryFactory {
    func makeFetchCollectionBookmarkUsersUseCase() -> FetchCollectionBookmarkUsersUseCase
}

extension FetchCollectionBookmarkUsersUseCaseFactory {
    func makeFetchCollectionBookmarkUsersUseCase() -> FetchCollectionBookmarkUsersUseCase {
        return DefaultFetchCollectionBookmarkUsersUseCase(bookmarkRepository: makeBookmarkRepository())
    }
}
