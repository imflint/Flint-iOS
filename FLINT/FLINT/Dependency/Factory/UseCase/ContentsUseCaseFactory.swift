//
//  ContentsUseCase.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.22.
//

import Foundation

import Domain

protocol ContentsUseCaseFactory: SearchRepositoryFactory {
    func makeContentsUseCase() -> ContentsUseCase
    func makeContentsUseCase(searchRepository: SearchRepository) -> ContentsUseCase
}

extension ContentsUseCaseFactory {
    func makeContentsUseCase() -> ContentsUseCase {
        return makeContentsUseCase(searchRepository: makeSearchRepository())
    }
    func makeContentsUseCase(searchRepository: SearchRepository) -> ContentsUseCase {
        return DefaultContentsUseCase(searchRepository: searchRepository)
    }
}
