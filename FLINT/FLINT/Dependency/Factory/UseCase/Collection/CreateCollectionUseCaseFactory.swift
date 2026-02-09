//
//  CreateCollectionUseCaseFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.02.02.
//

import Foundation

import Domain

protocol CreateCollectionUseCaseFactory: CollectionRepositoryFactory {
    func makeCreateCollectionUseCase() -> CreateCollectionUseCase
    func makeCreateCollectionUseCase(collectionRepository: CollectionRepository) -> CreateCollectionUseCase
}

extension CreateCollectionUseCaseFactory {
    func makeCreateCollectionUseCase() -> CreateCollectionUseCase {
        return makeCreateCollectionUseCase(collectionRepository: makeCollectionRepository())
    }
    func makeCreateCollectionUseCase(collectionRepository: CollectionRepository) -> CreateCollectionUseCase {
        return DefaultCreateCollectionUseCase(collectionRepository: collectionRepository)
    }
}
