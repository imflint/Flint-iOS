//
//  ToggleContentBookmarkUseCaseFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.02.09.
//

import Foundation

import Domain

protocol ToggleContentBookmarkUseCaseFactory: BookmarkRepositoryFactory {
    func makeToggleContentBookmarkUseCase() -> ToggleContentBookmarkUseCase
    func makeToggleContentBookmarkUseCase(bookmarkRepository: BookmarkRepository) -> ToggleContentBookmarkUseCase
}

extension ToggleContentBookmarkUseCaseFactory {
    func makeToggleContentBookmarkUseCase() -> ToggleContentBookmarkUseCase {
        return makeToggleContentBookmarkUseCase(bookmarkRepository: makeBookmarkRepository())
    }
    func makeToggleContentBookmarkUseCase(bookmarkRepository: BookmarkRepository) -> ToggleContentBookmarkUseCase {
        return DefaultToggleContentBookmarkUseCase(bookmarkRepository: bookmarkRepository)
    }
}
