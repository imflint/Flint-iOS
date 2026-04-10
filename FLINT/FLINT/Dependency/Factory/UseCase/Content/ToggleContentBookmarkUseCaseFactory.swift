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
}

extension ToggleContentBookmarkUseCaseFactory {
    func makeToggleContentBookmarkUseCase() -> ToggleContentBookmarkUseCase {
        return DefaultToggleContentBookmarkUseCase(bookmarkRepository: makeBookmarkRepository())
    }
}
