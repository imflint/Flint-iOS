//
//  ToggleCollectionBookmarkUseCaseFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.02.09.
//

import Foundation

import Domain

protocol ToggleCollectionBookmarkUseCaseFactory: BookmarkRepositoryFactory {
    func makeToggleCollectionBookmarkUseCase() -> ToggleCollectionBookmarkUseCase
}

extension ToggleCollectionBookmarkUseCaseFactory {
    func makeToggleCollectionBookmarkUseCase() -> ToggleCollectionBookmarkUseCase {
        return DefaultToggleCollectionBookmarkUseCase(bookmarkRepository: makeBookmarkRepository())
    }
}
